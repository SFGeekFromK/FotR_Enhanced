return {

	-- ["FACTION_NAME"] = {
	--     ["FAVOUR_GROUP_NAME"] = {
	--         name = "Criminal Underworld",
	--         faction_name = "HUTT_CARTELS",
	--         faction = Find_Player("HUTT_CARTELS"),
	--         favour = 0,    // Starting
	--         max_value = 100,  // Max or target value
	--         max_crossplot = "PUBLISH_UPON_REACHING_MAX_VALUE",
	--         cycle_increase = 0, // Amount gained by default per week
	--         increase_on_capture = 0, //Amount gained when taking a planet
	--         reduction_speech = nil, //Speech event if reduced
	--         support_structures_perception = nil, //Perception name which checks for structure presence when building
	--         leader_holo = "",
	--         support_buildables = {
	--             -- {name = "UNIT_NAME", tag = "Unit Name Readable", value = 1, locks = false},
	--         },
	--         reward_list = {  
	--             {unit = "UNIT_NAME", 
	--                 threshold = 20, 
	--                 remove_cost = false,
	--                 tag = "Readable Unit Name",
	--                 limit = 0, built = 0, building = 0,
	--                 buildable = false, 
	--                 crossplot = "UNIT_NAME_AVAILABLE",
	--                 text = nil,
	--             }   
	--         },
	--         spawned_rewards = {
	--                 ["DARTH_MAUL_TEAM"] = {
	--                     threshold = 100,
	--                     tag = "Darth Maul",
	--                     remove_cost = false,
	--                     unique = true, spawned = false,
	--                     text = true
	--                 },
	--                 ["SAVAGE_OPRESS_TEAM"] = {
	--                     threshold = 100,
	--                     tag = "Savage Opress",
	--                     remove_cost = false,
	--                     unique = true, spawned = false,
	--                     text = true
	--                 }
	--         },
	--         integrates = true,  //Only need the following block when true
	--         integration_data = {
	--             integration_speech = "TEXT_GROUP_JOINS",
	--             integrate_on_increase = true, //Integrates a planet any time the support increases
	--             integrating = false, // Set to true when in the process of integrating planets
	--             integrated = false //Set to true when integration is finished
	--         }
	--     }
	-- },

	["EMPIRE"] = {
		["SECTOR_FORCES"] = {
			name = "Senate Approval",
			faction_name = "Empire",
			faction = Find_Player("Empire"),
			favour = 0,
			max_value = 100,
			max_crossplot = "SENATE_SUPPORT_REACHED",
			cycle_increase = 0,
			increase_on_capture = 1,
			reduction_speech = nil,
			leader_holo = nil,
			support_structures_perception = nil,
			support_buildables = {
			},
			reward_list = { 
			},
			spawned_rewards = {
			},
			integrates = true,
			integration_data = {
				integration_speech = nil,
				integrate_on_increase = true,
				integrating = false,
				integrated = false
			}
		},
	},
	["REBEL"] = {
		["TECHNO_UNION"] = {
			name = "Techno Union",
			faction_name = "REBEL",
			faction = Find_Player("REBEL"),
			favour = 0,
			max_value = 100,
			max_crossplot = nil,
			cycle_increase = 0,
			increase_on_capture = 0,
			reduction_speech = nil,
			leader_holo = "San_Hill_Loop",
			support_structures_perception = nil,
			support_buildables = {
				{name = "STIMULUS_TECHNO", value = 5, locks = true},
			},
			reward_list = { 
			},
			spawned_rewards = {
				["TAMBOR_TEAM"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_TECHNO_WAT_TAMBOR"
				},
				["TREETOR_CAPTOR"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_TECHNO_DOMB_TREETOR"
				}
			},
			integrates = true,
			integration_data = {
				integration_speech = "TEXT_CONQUEST_CIS_TECHNO_JOINS",
				integrate_on_increase = true,
				integrating = false,
				integrated = false
			}
		},
		["COMMERCE_GUILD"] = {
			name = "Commerce Guild",
			faction_name = "REBEL",
			faction = Find_Player("REBEL"),
			favour = 0,
			max_value = 100,
			max_crossplot = nil,
			cycle_increase = 0,
			increase_on_capture = 0,
			reduction_speech = nil,
			support_structures_perception = nil,
			leader_holo = "San_Hill_Loop",
			support_buildables = {
				{name = "STIMULUS_COMMERCE", value = 5, locks = true},
			},
			reward_list = { 
			},
			spawned_rewards = {
				["SHU_MAI_CASTELL"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_COMMERCE_SHU_MAI"
				},
				["STARK_RECUSANT"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_COMMERCE_IACO_STARK"
				}
			},
			integrates = true,
			integration_data = {
				integration_speech = "TEXT_CONQUEST_CIS_COMMERCE_JOINS",
				integrate_on_increase = true,
				integrating = false,
				integrated = false
			}
		},
		["BANKING_CLAN"] = {
			name = "InterGalactic Banking Clan",
			faction_name = "REBEL",
			faction = Find_Player("REBEL"),
			favour = 0,
			max_value = 100,
			cycle_increase = 0,
			max_crossplot = nil,
			increase_on_capture = 0,
			reduction_speech = nil,
			leader_holo = "Tonith_Loop",
			support_structures_perception = nil,
			support_buildables = {
				{name = "STIMULUS_IGBC", value = 5, locks = true},
			},
			reward_list = { 
			},
			spawned_rewards = {
				["TONITH_CORPULENTUS"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_IGBC_PORS_TONITH"
				},
				["CANTEVAL_MUNIFICENT"] = {
					threshold = 100,
					remove_cost = false,
					unique = true, spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_IGBC_CANTEVAL"
				}
			},
			integrates = true,
			integration_data = {
				integration_speech = "TEXT_CONQUEST_CIS_IGBC_JOINS",
				integrate_on_increase = true,
				integrating = false,
				integrated = false
			}
		},
		["TRADE_FEDERATION"] = {
			name = "Trade Federation",
			faction_name = "REBEL",
			faction = Find_Player("REBEL"),
			favour = 0,
			max_value = 100,
			cycle_increase = 0,
			max_crossplot = nil,
			increase_on_capture = 0,
			reduction_speech = nil,
			support_structures_perception = nil,
			leader_holo = "San_Hill_Loop",
			support_buildables = {
				{name = "STIMULUS_TRADEFED", value = 5, locks = true},
			},
			reward_list = { 
			},
			spawned_rewards = {
				["DURD_TEAM"] = {
					threshold = 100,
					remove_cost = false,
					unique = true,spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_TRADEFED_LOK_DURD"
				},
				["TUUK_PROCURER"] = {
					threshold = 100,
					remove_cost = false,
					unique = true,spawned = false,
					text = "TEXT_GOVERNMENT_CIS_INTEGRATE_TRADEFED_MAR_TUUK"
				}
			},
			integrates = true,
			integration_data = {
				integration_speech = "TEXT_CONQUEST_CIS_TRADEFED_JOINS",
				integrate_on_increase = true,
				integrating = false,
				integrated = false
			}
		},
	},

	-- Hutt Government Favour
	["HUTT_CARTELS"] = {
		["SCUM"] = {
			name = "Criminal Underworld",
			faction_name = "HUTT_CARTELS",
			faction = Find_Player("HUTT_CARTELS"),
			favour = 0,
			max_value = 100,
			max_crossplot = "SHADOW_COLLECTIVE_AVAILABLE",
			cycle_increase = 0,
			increase_on_capture = 0,
			reduction_speech = nil,
			support_structures_perception = nil,
			leader_holo = "",
			support_buildables = {
				-- {name = "IPV1_GUNBOAT", tag = "IPV1 Gunboat", value = 1, locks = false},
				-- {name = "CONSULAR_REFIT", tag = "Consular Refit", value = 2, locks = false},
				-- {name = "CIS_DREADNAUGHT_LASERS", tag = "PDF Dreadnaught Heavy Cruiser", value = 6, locks = false},
				-- {name = "RAKA_FREIGHTER_TENDER", tag = "Raka Freighter Tender", value = 2, locks = false},
				-- {name = "KALOTH_BATTLECRUISER", tag = "Kaloth Battlecruiser", value = 3, locks = false},
				-- {name = "HUTT_BOARDING_SHUTTLE", tag = "Boarding Shuttle", value = 4, locks = false},
			},
			reward_list = {  
				{unit = "HUTT_BOARDING_SHUTTLE", 
					threshold = 20, 
					remove_cost = false,
					locks = true,
					tag = "Boarding Shuttle",
					limit = 0, built = 0, building = 0,
					buildable = false, 
					crossplot = "HUTT_BOARDING_AVAILABLE",
					text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_HUTT_BOARDING_SHUTTLE_AVAILABLE",
				}   
			},
			spawned_rewards = {
					["GANIS_NAL_HUTTA_JEWEL"] = {
						threshold = 30,
						tag = "Ganis (Heavy Minstrel Yacht)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_GANIS_NAL_AVAILABLE",
					},
					["TAGOONTA_TEAM"] = {
						threshold = 40,
						tag = "Tagoonta (Minor Shell Hutt)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_TAGOONTA_AVAILABLE",
					},
					["TOBBA_YTOBBA"] = {
						threshold = 60,
						tag = "Tobba (Szajin Cruiser)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_TOBBA_YTOBBA_AVAILABLE",
					},
					["RIBOGA_RIGHTFUL_DOMINION"] = {
						threshold = 80,
						tag = "Riboga (Vontor Destroyer)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_RIBOGA_AVAILABLE",
					},
					["DARTH_MAUL_TEAM"] = {
						threshold = 100,
						tag = "Darth Maul",
						remove_cost = false,
						unique = true, spawned = false,
						text = nil
					},
					["SAVAGE_OPRESS_TEAM"] = {
						threshold = 100,
						tag = "Savage Opress",
						remove_cost = false,
						unique = true, spawned = false,
						text = nil
					},
					["ZITON_MOJ_TEAM"] = {
						threshold = 100,
						tag = "Ziton Moj",
						remove_cost = false,
						unique = true, spawned = false,
						text = nil
					}
			},
			integrates = false,
		},
		["HUTT_MOBILIZATION"] = {
			name = "Hutt Empire",
			faction_name = "HUTT_CARTELS",
			faction = Find_Player("HUTT_CARTELS"),
			favour = 0,
			max_value = 500,
			max_crossplot = "HUTT_EMPIRE_AVAILABLE",
			cycle_increase = 0,
			increase_on_capture = 0,
			reduction_speech = nil,
			support_structures_perception = nil,
			leader_holo = "",
			support_buildables = {
				{name = "BH_GALACTIC_JUVARD_FRIGATE", value = 4, locks = false},
				{name = "BH_GALACTIC_BARABBULA_FRIGATE", value = 5, locks = false},
				{name = "BH_GALACTIC_KOSSAK_FRIGATE", value = 6, locks = false},
				{name = "BH_GALACTIC_UBRIKKIAN_CRUISER_CW", value = 7, locks = false},
				{name = "BH_GALACTIC_TEMPEST_CRUISER", value = 10, locks = false},
				{name = "BH_GALACTIC_SZAJIN_CRUISER", value = 14, locks = false},
				{name = "BH_GALACTIC_KARAGGA_DESTROYER", value = 14, locks = false},
				{name = "BH_GALACTIC_VONTOR_DESTROYER", value = 25, locks = false},
				-- AI versions
				{name = "BH_GALACTIC_JUVARD_FRIGATE_AI", value = 4, locks = false},
                {name = "BH_GALACTIC_BARABBULA_FRIGATE_AI", value = 5, locks = false},
                {name = "BH_GALACTIC_KOSSAK_FRIGATE_AI", value = 6, locks = false},
                {name = "BH_GALACTIC_UBRIKKIAN_CRUISER_CW_AI", value = 7, locks = false},
                {name = "BH_GALACTIC_TEMPEST_CRUISER_AI", value = 10, locks = false},
                {name = "BH_GALACTIC_SZAJIN_CRUISER_AI", value = 14, locks = false},
                {name = "BH_GALACTIC_KARAGGA_DESTROYER_AI", value = 14, locks = false},
                {name = "BH_GALACTIC_VONTOR_DESTROYER_AI", value = 25, locks = false},
			},
			reward_list = {  
				{unit = "KOSSAK_FRIGATE", 
					threshold = 200, 
					remove_cost = false,
					locks = true,
					tag = "Kossak Frigate", 
					limit = 0, built = 0, building = 0,
					buildable = false, 
					crossplot = "KOSSAK_AVAILABLE",
					text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_KOSSAK_AVAILABLE",
				},
				{unit = "UBRIKKIAN_CRUISER_CW", 
					threshold = 350, 
					remove_cost = false,
					locks = true,
					tag = "Ubrikkian Cruiser", 
					limit = 0, built = 0, building = 0,
					buildable = false, 
					crossplot = "UBRIKKIAN_CRUISER_AVAILABLE",
					text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_UBRIKKIAN_CRUISER_AVAILABLE",
				}, 
				{unit = "DORBULLA_WARSHIP", 
					threshold = 500, 
					remove_cost = false,
					locks = true,
					tag = "Dor'bulla", 
					limit = 0, built = 0, building = 0,
					buildable = false, 
					crossplot = "DORBULLA_AVAILABLE",
					text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_DORBULLA_AVAILABLE",
				}  
			},
			spawned_rewards = {
					["TROONOL_AGRELCU_HAALTA"] = {
						threshold = 100,
						tag = "Troonol (Ubrikkian Cruiser)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_TROONOL_AVAILABLE",
					},
					["ULAL_POTALA_UM_VAR"] = {
						threshold = 400,
						tag = "Ulal (Vontor Destroyer)",
						remove_cost = false,
						unique = true, spawned = false,
						text = "TEXT_CONQUEST_GOVERNMENT_HUTTS_ULAL_AVAILABLE",
					},
			},
			integrates = false,
		},
	}
}