--[[
	Midnight Helper — Knowledge evaluator (RFC-002, implementation phase 2).

	A PURE function: Evaluate(request, kb) -> response. It calls no WoW API, reads no
	clock, and touches no global state. That is not a style preference — it is what lets
	the ten fixtures run outside the game with plain `lua`, in CI and locally. Every bit
	of client access belongs in the request builder, which does not exist yet.

	NOT IN MidnightHelper.toc. Phase 2 is build-and-test only. This file moves to
	Modules/KnowledgeRuntime.lua when phase 3 adds the request builder.

	Written for Lua 5.1 (the game's dialect) even though it is tested on 5.4: no goto,
	no integer division, no bitwise operators.

	Three-valued logic throughout. nil and the NULL sentinel both mean UNKNOWN, and
	unknown is neither true nor false — a rule requiring `true` does not fire on unknown.
	Same contract as ns.Aura in Modules/Auras.lua, for the same reason: "empty" and
	"unreadable" are different claims and only one of them is honest.
]]

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
local function isApplicable(ctx, obj)
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
			actual = ctx.engine.manual_disable_flag
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
local function collectMissing(ctx, obj, rule)
	local out, effects = {}, (rule.result or {}).missing_input_effect or {}
	local names = (rule.result or {}).reports_missing or {}
	for i = 1, #names do
		local def = findInput(obj, names[i])
		local label = (def and def.missing_input_label) or names[i]
		out[#out + 1] = { label = label, name = names[i], effect = effects[names[i]], def = def }
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

function M.Evaluate(request, kb)
	local ctx = {
		request = request,
		kb = kb,
		engine = {},
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
		return buildResponse(ctx, route.owner, route.output, collectMissing(ctx, route.obj, route.rule), route.output.confidence)
	end

	return {
		status = "unknown",
		knowledge_object_ids = ctx.contributors,
		missing_inputs = {},
		confidence = "unknown",
		not_now_keys = {},
	}
end

return M
