--[[
	Midnight Helper — Knowledge fixture corpus (RFC-002 phase 2)

	GENERATED FILE — DO NOT EDIT BY HAND.
	Source:    docs/knowledge_proposal_v0.4/fixtures_full_v0.4.json
	Generator: tools/build_knowledge.py
	Regenerate with:  python tools/build_knowledge.py

	Edits here are lost on the next build. Change the upstream YAML instead.

	Test data only. Lives in tools/ so it never ships: tools/ is excluded from the
	release zip by .pkgmeta and by tools/package.ps1.
]]


-- Returns a builder so the caller injects ITS null sentinel. Both this corpus and
-- KnowledgeData_S1 have to agree on one null identity, and passing it in is the only
-- way to guarantee that without a shared global.
return function(NULL)
	local fixtures = {
		{
			expected_response = {
				confidence = "high",
				first_action_key = "MH_KO_VAULT_READY_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-WEEKLY-POWER-1207-001",
				},
				not_now_keys = {
					"MH_KO_VAULT_READY_NOT_NOW_1",
				},
				status = "recommend",
				title_key = "MH_KO_VAULT_READY_TITLE",
				why_key = "MH_KO_VAULT_READY_WHY",
			},
			id = "01_great_vault_ready",
			request = {
				activity_states = {},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f01",
				weekly_reward_state = {
					great_vault_reward_ready = true,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_T5_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"live_recommended_item_level",
				},
				not_now_keys = {
					"MH_KO_RITUAL_T5_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_RITUAL_T5_TITLE",
				why_key = "MH_KO_RITUAL_T5_WHY",
			},
			id = "02_ritual_t5_vault_only",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							5,
							6,
						},
						editorial = {
							interruptibility = "low",
						},
						live_recommended_item_level = NULL,
						prerequisites_met = true,
						weekly_extra_value_available = false,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "vault_only",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {
					{
						activity_id = "ritual_site",
						completed = true,
						deaths = 1,
						duration_seconds = 1080,
						tier = 5,
					},
				},
				request_id = "f02",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_T6_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"live_recommended_item_level",
				},
				not_now_keys = {
					"MH_KO_RITUAL_T6_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_RITUAL_T6_TITLE",
				why_key = "MH_KO_RITUAL_T6_WHY",
			},
			id = "03_ritual_t6_extra_value",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							5,
							6,
						},
						editorial = {
							interruptibility = "low",
						},
						live_recommended_item_level = NULL,
						prerequisites_met = true,
						weekly_extra_value_available = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {
					{
						activity_id = "ritual_site",
						completed = true,
						deaths = 2,
						duration_seconds = 1320,
						tier = 6,
					},
				},
				request_id = "f03",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				assumed_inputs = {
					"player_goal",
				},
				confidence = "low",
				first_action_key = "MH_KO_TIME_ASK_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-TIMEBOX-1207-003",
				},
				not_now_keys = {
					"MH_KO_TIME_ASK_NOT_NOW_1",
				},
				status = "ask",
				title_key = "MH_KO_TIME_ASK_TITLE",
				why_key = "MH_KO_TIME_ASK_WHY",
			},
			id = "04_session_time_unknown",
			request = {
				activity_states = {
					{
						activity_id = "delve",
						available = true,
						editorial = {
							interruptibility = "low",
						},
						estimated_minutes = {
							max = 30,
							min = 15,
							source = "observed",
						},
						prerequisites_met = true,
						setup_minutes = 2,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f04",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "unknown",
				first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-TIMEBOX-1207-003",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"estimated_minutes.max",
				},
				not_now_keys = {
					"MH_KO_UNKNOWN_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_UNKNOWN_TITLE",
				why_key = "MH_KO_UNKNOWN_WHY",
			},
			id = "05_unknown_duration_low_interruptibility",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						editorial = {
							interruptibility = "low",
						},
						estimated_minutes = {
							max = NULL,
							min = NULL,
							source = "unknown",
						},
						prerequisites_met = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = 30,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f05",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "high",
				first_action_key = "MH_KO_PREREQ_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-PREREQUISITE-1207-005",
				},
				not_now_keys = {
					"MH_KO_PREREQ_NOT_NOW_1",
				},
				prerequisite_id = "unlock_ritual_sites",
				status = "blocked",
				title_key = "MH_KO_PREREQ_TITLE",
				why_key = "MH_KO_PREREQ_WHY",
			},
			id = "06_locked_one_prerequisite",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = false,
						missing_prerequisites = {
							{
								actionable = true,
								id = "unlock_ritual_sites",
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = false,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f06",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "unknown",
				first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-PREREQUISITE-1207-005",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"prerequisite_state",
				},
				not_now_keys = {
					"MH_KO_UNKNOWN_NOT_NOW_1",
				},
				status = "ask",
				title_key = "MH_KO_UNKNOWN_TITLE",
				why_key = "MH_KO_UNKNOWN_WHY",
			},
			id = "07_locked_unknown_prerequisite",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = false,
						prerequisite_state_known = false,
						prerequisites_met = NULL,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f07",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "unknown",
				first_action_key = "MH_KO_UNKNOWN_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"live_recommended_item_level",
					"weekly_extra_value_available",
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_UNKNOWN_NOT_NOW_1",
				},
				status = "unknown",
				title_key = "MH_KO_UNKNOWN_TITLE",
				why_key = "MH_KO_UNKNOWN_WHY",
			},
			id = "08_material_input_missing",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							5,
							6,
						},
						live_recommended_item_level = NULL,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f08",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "unknown",
				first_action_key = "MH_KO_STALE_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-SYSTEM-STALE-000",
				},
				not_now_keys = {
					"MH_KO_STALE_NOT_NOW_1",
				},
				stale_object_ids = {
					"MH-KO-WEEKLY-POWER-1207-001",
					"MH-KO-RITUAL-TIER-1207-002",
				},
				stale_reason = {
					"interface >= 120100",
					"mythic_plus_season_id > 17",
				},
				status = "defer",
				title_key = "MH_KO_STALE_TITLE",
				why_key = "MH_KO_STALE_WHY",
			},
			id = "09_stale_after_season_change",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						prerequisites_met = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				interface = 120100,
				mythic_plus_season_id = 18,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {},
				request_id = "f09",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_TIME_SHORT_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-TIMEBOX-1207-003",
				},
				missing_inputs = {},
				not_now_keys = {
					"MH_KO_TIME_SHORT_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_TIME_SHORT_TITLE",
				why_key = "MH_KO_TIME_SHORT_WHY",
			},
			id = "10_route_does_not_fit_choose_shorter",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							5,
							6,
						},
						editorial = {
							interruptibility = "low",
						},
						estimated_minutes = {
							max = 25,
							min = 18,
							source = "observed",
						},
						live_recommended_item_level = NULL,
						prerequisites_met = true,
						setup_minutes = 3,
						weekly_extra_value_available = false,
					},
					{
						activity_id = "delve",
						available = true,
						editorial = {
							interruptibility = "low",
						},
						estimated_minutes = {
							max = 8,
							min = 6,
							source = "observed",
						},
						prerequisites_met = true,
						setup_minutes = 1,
					},
				},
				assumed_inputs = {},
				available_session_minutes = 20,
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "vault_only",
				player_state = {
					item_level = NULL,
					role = "TANK",
					specialization = "PROTECTION",
				},
				recent_activity_history = {
					{
						activity_id = "ritual_site",
						completed = true,
						deaths = 0,
						duration_seconds = 1140,
						tier = 5,
					},
				},
				request_id = "f10",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
			trace_note = "Ritual selector chooses Tier 5 (goal vault_only + a completed tier-5 run). Timebox then gates that route: 3 setup + 25 max + 5 buffer = 33 > 20 available, so priority 2 fires in gate mode and replaces the route with shorter_step. The delve at 1 + 8 + 5 = 14 is the shorter relevant route the advice points at.",
		},
	}
	return { schemaVersion = "0.4.1", fixtures = fixtures }
end
