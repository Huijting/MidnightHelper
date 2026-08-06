--[[
	Midnight Helper — Knowledge Objects, Season 1 (RFC-002)

	GENERATED FILE — DO NOT EDIT BY HAND.
	Source:    docs/knowledge_proposal_v0.4/normalized_ko_catalog_v0.4.yaml
	Generator: tools/build_knowledge.py
	Regenerate with:  python tools/build_knowledge.py

	Edits here are lost on the next build. Change the upstream YAML instead.

	NOT REGISTERED IN MidnightHelper.toc ON PURPOSE. Implementation phase 1 is
	build-and-test only: nothing here reaches a player yet, and every object still
	carries status = "review", which means not player-visible.
]]


local _, ns = ...
ns = ns or {}

-- Sentinel for an upstream null. Distinct from nil so that "present but unknown"
-- survives the trip into Lua; both mean unknown to the evaluator.
local NULL = setmetatable({}, { __tostring = function() return "null" end })

local Knowledge = {
	NULL = NULL,
	schemaVersion = "0.5.0",
	catalogVersion = "0.5.0",
	-- request_mapping v0.2, verbatim. The evaluator resolves every KO input name
	-- through this table; there is no naming convention it may fall back on.
	requestMapping = {
		activity_available = {
			field = "available",
			ko_path = "activity.available",
			mapping_key = "activity_available",
			request_subject = "activity_states",
			type = "boolean|null",
		},
		activity_estimate_max = {
			field = "estimated_minutes.max",
			ko_path = "activity.estimated_minutes.max",
			mapping_key = "activity_estimate_max",
			request_subject = "activity_states",
			type = "int|null",
		},
		activity_estimate_min = {
			field = "estimated_minutes.min",
			ko_path = "activity.estimated_minutes.min",
			mapping_key = "activity_estimate_min",
			request_subject = "activity_states",
			type = "int|null",
		},
		activity_estimate_source = {
			field = "estimated_minutes.source",
			ko_path = "activity.estimated_minutes.source",
			mapping_key = "activity_estimate_source",
			request_subject = "activity_states",
			type = "enum",
			values = {
				"observed",
				"maintained",
				"unknown",
			},
		},
		activity_interruptibility = {
			field = "editorial.interruptibility",
			ko_path = "activity.interruptibility",
			mapping_key = "activity_interruptibility",
			request_subject = "activity_states",
			type = "enum",
		},
		activity_missing_prerequisites = {
			field = "missing_prerequisites",
			ko_path = "activity.missing_prerequisites",
			mapping_key = "activity_missing_prerequisites",
			request_subject = "activity_states",
			type = "array",
		},
		activity_prerequisite_state_known = {
			field = "prerequisite_state_known",
			ko_path = "activity.prerequisite_state_known",
			mapping_key = "activity_prerequisite_state_known",
			request_subject = "activity_states",
			type = "boolean",
		},
		activity_prerequisites_met = {
			field = "prerequisites_met",
			ko_path = "activity.prerequisites_met",
			mapping_key = "activity_prerequisites_met",
			request_subject = "activity_states",
			type = "boolean|null",
		},
		activity_setup_minutes = {
			default = 0,
			field = "setup_minutes",
			ko_path = "activity.setup_minutes",
			mapping_key = "activity_setup_minutes",
			request_subject = "activity_states",
			type = "int|null",
		},
		activity_states = {
			ko_path = "activity_states",
			mapping_key = "activity_states",
			request_path = "activity_states",
			type = "array",
		},
		client_interface = {
			ko_path = "client.interface",
			mapping_key = "client_interface",
			request_path = "interface",
			type = "integer",
		},
		client_season_id = {
			ko_path = "client.mythic_plus_season_id",
			mapping_key = "client_season_id",
			request_path = "mythic_plus_season_id",
			type = "integer|null",
		},
		client_today = {
			ko_path = "client.today",
			mapping_key = "client_today",
			note = "Optional. Present only when the caller chooses to supply it. Without it, staleness fallback_date is unknown and expires nothing — the evaluator never reads a clock.",
			request_path = "today",
			type = "date|null",
		},
		context_activity_type = {
			ko_path = "evaluation_context.activity_type",
			mapping_key = "context_activity_type",
			request_path = "evaluation_context.activity_type",
			type = "enum",
			values = {
				"ritual_site",
				"delve",
				"unknown",
			},
		},
		context_kind = {
			ko_path = "evaluation_context.kind",
			mapping_key = "context_kind",
			request_path = "evaluation_context.kind",
			type = "enum",
			values = {
				"tiered_entrance_selection",
				"other",
				"unknown",
			},
		},
		player_goal = {
			ko_path = "player_goal",
			mapping_key = "player_goal",
			request_path = "player_goal",
			type = "enum",
		},
		player_item_level = {
			ko_path = "player.item_level",
			mapping_key = "player_item_level",
			request_path = "player_state.item_level",
			type = "int|null",
		},
		player_role = {
			ko_path = "player.role",
			mapping_key = "player_role",
			request_path = "player_state.role",
			type = "string|null",
		},
		player_specialization = {
			ko_path = "player.specialization",
			mapping_key = "player_specialization",
			request_path = "player_state.specialization",
			type = "string|null",
		},
		recent_history = {
			ko_path = "recent_activity_history",
			mapping_key = "recent_history",
			note = "Window is exactly what the addon supplies: at most 20 completed runs (MAX_RECENT in Modules/DelveHistory.lua and Modules/RitualLog.lua). No time window.",
			request_path = "recent_activity_history",
			type = "array",
		},
		ritual_available = {
			ko_path = "ritual.available",
			mapping_key = "ritual_available",
			request_selector = {
				collection = "activity_states",
				field = "available",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "boolean|null",
		},
		ritual_extra_value = {
			ko_path = "ritual.weekly_extra_value_available",
			mapping_key = "ritual_extra_value",
			request_selector = {
				collection = "activity_states",
				field = "weekly_extra_value_available",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "boolean|null",
		},
		ritual_interruptibility = {
			ko_path = "ritual.interruptibility",
			mapping_key = "ritual_interruptibility",
			request_selector = {
				collection = "activity_states",
				field = "editorial.interruptibility",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "enum",
		},
		ritual_recommended_ilvl = {
			ko_path = "ritual.live_recommended_item_level",
			mapping_key = "ritual_recommended_ilvl",
			note = "No known WoW API supplies this today. Always null until measured in-game.",
			request_selector = {
				collection = "activity_states",
				field = "live_recommended_item_level",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "int|null",
		},
		ritual_tier_entries = {
			ko_path = "ritual.available_tiers",
			mapping_key = "ritual_tier_entries",
			request_selector = {
				collection = "activity_states",
				field = "available_tiers",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "array<tier_entry>",
		},
		ritual_tiers = {
			ko_path = "ritual.available_tiers",
			mapping_key = "ritual_tiers",
			request_selector = {
				collection = "activity_states",
				field = "available_tiers",
				where = {
					activity_id = "ritual_site",
				},
			},
			type = "array<int>",
		},
		session_minutes = {
			ko_path = "available_session_minutes",
			mapping_key = "session_minutes",
			request_path = "available_session_minutes",
			type = "int|null",
		},
		vault_ready = {
			ko_path = "weekly_reward.great_vault_reward_ready",
			mapping_key = "vault_ready",
			request_path = "weekly_reward_state.great_vault_reward_ready",
			type = "boolean|null",
		},
	},
	objects = {
		{
			copy_keys = {
				"MH_KO_STALE_TITLE",
				"MH_KO_STALE_WHY",
				"MH_KO_STALE_FIRST_ACTION",
				"MH_KO_STALE_NOT_NOW_1",
			},
			derived = {},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
			},
			id = "MH-KO-SYSTEM-STALE-000",
			inputs = {
				{
					materiality = "material",
					name = "stale_object_ids",
					origin = "engine",
					required = true,
					type = "array<string>",
				},
			},
			kind = "system_policy",
			outputs = {
				stale_knowledge = {
					confidence = "unknown",
					first_action_key = "MH_KO_STALE_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_STALE_NOT_NOW_1",
					},
					status = "defer",
					title_key = "MH_KO_STALE_TITLE",
					why_key = "MH_KO_STALE_WHY",
				},
			},
			rules = {
				{
					mode = "both",
					priority = 1,
					result = {
						output_ref = "stale_knowledge",
						reports_missing = {},
					},
					when = {
						["stale_object_ids.count_gte"] = 1,
					},
				},
			},
			source_status = "EDITORIAL_REVIEWED",
			staleness = {
				on_stale = "warn_only",
				stale_when = {},
			},
			status = "review",
			version = "0.2.0",
		},
		{
			copy_keys = {
				"MH_KO_VAULT_READY_TITLE",
				"MH_KO_VAULT_READY_WHY",
				"MH_KO_VAULT_READY_FIRST_ACTION",
				"MH_KO_VAULT_READY_NOT_NOW_1",
			},
			derived = {
				has_high_interruptibility_activity = {
					operator = "any",
					source = "activity_states",
					where = {
						available = true,
						["editorial.interruptibility"] = "high",
						prerequisites_met = true,
					},
				},
				has_selectable_world_activity = {
					operator = "any",
					source = "activity_states",
					where = {
						available = true,
						prerequisites_met = true,
					},
				},
				ritual_candidate_available = {
					operator = "equals",
					source = "ritual.available",
					value = true,
				},
				session_minutes_known = {
					operator = "exists",
					source = "available_session_minutes",
				},
				world_vault_activity_selectable = {
					of = {
						{
							of = {
								"session_minutes_known",
								"has_selectable_world_activity",
							},
							operator = "and",
						},
						"has_high_interruptibility_activity",
					},
					operator = "or",
				},
			},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
				season_ids = {
					17,
				},
			},
			id = "MH-KO-WEEKLY-POWER-1207-001",
			inputs = {
				{
					mapping_key = "vault_ready",
					materiality = "material",
					name = "weekly_reward.great_vault_reward_ready",
					origin = "request",
					required = true,
					type = "boolean|null",
				},
				{
					default = "progress",
					enum = {
						"progress",
						"vault_only",
						"learn",
						"relax",
					},
					mapping_key = "player_goal",
					materiality = "contextual",
					name = "player_goal",
					origin = "request",
					required = false,
					type = "enum",
				},
				{
					mapping_key = "ritual_available",
					materiality = "contextual",
					name = "ritual.available",
					origin = "request",
					required = false,
					type = "boolean|null",
				},
				{
					mapping_key = "activity_states",
					materiality = "contextual",
					name = "activity_states",
					origin = "request",
					required = false,
					type = "array",
				},
				{
					mapping_key = "session_minutes",
					materiality = "contextual",
					name = "available_session_minutes",
					origin = "request",
					required = false,
					type = "int|null",
				},
			},
			kind = "recommendation_policy",
			outputs = {
				vault_ready = {
					confidence = "high",
					first_action_key = "MH_KO_VAULT_READY_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_VAULT_READY_NOT_NOW_1",
					},
					status = "recommend",
					title_key = "MH_KO_VAULT_READY_TITLE",
					why_key = "MH_KO_VAULT_READY_WHY",
				},
			},
			rules = {
				{
					mode = "both",
					priority = 1,
					result = {
						output_ref = "vault_ready",
						reports_missing = {},
					},
					when = {
						["weekly_reward.great_vault_reward_ready"] = true,
					},
				},
				{
					mode = "both",
					priority = 2,
					result = {
						pass_through = true,
					},
					when = {
						ritual_candidate_available = true,
					},
				},
				{
					mode = "standalone",
					priority = 3,
					result = {
						pass_through = true,
					},
					when = {
						world_vault_activity_selectable = true,
					},
				},
			},
			source_status = "IN_GAME_VERIFIED",
			staleness = {
				fallback_date = "2026-08-18",
				on_stale = "degrade_to_unknown",
				stale_when = {
					{
						operator = ">=",
						signal = "interface",
						value = 120100,
					},
					{
						operator = ">",
						signal = "mythic_plus_season_id",
						value = 17,
					},
				},
			},
			status = "review",
			version = "0.4.0",
		},
		{
			_subject_activity_id = "ritual_site",
			applicable_when = {
				["evaluation_context.activity_type"] = "ritual_site",
				["evaluation_context.kind"] = "tiered_entrance_selection",
			},
			copy_keys = {
				"MH_KO_RITUAL_ILVL_AT_TITLE",
				"MH_KO_RITUAL_ILVL_AT_WHY",
				"MH_KO_RITUAL_ILVL_AT_FIRST_ACTION",
				"MH_KO_RITUAL_ILVL_BELOW_TITLE",
				"MH_KO_RITUAL_ILVL_BELOW_WHY",
				"MH_KO_RITUAL_ILVL_BELOW_FIRST_ACTION",
				"MH_KO_RITUAL_ILVL_FAR_TITLE",
				"MH_KO_RITUAL_ILVL_FAR_WHY",
				"MH_KO_RITUAL_ILVL_FAR_FIRST_ACTION",
				"MH_KO_RITUAL_ILVL_NOT_NOW_1",
				"MH_KO_UNKNOWN_TITLE",
				"MH_KO_UNKNOWN_WHY",
				"MH_KO_UNKNOWN_FIRST_ACTION",
				"MH_KO_UNKNOWN_NOT_NOW_1",
				"MH_KO_RITUAL_T5_TITLE",
				"MH_KO_RITUAL_T5_WHY",
				"MH_KO_RITUAL_T5_FIRST_ACTION",
				"MH_KO_RITUAL_T5_NOT_NOW_1",
				"MH_KO_RITUAL_T6_TITLE",
				"MH_KO_RITUAL_T6_WHY",
				"MH_KO_RITUAL_T6_FIRST_ACTION",
				"MH_KO_RITUAL_T6_NOT_NOW_1",
			},
			derived = {
				fitting_tier = {
					field = "tier",
					operator = "select_max",
					source = "ritual.available_tiers",
					where = {
						suggested_item_level_gte = 1,
						suggested_item_level_lte = {
							ref = "player.item_level",
						},
						unlocked = true,
					},
				},
				fitting_tier_number = {
					field = "tier",
					operator = "field",
					source = "fitting_tier",
				},
				item_level_delta = {
					of = {
						"player.item_level",
						"selected_tier_suggested_ilvl",
					},
					operator = "subtract",
				},
				selected_tier = {
					field = "tier",
					operator = "select_max",
					source = "ritual.available_tiers",
					where = {
						suggested_item_level_gte = 1,
						unlocked = true,
					},
				},
				selected_tier_number = {
					field = "tier",
					operator = "field",
					source = "selected_tier",
				},
				selected_tier_suggested_ilvl = {
					field = "suggested_item_level",
					operator = "field",
					source = "selected_tier",
				},
				tier_5_unlocked = {
					operator = "any",
					source = "ritual.available_tiers",
					where = {
						tier = 5,
						unlocked = true,
					},
				},
				tier_6_unlocked = {
					operator = "any",
					source = "ritual.available_tiers",
					where = {
						tier = 6,
						unlocked = true,
					},
				},
			},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
				season_ids = {
					17,
				},
			},
			id = "MH-KO-RITUAL-TIER-1207-002",
			inputs = {
				{
					mapping_key = "ritual_available",
					materiality = "material",
					name = "ritual.available",
					origin = "request",
					required = true,
					type = "boolean|null",
				},
				{
					mapping_key = "ritual_tier_entries",
					materiality = "contextual",
					missing_input_label = "available_tiers",
					name = "ritual.available_tiers",
					origin = "request",
					required = false,
					type = "array<tier_entry>",
				},
				{
					mapping_key = "ritual_extra_value",
					materiality = "contextual",
					missing_input_label = "weekly_extra_value_available",
					name = "ritual.weekly_extra_value_available",
					origin = "request",
					required = false,
					type = "boolean|null",
				},
				{
					mapping_key = "player_item_level",
					materiality = "contextual",
					missing_input_label = "player_item_level",
					name = "player.item_level",
					origin = "request",
					required = false,
					type = "int|null",
				},
				{
					mapping_key = "recent_history",
					materiality = "contextual",
					name = "recent_activity_history",
					origin = "request",
					required = false,
					type = "array",
				},
				{
					enum = {
						"progress",
						"vault_only",
					},
					mapping_key = "player_goal",
					materiality = "material",
					name = "player_goal",
					origin = "request",
					required = true,
					type = "enum",
				},
			},
			kind = "activity_selector",
			outputs = {
				ritual_ilvl_at_or_above = {
					confidence = "medium",
					copy_params = {
						first_action = {
							"selected_tier",
						},
						title = {
							"selected_tier",
						},
						why = {
							"selected_tier",
							"suggested_item_level",
							"player_item_level",
						},
					},
					first_action_key = "MH_KO_RITUAL_ILVL_AT_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_RITUAL_ILVL_NOT_NOW_1",
					},
					response_fields = {
						item_level_delta = {
							derived = "item_level_delta",
						},
						player_item_level = {
							input = "player.item_level",
						},
						selected_tier = {
							derived = "selected_tier_number",
						},
						suggested_item_level = {
							derived = "selected_tier_suggested_ilvl",
						},
					},
					status = "recommend",
					title_key = "MH_KO_RITUAL_ILVL_AT_TITLE",
					why_key = "MH_KO_RITUAL_ILVL_AT_WHY",
				},
				ritual_ilvl_just_below = {
					confidence = "medium",
					copy_params = {
						first_action = {
							"selected_tier",
						},
						title = {
							"selected_tier",
						},
						why = {
							"selected_tier",
							"suggested_item_level",
							"player_item_level",
						},
					},
					first_action_key = "MH_KO_RITUAL_ILVL_BELOW_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_RITUAL_ILVL_NOT_NOW_1",
					},
					response_fields = {
						item_level_delta = {
							derived = "item_level_delta",
						},
						player_item_level = {
							input = "player.item_level",
						},
						selected_tier = {
							derived = "selected_tier_number",
						},
						suggested_item_level = {
							derived = "selected_tier_suggested_ilvl",
						},
					},
					status = "conditional",
					title_key = "MH_KO_RITUAL_ILVL_BELOW_TITLE",
					why_key = "MH_KO_RITUAL_ILVL_BELOW_WHY",
				},
				ritual_ilvl_well_below = {
					confidence = "medium",
					copy_params = {
						first_action = {
							"fitting_tier",
						},
						title = {
							"selected_tier",
						},
						why = {
							"selected_tier",
							"suggested_item_level",
							"player_item_level",
						},
					},
					first_action_key = "MH_KO_RITUAL_ILVL_FAR_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_RITUAL_ILVL_NOT_NOW_1",
					},
					response_fields = {
						fitting_tier = {
							derived = "fitting_tier_number",
						},
						item_level_delta = {
							derived = "item_level_delta",
						},
						player_item_level = {
							input = "player.item_level",
						},
						selected_tier = {
							derived = "selected_tier_number",
						},
						suggested_item_level = {
							derived = "selected_tier_suggested_ilvl",
						},
					},
					status = "conditional",
					title_key = "MH_KO_RITUAL_ILVL_FAR_TITLE",
					why_key = "MH_KO_RITUAL_ILVL_FAR_WHY",
				},
				ritual_t5 = {
					confidence = "medium",
					first_action_key = "MH_KO_RITUAL_T5_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_RITUAL_T5_NOT_NOW_1",
					},
					status = "conditional",
					title_key = "MH_KO_RITUAL_T5_TITLE",
					why_key = "MH_KO_RITUAL_T5_WHY",
				},
				ritual_t6 = {
					confidence = "medium",
					first_action_key = "MH_KO_RITUAL_T6_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_RITUAL_T6_NOT_NOW_1",
					},
					status = "conditional",
					title_key = "MH_KO_RITUAL_T6_TITLE",
					why_key = "MH_KO_RITUAL_T6_WHY",
				},
				tiers_unreadable = {
					confidence = "unknown",
					first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_UNKNOWN_NOT_NOW_1",
					},
					status = "unknown",
					title_key = "MH_KO_UNKNOWN_TITLE",
					why_key = "MH_KO_UNKNOWN_WHY",
				},
			},
			rules = {
				{
					mode = "both",
					priority = 1,
					result = {
						missing_input_effect = {
							recent_activity_history = "secondary",
						},
						output_ref = "ritual_t5",
						reports_missing = {
							"recent_activity_history",
						},
					},
					when = {
						player_goal = "vault_only",
						tier_5_unlocked = true,
					},
				},
				{
					mode = "both",
					priority = 2,
					result = {
						missing_input_effect = {
							recent_activity_history = "secondary",
						},
						output_ref = "ritual_t6",
						reports_missing = {
							"recent_activity_history",
						},
					},
					when = {
						["ritual.weekly_extra_value_available"] = true,
						tier_6_unlocked = true,
					},
				},
				{
					mode = "both",
					priority = 3,
					result = {
						missing_input_effect = {
							recent_activity_history = "secondary",
						},
						output_ref = "ritual_ilvl_at_or_above",
						reports_missing = {
							"recent_activity_history",
						},
					},
					when = {
						item_level_delta_gte = 0,
					},
				},
				{
					mode = "both",
					priority = 4,
					result = {
						missing_input_effect = {
							recent_activity_history = "secondary",
						},
						output_ref = "ritual_ilvl_just_below",
						reports_missing = {
							"recent_activity_history",
						},
					},
					when = {
						item_level_delta_gte = -3,
						item_level_delta_lte = -1,
					},
				},
				{
					mode = "both",
					priority = 5,
					result = {
						missing_input_effect = {
							recent_activity_history = "secondary",
						},
						output_ref = "ritual_ilvl_well_below",
						reports_missing = {
							"recent_activity_history",
						},
					},
					when = {
						item_level_delta_lt = -3,
					},
				},
				{
					fallback = true,
					mode = "both",
					priority = 6,
					result = {
						output_ref = "tiers_unreadable",
						reports_missing = {
							"ritual.available_tiers",
							"player.item_level",
							"ritual.weekly_extra_value_available",
							"recent_activity_history",
						},
					},
				},
			},
			source_status = "OFFICIAL_CONFIRMED",
			staleness = {
				fallback_date = "2026-08-18",
				on_stale = "degrade_to_unknown",
				stale_when = {
					{
						operator = ">=",
						signal = "interface",
						value = 120100,
					},
					{
						operator = ">",
						signal = "mythic_plus_season_id",
						value = 17,
					},
				},
			},
			status = "review",
			version = "0.5.0",
		},
		{
			buffer_model = {
				components = {
					"activity.setup_minutes",
					"activity.estimated_minutes.max",
					"recovery_buffer_minutes",
				},
				note = "A product rule, not a claim about how long anything actually takes. The buffer exists so a recommendation does not push the player into finishing under time pressure.",
				recovery_buffer_minutes = 5,
				rule = "recommended_total_minutes <= available_session_minutes",
			},
			copy_keys = {
				"MH_KO_TIME_ASK_TITLE",
				"MH_KO_TIME_ASK_WHY",
				"MH_KO_TIME_ASK_FIRST_ACTION",
				"MH_KO_TIME_ASK_NOT_NOW_1",
				"MH_KO_TIME_SHORT_TITLE",
				"MH_KO_TIME_SHORT_WHY",
				"MH_KO_TIME_SHORT_FIRST_ACTION",
				"MH_KO_TIME_SHORT_NOT_NOW_1",
			},
			derived = {
				activity_fits_with_buffer = {
					of = {
						"session_minutes_known",
						"estimated_minutes_max_known",
						{
							of = {
								"recommended_total_minutes",
								"available_session_minutes",
							},
							operator = "lte",
						},
					},
					operator = "and",
				},
				estimated_minutes_max_known = {
					operator = "exists",
					source = "activity.estimated_minutes.max",
				},
				estimated_total_exceeds_available_time = {
					of = {
						"session_minutes_known",
						"estimated_minutes_max_known",
						{
							of = {
								"recommended_total_minutes",
								"available_session_minutes",
							},
							operator = "gt",
						},
					},
					operator = "and",
				},
				recommended_total_minutes = {
					of = {
						"activity.setup_minutes",
						"activity.estimated_minutes.max",
						5,
					},
					operator = "sum",
				},
				session_minutes_known = {
					operator = "exists",
					source = "available_session_minutes",
				},
			},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
			},
			id = "MH-KO-TIMEBOX-1207-003",
			inputs = {
				{
					mapping_key = "session_minutes",
					materiality = "contextual",
					name = "available_session_minutes",
					origin = "request",
					required = false,
					type = "int|null",
				},
				{
					mapping_key = "activity_estimate_max",
					materiality = "contextual",
					missing_input_label = "estimated_minutes.max",
					name = "activity.estimated_minutes.max",
					origin = "request",
					required = false,
					type = "int|null",
				},
				{
					default = 0,
					mapping_key = "activity_setup_minutes",
					materiality = "contextual",
					name = "activity.setup_minutes",
					origin = "request",
					required = false,
					type = "int|null",
				},
				{
					enum = {
						"high",
						"medium",
						"low",
						"unknown",
					},
					mapping_key = "activity_interruptibility",
					materiality = "contextual",
					name = "activity.interruptibility",
					origin = "request",
					required = false,
					type = "enum",
				},
				{
					materiality = "secondary",
					name = "manual_disable_flag",
					origin = "engine",
					required = false,
					type = "boolean",
				},
			},
			kind = "runtime_gate",
			outputs = {
				ask_time = {
					confidence = "low",
					first_action_key = "MH_KO_TIME_ASK_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_TIME_ASK_NOT_NOW_1",
					},
					status = "ask",
					title_key = "MH_KO_TIME_ASK_TITLE",
					why_key = "MH_KO_TIME_ASK_WHY",
				},
				shorter_step = {
					confidence = "medium",
					first_action_key = "MH_KO_TIME_SHORT_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_TIME_SHORT_NOT_NOW_1",
					},
					status = "conditional",
					title_key = "MH_KO_TIME_SHORT_TITLE",
					why_key = "MH_KO_TIME_SHORT_WHY",
				},
			},
			rules = {
				{
					mode = "standalone",
					priority = 1,
					result = {
						output_ref = "ask_time",
						reports_missing = {},
					},
					when = {
						session_minutes_known = false,
					},
				},
				{
					mode = "both",
					priority = 2,
					result = {
						output_ref = "shorter_step",
						reports_missing = {},
					},
					when = {
						estimated_total_exceeds_available_time = true,
					},
				},
				{
					mode = "standalone",
					priority = 3,
					result = {
						external_output_ref = {
							object_id = "MH-KO-CONFIDENCE-1207-004",
							output_ref = "unknown_conditional",
						},
						reports_missing = {
							"activity.estimated_minutes.max",
						},
					},
					when = {
						["activity.interruptibility"] = "low",
						estimated_minutes_max_known = false,
					},
				},
				{
					mode = "gate",
					priority = 4,
					result = {
						pass_through = true,
					},
					when = {
						activity_fits_with_buffer = true,
					},
				},
			},
			source_status = "EDITORIAL_REVIEWED",
			staleness = {
				fallback_date = NULL,
				on_stale = "disable",
				stale_when = {
					{
						operator = "==",
						signal = "manual_disable_flag",
						value = true,
					},
				},
			},
			status = "review",
			version = "0.4.0",
		},
		{
			copy_keys = {
				"MH_KO_UNKNOWN_TITLE",
				"MH_KO_UNKNOWN_WHY",
				"MH_KO_UNKNOWN_FIRST_ACTION",
				"MH_KO_UNKNOWN_NOT_NOW_1",
				"MH_CONFIDENCE_HIGH",
				"MH_CONFIDENCE_MEDIUM",
				"MH_CONFIDENCE_LOW",
				"MH_CONFIDENCE_UNKNOWN",
			},
			derived = {
				all_required_known = {
					operator = "evaluator_result",
				},
				material_assumption_used = {
					operator = "evaluator_result",
				},
				material_input_missing = {
					operator = "evaluator_result",
				},
				secondary_input_missing = {
					operator = "evaluator_result",
				},
			},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
			},
			id = "MH-KO-CONFIDENCE-1207-004",
			inputs = {
				{
					materiality = "material",
					name = "known_inputs",
					origin = "engine",
					required = true,
					type = "array<string>",
				},
				{
					materiality = "material",
					name = "missing_inputs",
					origin = "engine",
					required = true,
					type = "array<string>",
				},
				{
					materiality = "material",
					name = "stale_inputs",
					origin = "engine",
					required = true,
					type = "array<string>",
				},
				{
					materiality = "material",
					name = "assumed_inputs",
					origin = "engine",
					required = true,
					type = "array<string>",
				},
				{
					materiality = "secondary",
					name = "manual_disable_flag",
					origin = "engine",
					required = false,
					type = "boolean",
				},
			},
			kind = "confidence_policy",
			outputs = {
				unknown_ask = {
					confidence = "unknown",
					first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_UNKNOWN_NOT_NOW_1",
					},
					status = "ask",
					title_key = "MH_KO_UNKNOWN_TITLE",
					why_key = "MH_KO_UNKNOWN_WHY",
				},
				unknown_conditional = {
					confidence = "unknown",
					first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_UNKNOWN_NOT_NOW_1",
					},
					status = "conditional",
					title_key = "MH_KO_UNKNOWN_TITLE",
					why_key = "MH_KO_UNKNOWN_WHY",
				},
				unknown_final = {
					confidence = "unknown",
					first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_UNKNOWN_NOT_NOW_1",
					},
					status = "unknown",
					title_key = "MH_KO_UNKNOWN_TITLE",
					why_key = "MH_KO_UNKNOWN_WHY",
				},
			},
			rules = {
				{
					mode = "both",
					priority = 1,
					result = {
						confidence = "unknown",
					},
					when = {
						material_input_missing = true,
					},
				},
				{
					mode = "both",
					priority = 2,
					result = {
						confidence = "medium",
					},
					when = {
						material_assumption_used = true,
					},
				},
				{
					mode = "both",
					priority = 3,
					result = {
						confidence = "medium",
					},
					when = {
						secondary_input_missing = true,
					},
				},
				{
					mode = "both",
					priority = 4,
					result = {
						confidence = "high",
					},
					when = {
						all_required_known = true,
					},
				},
			},
			source_status = "EDITORIAL_REVIEWED",
			staleness = {
				fallback_date = NULL,
				on_stale = "disable",
				stale_when = {
					{
						operator = "==",
						signal = "manual_disable_flag",
						value = true,
					},
				},
			},
			status = "review",
			version = "0.4.0",
		},
		{
			copy_keys = {
				"MH_KO_PREREQ_TITLE",
				"MH_KO_PREREQ_WHY",
				"MH_KO_PREREQ_FIRST_ACTION",
				"MH_KO_PREREQ_NOT_NOW_1",
			},
			derived = {
				first_actionable_prerequisite_exists = {
					operator = "any",
					source = "activity.missing_prerequisites",
					where = {
						actionable = true,
					},
				},
			},
			game_scope = {
				interface_max = NULL,
				interface_min = 120000,
			},
			id = "MH-KO-PREREQUISITE-1207-005",
			inputs = {
				{
					mapping_key = "activity_available",
					materiality = "material",
					name = "activity.available",
					origin = "request",
					required = true,
					type = "boolean|null",
				},
				{
					mapping_key = "activity_prerequisite_state_known",
					materiality = "material",
					missing_input_label = "prerequisite_state",
					missing_when = "false",
					name = "activity.prerequisite_state_known",
					origin = "request",
					required = true,
					type = "boolean",
				},
				{
					mapping_key = "activity_missing_prerequisites",
					materiality = "contextual",
					name = "activity.missing_prerequisites",
					origin = "request",
					required = false,
					type = "array",
				},
				{
					materiality = "secondary",
					name = "manual_disable_flag",
					origin = "engine",
					required = false,
					type = "boolean",
				},
			},
			kind = "prerequisite_policy",
			outputs = {
				prerequisite = {
					confidence = "high",
					first_action_key = "MH_KO_PREREQ_FIRST_ACTION",
					not_now_keys = {
						"MH_KO_PREREQ_NOT_NOW_1",
					},
					status = "blocked",
					title_key = "MH_KO_PREREQ_TITLE",
					why_key = "MH_KO_PREREQ_WHY",
				},
			},
			response_extras = {
				prerequisite_id = "The id of the FIRST prerequisite with actionable == true, in the order the request supplied them. Never the whole chain — that is the never-lie rule \"nooit een volledige unlockketen als één taak presenteren\".",
			},
			rules = {
				{
					mode = "both",
					priority = 1,
					result = {
						pass_through = true,
					},
					when = {
						["activity.available"] = true,
					},
				},
				{
					mode = "both",
					priority = 2,
					result = {
						external_output_ref = {
							object_id = "MH-KO-CONFIDENCE-1207-004",
							output_ref = "unknown_ask",
						},
						reports_missing = {
							"activity.prerequisite_state_known",
						},
					},
					when = {
						["activity.prerequisite_state_known"] = false,
					},
				},
				{
					mode = "both",
					priority = 3,
					result = {
						output_ref = "prerequisite",
						reports_missing = {},
					},
					when = {
						first_actionable_prerequisite_exists = true,
					},
				},
			},
			source_status = "IN_GAME_VERIFIED",
			staleness = {
				fallback_date = NULL,
				on_stale = "disable",
				stale_when = {
					{
						operator = "==",
						signal = "manual_disable_flag",
						value = true,
					},
				},
			},
			status = "review",
			version = "0.4.0",
		},
	},
}

-- Index by id, built once. Order of `objects` is the catalog order and is what the
-- pipeline walks; byId is only for external ref resolution.
Knowledge.byId = {}
for i = 1, #Knowledge.objects do
	Knowledge.byId[Knowledge.objects[i].id] = Knowledge.objects[i]
end

ns.KnowledgeData = Knowledge
return Knowledge
