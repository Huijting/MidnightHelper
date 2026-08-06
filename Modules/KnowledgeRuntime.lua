--[[
	Midnight Helper — Knowledge runtime (RFC-002, implementation phase 3).

	Two halves with a hard line between them:

	  Evaluate(request, kb, engine)  PURE. No WoW API, no clock, no globals. This is the
	                                 same code the ten fixtures run against outside the
	                                 game, moved here unchanged from tools/.
	  BuildRequest()                 The ONLY place that touches the client. Anything it
	                                 cannot read honestly becomes nil — never false, and
	                                 never a plausible-looking default.

	That line is what lets a wrong answer be reproduced without logging in: dump the
	request with /mhknow save and replay it as a fixture.

	Registered in MidnightHelper.toc since 2026-08-01, so this file runs at login. It
	writes no globals and touches no API while loading; tools/check_knowledge_inert.lua
	proves that on every run rather than asserting it.

	tools/run_knowledge_fixtures.lua loads THIS file, so the code the ten fixtures prove is
	the code that ships. Keep it that way: a second copy would drift, and the fixtures
	would go on passing against something the player never runs.

	Lua 5.1 dialect (the game's): no goto, no integer division, no bitwise operators.
]]


-- The client passes (addonName, ns) to every .toc-loaded file; the fixture runner passes
-- the same two by hand. Only BuildRequest uses ns — the evaluator below never touches it,
-- which is what keeps it pure.
local _, ns = ...
ns = ns or {}

local M = {}

local UNKNOWN = setmetatable({}, { __tostring = function() return "unknown" end })
M.UNKNOWN = UNKNOWN

local CONFIDENCE_ORDER = { unknown = 1, low = 2, medium = 3, high = 4 }

--------------------------------------------------------------------------------
-- Small helpers
--------------------------------------------------------------------------------

local function isNull(v, NULL)
	return v == nil or v == NULL or v == UNKNOWN
end

local function contains(list, value)
	for i = 1, #list do
		if list[i] == value then
			return true
		end
	end
	return false
end

--- Walk a dotted path. A missing segment yields nil (unknown), never an error.
local function resolvePath(root, path)
	if root == nil or path == nil then
		return nil
	end
	local cur = root
	for segment in string.gmatch(path, "[^%.]+") do
		if type(cur) ~= "table" then
			return nil
		end
		cur = cur[segment]
		if cur == nil then
			return nil
		end
	end
	return cur
end

--- Split a where/when key into (path, operator) per where_grammar v0.1.
local function splitPredicateKey(key)
	local suffixes = {
		{ ".count_gte", "count_gte" },
		{ ".count_lte", "count_lte" },
		{ "_gte", "gte" },
		{ "_lte", "lte" },
		{ "_gt", "gt" },
		{ "_lt", "lt" },
		{ "_ne", "ne" },
	}
	for i = 1, #suffixes do
		local suffix, op = suffixes[i][1], suffixes[i][2]
		if #key > #suffix and string.sub(key, -#suffix) == suffix then
			return string.sub(key, 1, #key - #suffix), op
		end
	end
	return key, "eq"
end

--- Compare two values three-valued. Returns true, false or UNKNOWN.
local function compare(op, actual, expected, NULL)
	if op == "eq" then
		-- `x: null` in a rule asks "is this unknown?", which IS answerable.
		if expected == nil then
			return isNull(actual, NULL)
		end
		if isNull(actual, NULL) then
			return UNKNOWN
		end
		return actual == expected
	end
	if op == "ne" then
		if isNull(actual, NULL) then
			return UNKNOWN
		end
		return actual ~= expected
	end
	if op == "count_gte" or op == "count_lte" then
		if type(actual) ~= "table" then
			return UNKNOWN
		end
		local n = #actual
		if op == "count_gte" then
			return n >= expected
		end
		return n <= expected
	end
	if isNull(actual, NULL) or type(actual) ~= "number" or type(expected) ~= "number" then
		return UNKNOWN
	end
	if op == "gt" then return actual > expected end
	if op == "gte" then return actual >= expected end
	if op == "lt" then return actual < expected end
	if op == "lte" then return actual <= expected end
	return UNKNOWN
end

--- Conjunction over three-valued terms: false wins over unknown, unknown over true.
local function andAll(values)
	local sawUnknown = false
	for i = 1, #values do
		local v = values[i]
		if v == false then
			return false
		elseif v == UNKNOWN then
			sawUnknown = true
		end
	end
	if sawUnknown then
		return UNKNOWN
	end
	return true
end

local function orAny(values)
	local sawUnknown = false
	for i = 1, #values do
		local v = values[i]
		if v == true then
			return true
		elseif v == UNKNOWN then
			sawUnknown = true
		end
	end
	if sawUnknown then
		return UNKNOWN
	end
	return false
end

--------------------------------------------------------------------------------
-- Input resolution (the ONLY way a KO reads the request)
--------------------------------------------------------------------------------

local function findInput(obj, name)
	for i = 1, #obj.inputs do
		if obj.inputs[i].name == name then
			return obj.inputs[i]
		end
	end
	return nil
end

--- Resolve one KO input to a request value, strictly through request_mapping.
local function resolveInput(ctx, obj, inputDef)
	if inputDef.origin == "engine" then
		return ctx.engine[inputDef.name]
	end

	local mapping = ctx.kb.requestMapping[inputDef.mapping_key]
	if not mapping then
		return nil
	end

	if mapping.request_path then
		return resolvePath(ctx.request, mapping.request_path)
	end

	if mapping.request_selector then
		local sel = mapping.request_selector
		local collection = resolvePath(ctx.request, sel.collection)
		if type(collection) ~= "table" then
			return nil
		end
		for i = 1, #collection do
			local element, match = collection[i], true
			for k, v in pairs(sel.where or {}) do
				if element[k] ~= v then
					match = false
				end
			end
			if match then
				return resolvePath(element, sel.field)
			end
		end
		return nil -- no matching element: unknown, not false
	end

	if mapping.request_subject then
		if ctx.subject == nil then
			return nil
		end
		local v = resolvePath(ctx.subject, mapping.field)
		if v == nil and mapping.default ~= nil then
			return mapping.default
		end
		return v
	end

	return nil
end

--------------------------------------------------------------------------------
-- Derived predicates
--------------------------------------------------------------------------------

local evalPredicate
-- Set for the duration of one predicate evaluation so a where clause can resolve
-- { ref = ... } against the same object's inputs and derived values.
local ctxRef

--- A where clause is a conjunction of field predicates over one collection element.
local function matchWhere(element, where, NULL)
	if where == nil then
		return true
	end
	local terms = {}
	if #where > 0 then -- long form: list of {field, op, value}
		for i = 1, #where do
			local w = where[i]
			terms[#terms + 1] = compare(w.op == "eq" and "eq" or w.op, resolvePath(element, w.field), w.value, NULL)
		end
	else
		for key, expected in pairs(where) do
			local path, op = splitPredicateKey(key)
			-- { ref = "<input or derived>" } compares against a resolved value instead of a
			-- literal. Needed for "a tier whose suggested item level fits MY item level":
			-- the threshold is the player's, not a constant we could ever write down.
			if type(expected) == "table" and expected.ref and ctxRef then
				expected = ctxRef(expected.ref)
			end
			terms[#terms + 1] = compare(op, resolvePath(element, path), expected, NULL)
		end
	end
	return andAll(terms)
end

--- Resolve a name inside a predicate's `of` list: another derived predicate, an input,
--- or a nested predicate table.
local function resolveOperand(ctx, obj, operand)
	if type(operand) == "table" then
		if operand.operator then
			return evalPredicate(ctx, obj, operand)
		end
		return operand
	end
	if type(operand) == "number" then
		return operand
	end
	if type(operand) == "string" then
		local derived = obj.derived and obj.derived[operand]
		if derived then
			return evalPredicate(ctx, obj, derived)
		end
		local inputDef = findInput(obj, operand)
		if inputDef then
			return resolveInput(ctx, obj, inputDef)
		end
		-- a bare dotted path against the request
		return resolvePath(ctx.request, operand)
	end
	return operand
end

evalPredicate = function(ctx, obj, pred)
	local NULL = ctx.kb.NULL
	local op = pred.operator

	if op == "evaluator_result" then
		return ctx.evaluatorResults and ctx.evaluatorResults[pred._name] or UNKNOWN
	end

	if op == "exists" then
		local inputDef = findInput(obj, pred.source)
		local v = inputDef and resolveInput(ctx, obj, inputDef) or resolvePath(ctx.request, pred.source)
		return not isNull(v, NULL)
	end

	if op == "equals" then
		local inputDef = findInput(obj, pred.source)
		local v = inputDef and resolveInput(ctx, obj, inputDef) or resolvePath(ctx.request, pred.source)
		return compare("eq", v, pred.value, NULL)
	end

	if op == "any" or op == "all" or op == "count_gte" or op == "count_lte" then
		local inputDef = findInput(obj, pred.source)
		local collection = inputDef and resolveInput(ctx, obj, inputDef) or resolvePath(ctx.request, pred.source)
		if type(collection) ~= "table" then
			return UNKNOWN
		end
		if op == "count_gte" then
			return #collection >= (pred.value or 1)
		end
		if op == "count_lte" then
			return #collection <= (pred.value or 0)
		end
		local results = {}
		for i = 1, #collection do
			results[#results + 1] = matchWhere(collection[i], pred.where, NULL)
		end
		if op == "any" then
			return orAny(results)
		end
		return andAll(results)
	end

	if op == "and" or op == "or" then
		local terms = {}
		for i = 1, #(pred.of or {}) do
			terms[#terms + 1] = resolveOperand(ctx, obj, pred.of[i])
		end
		if op == "and" then
			return andAll(terms)
		end
		return orAny(terms)
	end

	if op == "not" then
		local v = resolveOperand(ctx, obj, (pred.of or {})[1])
		if v == UNKNOWN then
			return UNKNOWN
		end
		return not v
	end

	-- Pick one element out of a collection: the one with the highest value of `field`
	-- among those matching `where`. Returns the ELEMENT, so a later predicate can read
	-- another field off it. Ties keep the first encountered, which is stable because the
	-- request preserves the client's own order.
	if op == "select_max" then
		local inputDef = findInput(obj, pred.source)
		local collection = inputDef and resolveInput(ctx, obj, inputDef) or resolvePath(ctx.request, pred.source)
		if type(collection) ~= "table" then
			return UNKNOWN
		end
		local best, bestValue
		local previous = ctxRef
		ctxRef = function(name) return resolveOperand(ctx, obj, name) end
		for i = 1, #collection do
			if matchWhere(collection[i], pred.where, NULL) == true then
				local value = tonumber(resolvePath(collection[i], pred.field))
				if value and (bestValue == nil or value > bestValue) then
					best, bestValue = collection[i], value
				end
			end
		end
		ctxRef = previous
		if best == nil then
			return UNKNOWN
		end
		return best
	end

	-- Read one field off whatever another predicate selected.
	if op == "field" then
		local source = resolveOperand(ctx, obj, pred.source)
		if type(source) ~= "table" then
			return UNKNOWN
		end
		local value = resolvePath(source, pred.field)
		if isNull(value, NULL) then
			return UNKNOWN
		end
		return value
	end

	-- a - b, unknown if either side is. This is the item-level delta, and it must stay
	-- unknown rather than 0 when a number is missing: 0 would read as "exactly on the
	-- suggested level", which is a claim we would not have measured.
	if op == "subtract" then
		local a = resolveOperand(ctx, obj, (pred.of or {})[1])
		local b = resolveOperand(ctx, obj, (pred.of or {})[2])
		if type(a) ~= "number" or type(b) ~= "number" then
			return UNKNOWN
		end
		return a - b
	end

	if op == "sum" then
		local total = 0
		for i = 1, #(pred.of or {}) do
			local v = resolveOperand(ctx, obj, pred.of[i])
			if type(v) ~= "number" then
				return UNKNOWN
			end
			total = total + v
		end
		return total
	end

	if op == "gt" or op == "gte" or op == "lt" or op == "lte" then
		local a = resolveOperand(ctx, obj, (pred.of or {})[1])
		local b = resolveOperand(ctx, obj, (pred.of or {})[2])
		return compare(op, a, b, NULL)
	end

	return UNKNOWN
end

--- Look up a name used in a rule's `when`: derived predicate first, then input.
local function resolveWhenTerm(ctx, obj, name)
	local derived = obj.derived and obj.derived[name]
	if derived then
		derived._name = name
		return evalPredicate(ctx, obj, derived)
	end
	local inputDef = findInput(obj, name)
	if inputDef then
		return resolveInput(ctx, obj, inputDef)
	end
	return resolvePath(ctx.request, name)
end

--------------------------------------------------------------------------------
-- Applicability, staleness, scope
--------------------------------------------------------------------------------

--- An object whose required + material inputs are not all present is skipped whole:
--- no rule fires, not even its fallback. This is the difference between fixture 05
--- (the ritual selector has no tiers and stays silent) and fixture 08 (it has what it
--- needs and reports that no route can be chosen).
--- An object may state the situation it speaks in. A mismatch is NORMAL SILENCE: the
--- object contributes nothing, reports nothing, lowers no confidence and does not reach
--- the timebox. Data that does not exist in this context is absent, not missing.
---
--- The ritual tier selector was already silent everywhere but a tiered entrance, because
--- its inputs were missing there. That was correct by accident and invisible in the data;
--- applicable_when makes it something the catalog says out loud.
local function matchesContext(ctx, obj)
	local when = obj.applicable_when
	if type(when) ~= "table" then
		return true
	end
	for path, expected in pairs(when) do
		if resolvePath(ctx.request, path) ~= expected then
			return false
		end
	end
	return true
end

local function isApplicable(ctx, obj)
	if not matchesContext(ctx, obj) then
		return false, "context"
	end
	for i = 1, #obj.inputs do
		local def = obj.inputs[i]
		if def.required == true and def.materiality == "material" then
			local v = resolveInput(ctx, obj, def)
			if isNull(v, ctx.kb.NULL) then
				return false, def.name
			end
		end
	end
	return true
end

local function inScope(ctx, obj)
	local scope = obj.game_scope or {}
	local iface = ctx.request.interface
	if type(iface) == "number" then
		if type(scope.interface_min) == "number" and iface < scope.interface_min then
			return false
		end
		if type(scope.interface_max) == "number" and iface > scope.interface_max then
			return false
		end
	end
	return true
end

--- Any signal firing makes the object stale. Signals come from the request (interface,
--- season id) or the engine (manual_disable_flag). fallback_date is only consulted when
--- the request carries `today`; the evaluator never reads a clock.
local function staleSignals(ctx, obj)
	local reasons = {}
	local st = obj.staleness or {}
	for i = 1, #(st.stale_when or {}) do
		local rule = st.stale_when[i]
		local actual
		if rule.signal == "manual_disable_flag" then
			-- Per object, not one global switch: ns.db.knowledge.disabled[id] (RFC-002 C4).
			-- Absent stays nil, i.e. unknown, so an unset flag never reads as "not disabled".
			local disabled = ctx.engine.disabled
			actual = (type(disabled) == "table") and disabled[obj.id] or ctx.engine.manual_disable_flag
		else
			actual = ctx.request[rule.signal]
		end
		local op = rule.operator
		local luaOp = (op == ">=" and "gte") or (op == ">" and "gt") or (op == "<=" and "lte")
			or (op == "<" and "lt") or (op == "==" and "eq") or "eq"
		if compare(luaOp, actual, rule.value, ctx.kb.NULL) == true then
			reasons[#reasons + 1] = rule.signal .. " " .. tostring(op) .. " " .. tostring(rule.value)
		end
	end
	if st.fallback_date and ctx.request.today then
		if ctx.request.today >= st.fallback_date then
			reasons[#reasons + 1] = "today >= " .. st.fallback_date
		end
	end
	return reasons
end

--------------------------------------------------------------------------------
-- Rule firing
--------------------------------------------------------------------------------

local function ruleAllowedInMode(rule, mode)
	local ruleMode = rule.mode or "both"
	if ruleMode == "both" then
		return true
	end
	return ruleMode == mode
end

local function sortedRules(obj)
	local rules = {}
	for i = 1, #obj.rules do
		rules[i] = obj.rules[i]
	end
	table.sort(rules, function(a, b) return (a.priority or 0) < (b.priority or 0) end)
	return rules
end

--- Fire the first matching rule. Returns the rule, or nil when nothing matched.
local function fireRules(ctx, obj, mode)
	local rules = sortedRules(obj)
	local fallback
	for i = 1, #rules do
		local rule = rules[i]
		if ruleAllowedInMode(rule, mode) then
			if rule.fallback == true then
				fallback = fallback or rule
			else
				local terms = {}
				for key, expected in pairs(rule["when"] or {}) do
					local path, op = splitPredicateKey(key)
					terms[#terms + 1] = compare(op, resolveWhenTerm(ctx, obj, path), expected, ctx.kb.NULL)
				end
				if andAll(terms) == true then
					return rule
				end
			end
		end
	end
	return fallback
end

--------------------------------------------------------------------------------
-- Output + confidence
--------------------------------------------------------------------------------

local function resolveOutput(ctx, obj, rule)
	local res = rule.result or {}
	if res.output_ref then
		return obj, obj.outputs[res.output_ref], res.output_ref
	end
	if res.external_output_ref then
		local target = ctx.kb.byId[res.external_output_ref.object_id]
		if target then
			return target, target.outputs[res.external_output_ref.output_ref], res.external_output_ref.output_ref
		end
	end
	return nil
end

local function addContributor(ctx, id)
	if id and not contains(ctx.contributors, id) then
		ctx.contributors[#ctx.contributors + 1] = id
	end
end

--- Which fields this answer reports as missing, in the rule's declared order and under
--- each input's missing_input_label. Nothing else is ever reported: an input the fired
--- rule does not name is irrelevant to this answer, not hidden.
--- Only fields that are ACTUALLY absent are reported. reports_missing names what this
--- answer would report IF the field were missing; a field the request supplied must never
--- appear in missing_inputs, because that would be the report itself lying about the very
--- thing it exists to be honest about.
local function collectMissing(ctx, obj, rule)
	local out, effects = {}, (rule.result or {}).missing_input_effect or {}
	local names = (rule.result or {}).reports_missing or {}
	for i = 1, #names do
		local def = findInput(obj, names[i])
		local present = false
		if def then
			local value = resolveInput(ctx, obj, def)
			if def.missing_when == "false" then
				-- A proxy flag: it reports on something other than itself, so its VALUE is
				-- the condition. prerequisite_state_known is present and false exactly when
				-- the prerequisite state is unknown.
				present = (value == true)
			elseif isNull(value, ctx.kb.NULL) then
				present = false
			elseif type(value) == "table" and #value == 0 then
				-- An empty list is not knowledge either: a tier list with nothing in it
				-- tells the player as little as no list at all.
				present = false
			else
				present = true
			end
		end
		if not present then
			local label = (def and def.missing_input_label) or names[i]
			out[#out + 1] = { label = label, name = names[i], effect = effects[names[i]], def = def }
		end
	end
	return out
end

--- Materiality of a reported field: an explicit missing_input_effect on the firing rule
--- wins; otherwise the input's own materiality, with `contextual` resolving to material.
--- (In this catalog every contextual field that is meant to be secondary carries an
--- explicit effect, so the general "could another applicable rule resolve without it"
--- computation is not needed yet. A future KO that relies on implicit resolution will
--- need it — see VALIDATION_REPORT §6.)
local function materialityOf(entry)
	if entry.effect then
		return entry.effect
	end
	local m = entry.def and entry.def.materiality or "material"
	if m == "secondary" then
		return "secondary"
	end
	return "material"
end

local function confidencePolicy(missing, assumptionMaterial)
	for i = 1, #missing do
		if materialityOf(missing[i]) == "material" then
			return "unknown"
		end
	end
	if assumptionMaterial then
		return "medium"
	end
	for i = 1, #missing do
		if materialityOf(missing[i]) == "secondary" then
			return "medium"
		end
	end
	return "high"
end

--- A confidence policy may only LOWER what the chosen output declares, never raise it.
--- Fixture 04 is why: an output that asks a question declares `low`, and a generic
--- "all inputs known" branch has no standing to promote that to "Recommended".
local function lowerOf(declared, policy)
	local a, b = CONFIDENCE_ORDER[declared] or 1, CONFIDENCE_ORDER[policy] or 1
	if a <= b then
		return declared
	end
	return policy
end

--------------------------------------------------------------------------------
-- The pipeline (RFC-002 §5.2)
--------------------------------------------------------------------------------

--- An output may declare which measured values travel with it, and which of those fill
--- the placeholders in each copy key. That keeps the numbers out of the strings: one
--- parameterised sentence serves every tier instead of six hardcoded ones, and the values
--- are the ones actually read from the client.
local function resolveOutputExtras(ctx, obj, output)
	local fields = output.response_fields
	if type(fields) ~= "table" then
		return nil
	end

	local resolved = {}
	for name, spec in pairs(fields) do
		local value
		if spec.derived then
			local pred = obj.derived and obj.derived[spec.derived]
			if pred then
				pred._name = spec.derived
				value = evalPredicate(ctx, obj, pred)
				if type(value) == "table" and spec.field then
					value = resolvePath(value, spec.field)
				end
			end
		elseif spec.input then
			local def = findInput(obj, spec.input)
			if def then
				value = resolveInput(ctx, obj, def)
			end
		end
		if not isNull(value, ctx.kb.NULL) and type(value) ~= "table" then
			resolved[name] = value
		end
	end

	local extras = {}
	for name, value in pairs(resolved) do
		extras[name] = value
	end

	if type(output.copy_params) == "table" then
		local params = {}
		for slot, names in pairs(output.copy_params) do
			local values = {}
			for i = 1, #names do
				values[i] = resolved[names[i]]
			end
			if #values > 0 then
				params[slot] = values
			end
		end
		if next(params) ~= nil then
			extras.copy_params = params
		end
	end

	if next(extras) == nil then
		return nil
	end
	return extras
end

local function buildResponse(ctx, owner, output, missing, declaredConfidence, extras)
	local notNow = {}
	for i = 1, #(output.not_now_keys or {}) do
		notNow[i] = output.not_now_keys[i]
	end

	local missingLabels = {}
	for i = 1, #missing do
		missingLabels[i] = missing[i].label
	end

	local assumed = ctx.request.assumed_inputs or {}
	local assumptionMaterial = false
	for i = 1, #assumed do
		if ctx.assumptionUsed and ctx.assumptionUsed[assumed[i]] then
			assumptionMaterial = true
		end
	end

	local policy = confidencePolicy(missing, assumptionMaterial)
	local resolved = lowerOf(declaredConfidence or output.confidence, policy)

	-- The confidence policy is only a contributor when it actually said something: a
	-- reported gap, or a confidence lower than the output declared.
	if #missingLabels > 0 or resolved ~= (declaredConfidence or output.confidence) then
		for i = 1, #ctx.kb.objects do
			if ctx.kb.objects[i].kind == "confidence_policy" then
				addContributor(ctx, ctx.kb.objects[i].id)
			end
		end
	end

	local response = {
		status = output.status,
		title_key = output.title_key,
		why_key = output.why_key,
		first_action_key = output.first_action_key,
		not_now_keys = notNow,
		confidence = resolved,
		knowledge_object_ids = ctx.contributors,
		missing_inputs = missingLabels,
	}
	if #assumed > 0 then
		response.assumed_inputs = assumed
	end
	for k, v in pairs(extras or {}) do
		response[k] = v
	end
	return response
end

--- @param engine table|nil  engine-owned inputs (disable flags). Copied, never mutated,
---   so the caller's table cannot be changed by evaluating — purity runs both ways.
function M.Evaluate(request, kb, engine)
	local engineInputs = {}
	if type(engine) == "table" then
		for k, v in pairs(engine) do
			engineInputs[k] = v
		end
	end

	local ctx = {
		request = request,
		kb = kb,
		engine = engineInputs,
		contributors = {},
		assumptionUsed = {},
		subject = nil,
	}

	-- 1. Scope, then staleness within scope.
	local active, staleIds, staleReasons = {}, {}, {}
	for i = 1, #kb.objects do
		local obj = kb.objects[i]
		if inScope(ctx, obj) then
			local reasons = staleSignals(ctx, obj)
			if #reasons > 0 then
				local onStale = (obj.staleness or {}).on_stale
				if onStale == "degrade_to_unknown" then
					staleIds[#staleIds + 1] = obj.id
					for r = 1, #reasons do
						if not contains(staleReasons, reasons[r]) then
							staleReasons[#staleReasons + 1] = reasons[r]
						end
					end
				elseif onStale == "warn_only" then
					active[#active + 1] = obj
				end
				-- on_stale == "disable": excluded entirely
			else
				active[#active + 1] = obj
			end
		end
	end

	-- A stale object never feeds a recommendation. The notice is engine-owned.
	if #staleIds > 0 then
		ctx.engine.stale_object_ids = staleIds
		for i = 1, #active do
			local obj = active[i]
			if obj.kind == "system_policy" then
				local rule = fireRules(ctx, obj, "standalone")
				if rule then
					local owner, output = resolveOutput(ctx, obj, rule)
					if output then
						addContributor(ctx, obj.id)
						if owner.id ~= obj.id then
							addContributor(ctx, owner.id)
						end
						return buildResponse(ctx, owner, output, collectMissing(ctx, obj, rule), output.confidence, {
							stale_object_ids = staleIds,
							stale_reason = staleReasons,
						})
					end
				end
			end
		end
	end

	-- 3. Partition activities. Locked ones are not discarded — the prerequisite policy
	--    is exactly what they are for.
	local activities = request.activity_states or {}
	local selectable, locked = {}, {}
	for i = 1, #activities do
		if activities[i].available == true then
			selectable[#selectable + 1] = activities[i]
		else
			locked[#locked + 1] = activities[i]
		end
	end

	-- 4. Prerequisites. A blocking answer here ends the pipeline.
	for i = 1, #active do
		local obj = active[i]
		if obj.kind == "prerequisite_policy" then
			for a = 1, #locked do
				ctx.subject = locked[a]
				if isApplicable(ctx, obj) then
					local rule = fireRules(ctx, obj, "standalone")
					if rule and not (rule.result or {}).pass_through then
						local owner, output = resolveOutput(ctx, obj, rule)
						if output then
							addContributor(ctx, obj.id)
							if owner.id ~= obj.id then
								addContributor(ctx, owner.id)
							end
							local extras = {}
							local prereqs = ctx.subject.missing_prerequisites
							if type(prereqs) == "table" then
								for p = 1, #prereqs do
									if prereqs[p].actionable == true and not extras.prerequisite_id then
										extras.prerequisite_id = prereqs[p].id
									end
								end
							end
							return buildResponse(ctx, owner, output, collectMissing(ctx, obj, rule), output.confidence, extras)
						end
					end
				end
			end
			ctx.subject = nil
		end
	end

	-- 5. Activity selectors. First real output wins; pass_through hands on.
	local route
	for i = 1, #active do
		local obj = active[i]
		if obj.kind == "recommendation_policy" or obj.kind == "activity_selector" then
			ctx.subject = nil
			if isApplicable(ctx, obj) then
				local rule = fireRules(ctx, obj, "standalone")
				if rule and not (rule.result or {}).pass_through then
					local owner, output = resolveOutput(ctx, obj, rule)
					if output then
						addContributor(ctx, obj.id)
						if owner.id ~= obj.id then
							addContributor(ctx, owner.id)
						end
						for key in pairs(rule["when"] or {}) do
							ctx.assumptionUsed[key] = true
						end
						route = {
							obj = obj, owner = owner, output = output, rule = rule,
							subjectId = obj._subject_activity_id,
							extras = resolveOutputExtras(ctx, obj, output),
						}
						break
					end
				end
			end
		end
	end

	-- 6. Timebox: a gate on the chosen route, or its own voice when there is no route.
	local mode = route and "gate" or "standalone"
	if route and route.subjectId then
		for i = 1, #activities do
			if activities[i].activity_id == route.subjectId then
				ctx.subject = activities[i]
			end
		end
	elseif not route and #selectable == 1 then
		ctx.subject = selectable[1]
	else
		ctx.subject = nil
	end

	for i = 1, #active do
		local obj = active[i]
		if obj.kind == "runtime_gate" then
			local rule = fireRules(ctx, obj, mode)
			if rule and not (rule.result or {}).pass_through then
				local owner, output = resolveOutput(ctx, obj, rule)
				if output then
					if route then
						addContributor(ctx, route.obj.id) -- it chose the route that was measured
					end
					addContributor(ctx, obj.id)
					if owner.id ~= obj.id then
						addContributor(ctx, owner.id)
					end
					-- reports_missing of a rejected route lapses unless the replacement
					-- names the same field.
					return buildResponse(ctx, owner, output, collectMissing(ctx, obj, rule), output.confidence)
				end
			end
		end
	end

	if route then
		return buildResponse(ctx, route.owner, route.output,
			collectMissing(ctx, route.obj, route.rule), route.output.confidence, route.extras)
	end

	return {
		status = "unknown",
		knowledge_object_ids = ctx.contributors,
		missing_inputs = {},
		confidence = "unknown",
		not_now_keys = {},
	}
end

--------------------------------------------------------------------------------
-- Request builder — the only client-facing layer
--------------------------------------------------------------------------------

--- Every read is pcall-guarded and every failure yields nil. nil means "we could not
--- read this", which the evaluator treats as unknown. It never becomes false, and it
--- never becomes a default that looks like knowledge.
local function safe(fn, ...)
	if type(fn) ~= "function" then
		return nil
	end
	local ok, a, b, c, d, e = pcall(fn, ...)
	if not ok then
		return nil
	end
	return a, b, c, d, e
end

--- Interface build number, e.g. 120007. Same call SeasonTransition.lua uses.
local function ClientInterface()
	local _, _, _, iface = safe(GetBuildInfo)
	return tonumber(iface)
end

local function MythicPlusSeasonId()
	if not (C_MythicPlus and C_MythicPlus.GetCurrentSeason) then
		return nil
	end
	return tonumber(safe(C_MythicPlus.GetCurrentSeason))
end

local function GreatVaultReady()
	if not (C_WeeklyRewards and C_WeeklyRewards.HasAvailableRewards) then
		return nil -- API absent: unknown, not "no reward waiting"
	end
	local ready = safe(C_WeeklyRewards.HasAvailableRewards)
	if type(ready) ~= "boolean" then
		return nil
	end
	return ready
end

local function PlayerState()
	local state = { item_level = nil, role = nil, specialization = nil }

	local overall, equipped = safe(GetAverageItemLevel)
	local ilvl = tonumber(equipped) or tonumber(overall)
	if ilvl and ilvl > 0 then
		state.item_level = math.floor(ilvl + 0.5)
	end

	if GetSpecialization and GetSpecializationInfo then
		local idx = safe(GetSpecialization)
		if idx and idx > 0 then
			local _, name, _, _, role = safe(GetSpecializationInfo, idx)
			if type(name) == "string" and name ~= "" then
				state.specialization = name
			end
			if type(role) == "string" and role ~= "" then
				state.role = role
			end
		end
	end

	return state
end

--- Where the evaluation is happening. Measured 2026-08-01: at a Ritual Site obelisk with
--- the picker open GetTieredEntranceType returned 2 and GetTieredEntrancePDEID 235, and
--- the six tiers came back in full. Inside the running scenario every one of those read 0,
--- and out in the world the calls answer nothing.
---
--- So tier data is not something we are failing to find elsewhere — elsewhere it does not
--- exist. The context says which of those situations we are in, so an object can stay
--- silent without that silence being mistaken for a gap.
local function EvaluationContext()
	local context = { kind = "unknown", activity_type = "unknown" }

	if not (C_DelvesUI and C_DelvesUI.GetTieredEntranceType) then
		return context
	end

	local entranceType = tonumber(safe(C_DelvesUI.GetTieredEntranceType))
	if entranceType == nil then
		return context
	end

	if entranceType == 0 then
		-- A picker that reports type 0 is not offering anything: either we are inside the
		-- scenario already or nowhere near an entrance.
		context.kind = "other"
		return context
	end

	context.kind = "tiered_entrance_selection"
	-- 2 was the value at Rob's Ritual Site obelisk. It is the only value measured so far,
	-- so anything else stays "unknown" rather than being guessed into a category.
	if entranceType == 2 then
		context.activity_type = "ritual_site"
	end
	return context
end

--- The tiers on offer, one entry each, straight from the client.
---
--- Read-only by construction. SelectDelveEntranceTier would change the player's chosen
--- difficulty and RequestPartyEligibilityForDelveTiers talks to the server; a probe reads,
--- so neither is ever called from here.
---
--- failure_reason comes from IsDelveEntranceTierEnabled, which returns (isEnabled,
--- failureReason). That reason is the game's own words, which is why its provenance is
--- recorded: a reason we inferred must never be mistaken for one the client gave, and we
--- never write a third kind.
local function RitualTierEntries()
	if not (C_DelvesUI and C_DelvesUI.GetDelveEntranceTiers) then
		return nil
	end
	local tiers = safe(C_DelvesUI.GetDelveEntranceTiers)
	if type(tiers) ~= "table" or #tiers == 0 then
		return nil -- absent, which the catalog reads as "cannot see the tiers"
	end

	local entries = {}
	for i = 1, #tiers do
		local t = tiers[i]
		if type(t) == "table" and tonumber(t.tier) then
			local entry = {
				tier = tonumber(t.tier),
				unlocked = t.unlocked == true,
				suggested_item_level = tonumber(t.suggestedILvl),
				failure_reason = nil,
				failure_reason_provenance = nil,
			}
			-- Ask the game why a tier is closed rather than composing a reason ourselves.
			if C_DelvesUI.IsDelveEntranceTierEnabled then
				local ok, enabled, reason = pcall(C_DelvesUI.IsDelveEntranceTierEnabled, entry.tier)
				if ok then
					if enabled == false then
						entry.unlocked = false
					end
					if type(reason) == "string" and reason ~= "" then
						entry.failure_reason = reason
						entry.failure_reason_provenance = "game_client"
					end
				end
			end
			entries[#entries + 1] = entry
		end
	end

	if #entries == 0 then
		return nil
	end
	return entries
end

--- Ritual Sites as an activity_state.
---
--- Availability comes from ns.GetRitualWeeklyHint's `kind`, which RitualSites.lua
--- documents as: locked (renown not unlocked) / intro (this character has not finished
--- the intro chain) / pickup / inprogress, or nil when the weekly is DONE **or** the
--- state is unknowable. Those last two are not the same claim, so we disambiguate with
--- ns.IsRitualWeeklyDone instead of guessing. An unknowable state stays unknown, which
--- is exactly the case fixture 07 covers.
---
--- available_tiers is deliberately absent: nothing in this addon can read which ritual
--- tiers a character has unlocked. That makes MH-KO-RITUAL-TIER-1207-002 inapplicable,
--- so it stays silent rather than choose a tier it cannot see.
local function RitualActivityState()
	if not ns.GetRitualWeeklyHint then
		return nil
	end

	local _, kind = safe(ns.GetRitualWeeklyHint)
	local done = ns.IsRitualWeeklyDone and safe(ns.IsRitualWeeklyDone)

	local state = {
		activity_id = "ritual_site",
		available = nil,
		prerequisites_met = nil,
		prerequisite_state_known = false,
		weekly_extra_value_available = nil,  -- Tier 6 weekly quest not readable
		-- Present only at a tiered entrance. Absent elsewhere, and absent is not missing.
		available_tiers = RitualTierEntries(),
	}

	if kind == "locked" then
		state.available, state.prerequisites_met, state.prerequisite_state_known = false, false, true
		state.missing_prerequisites = { { id = "unlock_ritual_renown", actionable = true } }
	elseif kind == "intro" then
		state.available, state.prerequisites_met, state.prerequisite_state_known = false, false, true
		state.missing_prerequisites = { { id = "finish_ritual_intro_chain", actionable = true } }
	elseif kind == "pickup" or kind == "inprogress" then
		state.available, state.prerequisites_met, state.prerequisite_state_known = true, true, true
	elseif done == true then
		state.available, state.prerequisites_met, state.prerequisite_state_known = true, true, true
	end
	-- Anything else leaves every field unknown, which is the honest answer.

	return state
end

--- Completed runs from the delve log and the ritual log, newest first, capped at the
--- 20 the knowledge objects declare as their window. Both stores only ever record
--- completed runs, so `completed` is true for all of them.
local RUN_WINDOW = 20

local function RecentActivityHistory()
	local runs = {}

	local guid = safe(UnitGUID, "player")
	if guid and ns.db and type(ns.db.delveLog) == "table" then
		local store = ns.db.delveLog[guid]
		if type(store) == "table" and type(store.delves) == "table" then
			for _, entry in pairs(store.delves) do
				for _, run in ipairs((type(entry) == "table" and entry.recent) or {}) do
					runs[#runs + 1] = {
						activity_id = "delve",
						tier = tonumber(run.tier) or 0,
						completed = true,
						duration_seconds = tonumber(run.duration) or 0,
						deaths = tonumber(run.deaths) or 0,
						_ts = tonumber(run.timestamp) or 0,
					}
				end
			end
		end
	end

	if ns.GetRitualLogEntries then
		for _, row in ipairs(safe(ns.GetRitualLogEntries) or {}) do
			for _, run in ipairs((type(row.entry) == "table" and row.entry.recent) or {}) do
				runs[#runs + 1] = {
					activity_id = "ritual_site",
					tier = tonumber(run.tier) or 0,
					completed = true,
					duration_seconds = tonumber(run.duration) or 0,
					deaths = tonumber(run.deaths) or 0,
					_ts = tonumber(run.timestamp) or 0,
				}
			end
		end
	end

	table.sort(runs, function(a, b) return a._ts > b._ts end)
	while #runs > RUN_WINDOW do
		table.remove(runs)
	end
	for i = 1, #runs do
		runs[i]._ts = nil
	end
	return runs
end

--- Build a runtime request from live client state.
--- @return table request, table notes   notes lists what could not be read, for /mh know
function M.BuildRequest()
	local notes = {}
	local function note(what)
		notes[#notes + 1] = what
	end

	local request = {
		request_id = "live",
		interface = ClientInterface(),
		mythic_plus_season_id = MythicPlusSeasonId(),
		-- v1 assumes the goal. Declaring it in assumed_inputs is what stops the confidence
		-- policy from ever reporting `high` on an answer the goal decided.
		player_goal = "progress",
		assumed_inputs = { "player_goal" },
		evaluation_context = EvaluationContext(),
		-- Not observable. No default would be honest, so it stays unknown and the timebox
		-- asks instead of guessing.
		available_session_minutes = nil,
		weekly_reward_state = { great_vault_reward_ready = GreatVaultReady() },
		player_state = PlayerState(),
		activity_states = {},
		recent_activity_history = RecentActivityHistory(),
	}

	local ritual = RitualActivityState()
	if ritual then
		request.activity_states[#request.activity_states + 1] = ritual
		if request.evaluation_context.kind ~= "tiered_entrance_selection" then
			note("ritual tiers - only readable at a tiered entrance; not a gap out here")
		elseif ritual.available_tiers == nil then
			note("ritual.available_tiers - entrance is open but the client returned no usable tier list")
		end
		if ritual.prerequisite_state_known == false then
			note("ritual prerequisite state - GetRitualWeeklyHint returned no usable kind")
		end
	else
		note("ritual_site - RitualSites.lua exposed no hint function")
	end

	if request.interface == nil then
		note("interface - GetBuildInfo unreadable")
	end
	if request.mythic_plus_season_id == nil then
		note("mythic_plus_season_id - C_MythicPlus.GetCurrentSeason unreadable")
	end
	if request.weekly_reward_state.great_vault_reward_ready == nil then
		note("great_vault_reward_ready - C_WeeklyRewards unreadable")
	end
	if request.player_state.item_level == nil then
		note("player item level - GetAverageItemLevel unreadable")
	end
	if #request.recent_activity_history == 0 then
		note("recent_activity_history - no completed runs logged on this character yet")
	end

	return request, notes
end

if type(ns) == "table" then
	ns.KnowledgeRuntime = M
end

return M
