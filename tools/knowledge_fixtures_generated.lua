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
			proof = "contract-test",
			request = {
				activity_states = {},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
				},
				missing_inputs = {},
				not_now_keys = {
					"MH_KO_RITUAL_T5_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_RITUAL_T5_TITLE",
				why_key = "MH_KO_RITUAL_T5_WHY",
			},
			id = "02_ritual_t5_vault_only",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						editorial = {
							interruptibility = "low",
						},
						prerequisites_met = true,
						weekly_extra_value_available = false,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
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
				},
				missing_inputs = {},
				not_now_keys = {
					"MH_KO_RITUAL_T6_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_RITUAL_T6_TITLE",
				why_key = "MH_KO_RITUAL_T6_WHY",
			},
			id = "03_ritual_t6_extra_value",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						editorial = {
							interruptibility = "low",
						},
						prerequisites_met = true,
						weekly_extra_value_available = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
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
			proof = "contract-test",
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
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
			proof = "contract-test",
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
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
			proof = "contract-test",
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
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
			proof = "contract-test",
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
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
					"player_item_level",
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
			note = "Item level is null here too, so the comparison route cannot run either; the answer reports that alongside the rest.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
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
			proof = "contract-test",
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
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
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
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						editorial = {
							interruptibility = "low",
						},
						estimated_minutes = {
							max = 25,
							min = 18,
							source = "observed",
						},
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
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
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
		{
			expected_response = {
				confidence = "low",
				first_action_key = "MH_KO_TIME_ASK_FIRST_ACTION",
				knowledge_object_ids = {
					"MH-KO-TIMEBOX-1207-003",
				},
				missing_inputs = {},
				not_now_keys = {
					"MH_KO_TIME_ASK_NOT_NOW_1",
				},
				status = "ask",
				title_key = "MH_KO_TIME_ASK_TITLE",
				why_key = "MH_KO_TIME_ASK_WHY",
			},
			id = "11_outside_entrance_ritual_object_silent",
			note = "Ritual Sites are available but we are not at the entrance, so the tier selector is not applicable at all. Its silence is normal: nothing is reported missing and the timebox answers as it would anywhere else.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						prerequisite_state_known = true,
						prerequisites_met = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "unknown",
					kind = "other",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f11",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_ILVL_BELOW_FIRST_ACTION",
				item_level_delta = -1,
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_RITUAL_ILVL_NOT_NOW_1",
				},
				selected_tier = 6,
				status = "conditional",
				title_key = "MH_KO_RITUAL_ILVL_BELOW_TITLE",
				why_key = "MH_KO_RITUAL_ILVL_BELOW_WHY",
			},
			id = "12_entrance_tier6_one_ilvl_short",
			note = "Tier 6 unlocked, the game suggests 274, Rob has 273. Delta -1: named, not forbidden.",
			proof = "in-game trace: tiers and suggested item levels read from Rob's obelisk 2026-08-01, player item level 273 measured on the same character",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = 273,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f12",
				weekly_reward_state = {
					great_vault_reward_ready = false,
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
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_RITUAL_T5_NOT_NOW_1",
				},
				status = "conditional",
				title_key = "MH_KO_RITUAL_T5_TITLE",
				why_key = "MH_KO_RITUAL_T5_WHY",
			},
			id = "13_entrance_tier_locked_with_game_reason",
			note = "Tier 6 is locked and the game supplied the reason, so tier 5 is the highest that can be chosen. NOTE: no output currently carries failure_reason to the player -- the request holds it, nothing renders it. That is an upstream gap, not something to invent copy for.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								failure_reason = "Requires item level 274.",
								failure_reason_provenance = "game_client",
								suggested_item_level = 274,
								tier = 6,
								unlocked = false,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = false,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "vault_only",
				player_state = {
					item_level = 268,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f13",
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
					"available_tiers",
					"player_item_level",
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
			id = "14_entrance_open_but_tiers_unreadable",
			note = "The entrance is demonstrably active but the client returned no usable tier list. Saying so is the answer; silence here would hide a gap the player is standing in front of. Item level is null here too, so the comparison route cannot run either; the answer reports that alongside the rest.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						prerequisite_state_known = true,
						prerequisites_met = true,
					},
				},
				assumed_inputs = {},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f14",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_ILVL_AT_FIRST_ACTION",
				item_level_delta = 0,
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_RITUAL_ILVL_NOT_NOW_1",
				},
				selected_tier = 6,
				status = "recommend",
				title_key = "MH_KO_RITUAL_ILVL_AT_TITLE",
				why_key = "MH_KO_RITUAL_ILVL_AT_WHY",
			},
			id = "15_entrance_exactly_on_suggestion",
			note = "Exactly on the suggested value. Zero is not below, so this recommends.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = 274,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f15",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_ILVL_AT_FIRST_ACTION",
				item_level_delta = 10,
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_RITUAL_ILVL_NOT_NOW_1",
				},
				selected_tier = 6,
				status = "recommend",
				title_key = "MH_KO_RITUAL_ILVL_AT_TITLE",
				why_key = "MH_KO_RITUAL_ILVL_AT_WHY",
			},
			id = "16_entrance_well_above_suggestion",
			note = "Comfortably above the guidance.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = 284,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f16",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
		{
			expected_response = {
				confidence = "medium",
				first_action_key = "MH_KO_RITUAL_ILVL_FAR_FIRST_ACTION",
				fitting_tier = 5,
				item_level_delta = -9,
				knowledge_object_ids = {
					"MH-KO-RITUAL-TIER-1207-002",
					"MH-KO-CONFIDENCE-1207-004",
				},
				missing_inputs = {
					"recent_activity_history",
				},
				not_now_keys = {
					"MH_KO_RITUAL_ILVL_NOT_NOW_1",
				},
				selected_tier = 6,
				status = "conditional",
				title_key = "MH_KO_RITUAL_ILVL_FAR_TITLE",
				why_key = "MH_KO_RITUAL_ILVL_FAR_WHY",
			},
			id = "17_entrance_far_below_with_fitting_tier",
			note = "Nine below the highest tier's guidance. Tier 5 suggests 264 and the player has 265, so the first action names that tier instead of discouraging the choice.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = 265,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f17",
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
					"player_item_level",
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
			id = "18_entrance_player_item_level_missing",
			note = "No item level to compare with, so no comparison is made and nothing is implied.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 215,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 231,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 244,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 257,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 264,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 274,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = NULL,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f18",
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
			id = "19_entrance_suggested_item_level_missing",
			note = "The tier list is there but carries no usable suggested item levels, which is exactly what every tier reads as inside a running scenario. No comparison, no guess.",
			proof = "contract-test",
			request = {
				activity_states = {
					{
						activity_id = "ritual_site",
						available = true,
						available_tiers = {
							{
								suggested_item_level = 0,
								tier = 1,
								unlocked = true,
							},
							{
								suggested_item_level = 0,
								tier = 2,
								unlocked = true,
							},
							{
								suggested_item_level = 0,
								tier = 3,
								unlocked = true,
							},
							{
								suggested_item_level = 0,
								tier = 4,
								unlocked = true,
							},
							{
								suggested_item_level = 0,
								tier = 5,
								unlocked = true,
							},
							{
								suggested_item_level = 0,
								tier = 6,
								unlocked = true,
							},
						},
						prerequisite_state_known = true,
						prerequisites_met = true,
						weekly_extra_value_available = NULL,
					},
				},
				assumed_inputs = {
					"player_goal",
				},
				available_session_minutes = NULL,
				evaluation_context = {
					activity_type = "ritual_site",
					kind = "tiered_entrance_selection",
				},
				interface = 120007,
				mythic_plus_season_id = 17,
				player_goal = "progress",
				player_state = {
					item_level = 273,
					role = "DAMAGER",
					specialization = "Frost",
				},
				recent_activity_history = {},
				request_id = "f19",
				weekly_reward_state = {
					great_vault_reward_ready = false,
				},
			},
		},
	}
	return { schemaVersion = "0.5.0", fixtures = fixtures }
end
