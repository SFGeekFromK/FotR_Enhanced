--**************************************************************************************************
--*    _______ __                                                                                  *
--*   |_     _|  |--.----.---.-.--.--.--.-----.-----.                                              *
--*     |   | |     |   _|  _  |  |  |  |     |__ --|                                              *
--*     |___| |__|__|__| |___._|________|__|__|_____|                                              *
--*    ______                                                                                      *
--*   |   __ \.-----.--.--.-----.-----.-----.-----.                                                *
--*   |      <|  -__|  |  |  -__|     |  _  |  -__|                                                *
--*   |___|__||_____|\___/|_____|__|__|___  |_____|                                                *
--*                                   |_____|                                                      *
--*                                                                                                *
--*                                                                                                *
--*       File:              RepublicHeroes.lua                                                    *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                    *
--*       Last Modified:     Wednesday, 17th August 2022 04:31 						               *
--*       Modified By:       Mord 				                                                   *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGStoryMode")
require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("HeroSystem")
require("SetFighterResearch")


RepublicHeroes = class()

function RepublicHeroes:new(gc, herokilled_finished_event, human_player, hero_clones_p2_disabled)
    self.human_player = human_player
    gc.Events.GalacticProductionFinished:attach_listener(self.on_production_finished, self)
	herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
	self.hero_clones_p2_disabled = hero_clones_p2_disabled
	self.inited = false
	yularen_second_chance_used = false
	
	self.tech_level = GlobalValue.Get("CURRENT_ERA")

	crossplot:subscribe("VENATOR_HEROES", self.Venator_Heroes, self)
	crossplot:subscribe("VICTORY_HEROES", self.VSD_Heroes, self)
	crossplot:subscribe("VICTORY2_HEROES", self.VSD2_Heroes, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_DECREMENT", self.admiral_decrement, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_LOCKIN", self.admiral_lockin, self)
	crossplot:subscribe("SPECIAL_TASK_FORCE_FUNDED", self.Special_Task_Force_Handler, self)
	crossplot:subscribe("SECTOR_GOVERNANCE_DECREE_SUPPORTED", self.Sector_Governance_Decree_Handler, self)
	crossplot:subscribe("ENHANCED_SECURITY_ACT_SUPPORTED", self.Enhanced_Security_Act_Support_Handler, self)
	crossplot:subscribe("ENHANCED_SECURITY_ACT_PREVENTED", self.Enhanced_Security_Act_Prevent_Handler, self)
	crossplot:subscribe("AHSOKA_ARRIVAL", self.New_Padawan_Handler, self)
	crossplot:subscribe("ORDER_66_EXECUTED", self.Order_66_Handler, self)
	crossplot:subscribe("VENATOR_RESEARCH_FINISHED", self.Venator_Heroes, self)
	crossplot:subscribe("VICTORY_RESEARCH_FINISHED", self.VSD_Heroes, self)
	crossplot:subscribe("VICTORY2_RESEARCH_FINISHED", self.VSD2_Heroes, self)
	crossplot:subscribe("ERA_THREE_TRANSITION", self.Era_3, self)
	crossplot:subscribe("ERA_FOUR_TRANSITION", self.Era_4, self)
	crossplot:subscribe("ERA_FIVE_TRANSITION", self.Era_5, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_EXIT", self.admiral_exit, self)
	crossplot:subscribe("REPUBLIC_ADMIRAL_RETURN", self.admiral_return, self)
	crossplot:subscribe("CLONE_UPGRADES", self.Phase_II, self)
	crossplot:subscribe("REPUBLIC_FIGHTER_ENABLE", self.Add_Fighter_Sets, self)
	crossplot:subscribe("REPUBLIC_FIGHTER_DISABLE", self.Remove_Fighter_Sets, self)
	-- FotR_Enhanced
	--crossplot:subscribe("DALLIN_UNLLOCK", self.Dallin_Unlock, self)
	crossplot:subscribe("GEEN_UNLOCK", self.Geen_Unlock, self)
	--crossplot:subscribe("FORRAL_RETIRE", self.Forral_Switch, self)
	crossplot:subscribe("ORDER_65_EXECUTED", self.Order_65_Handler, self)

	admiral_data = {
		total_slots = 3,       --Max number of concurrent slots. Set at the start of the GC and never change.
		free_hero_slots = 3,   --Slots open to fill with a hero.
		vacant_hero_slots = 0, --Slots that need another action to move to free.
		vacant_limit = 22,      --Number of times a lost slot becomes a vacant slot (rather than remaining lost forever).
		initialized = false,
		full_list = { --All options for reference operations
			["Yularen"] = {"YULAREN_ASSIGN",{"YULAREN_RETIRE","YULAREN_RETIRE_66_1","YULAREN_RETIRE2","YULAREN_RETIRE_66_2","YULAREN_RETIRE3","YULAREN_RETIRE_1",},{"YULAREN_RESOLUTE","YULAREN_RESOLUTE_66","YULAREN_INTEGRITY","YULAREN_INTEGRITY_66","YULAREN_INVINCIBLE","YULAREN_RESOLUTE_SPHAT"},"Wulff Yularen"},
			["Wieler"] = {"WIELER_ASSIGN",{"WIELER_RETIRE"},{"WIELER_RESILIENT"},"Wieler"},
			["Coburn"] = {"COBURN_ASSIGN",{"COBURN_RETIRE"},{"COBURN_TRIUMPHANT"},"Barton Coburn"},
			["Kilian"] = {"KILIAN_ASSIGN",{"KILIAN_RETIRE"},{"KILIAN_ENDURANCE"},"Shoan Kilian"},
			["Tenant"] = {"TENANT_ASSIGN",{"TENANT_RETIRE"},{"TENANT_VENATOR"},"Nils Tenant"},
			["Dao"] = {"DAO_ASSIGN",{"DAO_RETIRE"},{"DAO_VENATOR"},"Dao"},
			["Denimoor"] = {"DENIMOOR_ASSIGN",{"DENIMOOR_RETIRE"},{"DENIMOOR_TENACIOUS"},"Denimoor"},
			["Dron"] = {"DRON_ASSIGN",{"DRON_RETIRE"},{"DRON_VENATOR"},"Dron"},
			["Screed"] = {"SCREED_ASSIGN",{"SCREED_RETIRE"},{"SCREED_ARLIONNE"},"Terrinald Screed"},
			["Dodonna"] = {"DODONNA_ASSIGN",{"DODONNA_RETIRE"},{"DODONNA_ARDENT"},"Jan Dodonna"},
			["Parck"] = {"PARCK_ASSIGN",{"PARCK_RETIRE"},{"PARCK_STRIKEFAST"},"Voss Parck"},
			["Pellaeon"] = {"PELLAEON_ASSIGN",{"PELLAEON_RETIRE"},{"PELLAEON_LEVELER"},"Gilad Pellaeon"},
			["Tallon"] = {"TALLON_ASSIGN",{"TALLON_RETIRE","TALLON_RETIRE2"},{"TALLON_SUNDIVER","TALLON_BATTALION"},"Adar Tallon"},
			["Dallin"] = {"DALLIN_ASSIGN",{"DALLIN_RETIRE"},{"DALLIN_KEBIR"},"Jace Dallin"},
			["Autem"] = {"AUTEM_ASSIGN",{"AUTEM_RETIRE"},{"AUTEM_VENATOR"},"Sagoro Autem"},
			["Forral"] = {"FORRAL_ASSIGN",{"FORRAL_RETIRE"},{"FORRAL_VENSENOR"},"Bythen Forral"},
			["Maarisa"] = {"MAARISA_ASSIGN",{"MAARISA_RETIRE","MAARISA_RETIRE2"},{"MAARISA_CAPTOR","MAARISA_RETALIATION"},"Maarisa Zsinj"},
			["Grumby"] = {"GRUMBY_ASSIGN",{"GRUMBY_RETIRE"},{"GRUMBY_INVINCIBLE"},"Jona Grumby"},
			["Baraka"] = {"BARAKA_ASSIGN",{"BARAKA_RETIRE"},{"BARAKA_NEXU"},"Arikakon Baraka"},
			["Martz"] = {"MARTZ_ASSIGN",{"MARTZ_RETIRE"},{"MARTZ_PROSECUTOR"},"Stinnet Martz"},
			-- FotR_Enhanced
			["Needa"] = {"NEEDA_ASSIGN",{"NEEDA_RETIRE"},{"NEEDA_INTEGRITY"},"Lorth Needa"},
			["Block"] = {"BLOCK_ASSIGN",{"BLOCK_RETIRE","BLOCK_RETIRE2"},{"BLOCK_NEGOTIATOR","BLOCK_VIGILANCE"}, "Block"},

		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Maarisa",
			"Grumby",
			"Needa",
			"Dallin"
		},
		story_locked_list = {--Heroes not accessible, but able to return with the right conditions
			["Tenant"] = true,
		},
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_ADMIRAL_SLOT",
		random_name = "RANDOM_ADMIRAL_ASSIGN",
		global_display_list = "REP_ADMIRAL_LIST", --Name of global array used for documention of currently active heroes
		disabled = false
	}
	
	moff_data = {
		total_slots = 1,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 1,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 12,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Tarkin"] = {"TARKIN_ASSIGN",{"TARKIN_RETIRE","TARKIN_RETIRE2"},{"TARKIN_VENATOR","TARKIN_EXECUTRIX"},"Wilhuff Tarkin"},
			["Trachta"] = {"TRACHTA_ASSIGN",{"TRACHTA_RETIRE"},{"TRACHTA_VENATOR"},"Trachta"},
			["Wessex"] = {"WESSEX_ASSIGN",{"WESSEX_RETIRE"},{"WESSEX_REDOUBT"},"Denn Wessex"},
			["Grant"] = {"GRANT_ASSIGN",{"GRANT_RETIRE"},{"GRANT_VENATOR"},"Octavian Grant"},
			["Vorru"] = {"VORRU_ASSIGN",{"VORRU_RETIRE"},{"VORRU_VENATOR"},"Fliry Vorru"},
			["Byluir"] = {"BYLUIR_ASSIGN",{"BYLUIR_RETIRE"},{"BYLUIR_VENATOR"},"Byluir"},
			["Hauser"] = {"HAUSER_ASSIGN",{"HAUSER_RETIRE"},{"HAUSER_DREADNAUGHT"},"Lynch Hauser"},
			["Wessel"] = {"WESSEL_ASSIGN",{"WESSEL_RETIRE"},{"WESSEL_ACCLAMATOR"},"Marcellin Wessel"},
			["Seerdon"] = {"SEERDON_ASSIGN",{"SEERDON_RETIRE"},{"SEERDON_INVINCIBLE"},"Kohl Seerdon"},
			["Praji"] = {"PRAJI_ASSIGN",{"PRAJI_RETIRE"},{"PRAJI_VALORUM"},"Collin Praji"},
			["Ravik"] = {"RAVIK_ASSIGN",{"RAVIK_RETIRE"},{"RAVIK_VICTORY"},"Ravik"},
			["Therbon"] = {"THERBON_ASSIGN",{"THERBON_RETIRE"},{"THERBON_CERULEAN_SUNRISE"},"Therbon"},
			
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Hauser",
			"Wessel",
			"Seerdon",			
			--"Coy",
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_MOFF_SLOT",
		random_name = "RANDOM_MOFF_ASSIGN",
		global_display_list = "REP_MOFF_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	
	council_data = {
		total_slots = 5,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 5,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 13,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Yoda"] = {"YODA_ASSIGN",{"YODA_RETIRE","YODA_RETIRE2"},{"YODA","YODA2"},"Yoda", ["Companies"] = {"YODA_DELTA_TEAM","YODA_ETA_TEAM"}},
			["Mace"] = {"MACE_ASSIGN",{"MACE_RETIRE","MACE_RETIRE2"},{"MACE_WINDU","MACE_WINDU2"},"Mace Windu", ["Companies"] = {"MACE_WINDU_DELTA_TEAM","MACE_WINDU_ETA_TEAM"}},
			["Plo"] = {"PLO_ASSIGN",{"PLO_RETIRE"},{"PLO_KOON"},"Plo Koon", ["Companies"] = {"PLO_KOON_DELTA_TEAM"}},
			["Kit"] = {"KIT_ASSIGN",{"KIT_RETIRE","KIT_RETIRE2"},{"KIT_FISTO","KIT_FISTO2"},"Kit Fisto", ["Companies"] = {"KIT_FISTO_DELTA_TEAM","KIT_FISTO_ETA_TEAM"}},
			["Mundi"] = {"MUNDI_ASSIGN",{"MUNDI_RETIRE","MUNDI_RETIRE2"},{"KI_ADI_MUNDI","KI_ADI_MUNDI2"},"Ki-Adi-Mundi", ["Companies"] = {"KI_ADI_MUNDI_DELTA_TEAM","KI_ADI_MUNDI_ETA_TEAM"}},
			["Luminara"] = {"LUMINARA_ASSIGN",{"LUMINARA_RETIRE","LUMINARA_RETIRE2"},{"LUMINARA_UNDULI","LUMINARA_UNDULI2"},"Luminara Unduli", ["Companies"] = {"LUMINARA_UNDULI_DELTA_TEAM","LUMINARA_UNDULI_ETA_TEAM"}},
			["Barriss"] = {"BARRISS_ASSIGN",{"BARRISS_RETIRE","BARRISS_RETIRE2"},{"BARRISS_OFFEE","BARRISS_OFFEE2"},"Barriss Offee", ["Companies"] = {"BARRISS_OFFEE_DELTA_TEAM","BARRISS_OFFEE_ETA_TEAM"}},
			["Ahsoka"] = {"AHSOKA_ASSIGN",{"AHSOKA_RETIRE","AHSOKA_RETIRE2"},{"AHSOKA","AHSOKA2"},"Ahsoka Tano", ["Companies"] = {"AHSOKA_DELTA_TEAM","AHSOKA_ETA_TEAM"}},
			["Aayla"] = {"AAYLA_ASSIGN",{"AAYLA_RETIRE","AAYLA_RETIRE2"},{"AAYLA_SECURA","AAYLA_SECURA2"},"Aayla Secura", ["Companies"] = {"AAYLA_SECURA_DELTA_TEAM","AAYLA_SECURA_ETA_TEAM"}},
			["Shaak"] = {"SHAAK_ASSIGN",{"SHAAK_RETIRE","SHAAK_RETIRE2"},{"SHAAK_TI","SHAAK_TI2"},"Shaak Ti", ["Companies"] = {"SHAAK_TI_DELTA_TEAM","SHAAK_TI_ETA_TEAM"}},
			["Kota"] = {"KOTA_ASSIGN",{"KOTA_RETIRE"},{"RAHM_KOTA"},"Rahm Kota", ["Companies"] = {"RAHM_KOTA_TEAM"}},
			["Knol"] = {"KNOL_VENNARI_ASSIGN",{"KNOL_VENNARI_RETIRE"},{"KNOL_VENNARI"},"Knol Ven'nari", ["Companies"] = {"KNOL_VENNARI_TEAM"}},
			["Halcyon"] = {"NEJAA_HALCYON_ASSIGN",{"NEJAA_HALCYON_RETIRE"},{"NEJAA_HALCYON"},"Nejaa Halcyon", ["Companies"] = {"NEJAA_HALCYON_TEAM"}},
			["Oppo"] = {"OPPO_RANCISIS_ASSIGN",{"OPPO_RANCISIS_RETIRE"},{"OPPO_RANCISIS"},"Oppo Rancisis", ["Companies"] = {"OPPO_RANCISIS_TEAM"}}
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Yoda",
			"Mace",
			"Plo",
			"Kit",
			"Mundi",
			"Luminara",
			"Barriss",
			"Aayla",
			"Shaak",
			"Kota",
			--"Knol",
			"Halcyon",
			"Oppo"
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_COUNCIL_SLOT",
		random_name = "RANDOM_COUNCIL_ASSIGN",
		global_display_list = "REP_COUNCIL_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	
	clone_data = {
		total_slots = 4,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 4,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 16,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Cody"] = {"CODY_ASSIGN",{"CODY_RETIRE","CODY_RETIRE"},{"CODY","CODY2"},"Cody", ["Companies"] = {"CODY_TEAM","CODY2_TEAM"}},
			["Rex"] = {"REX_ASSIGN",{"REX_RETIRE","REX_RETIRE"},{"REX","REX2"},"Rex", ["Companies"] = {"REX_TEAM","REX2_TEAM"}},
			["Vill"] = {"VILL_ASSIGN",{"VILL_RETIRE"},{"VILL"},"Vill", ["Companies"] = {"VILL_TEAM"}},
			["Appo"] = {"APPO_ASSIGN",{"APPO_RETIRE","APPO_RETIRE"},{"APPO","APPO2"},"Appo", ["Companies"] = {"APPO_TEAM","APPO2_TEAM"}},
			["Bow"] = {"BOW_ASSIGN",{"BOW_RETIRE"},{"BOW"},"Bow", ["Companies"] = {"BOW_TEAM"}},
			["Bly"] = {"BLY_ASSIGN",{"BLY_RETIRE","BLY_RETIRE"},{"BLY","BLY2"},"Bly", ["Companies"] = {"BLY_TEAM","BLY2_TEAM"}},
			["Deviss"] = {"DEVISS_ASSIGN",{"DEVISS_RETIRE","DEVISS_RETIRE"},{"DEVISS","DEVISS2"},"Deviss", ["Companies"] = {"DEVISS_TEAM","DEVISS2_TEAM"}},
			["Wolffe"] = {"WOLFFE_ASSIGN",{"WOLFFE_RETIRE","WOLFFE_RETIRE"},{"WOLFFE","WOLFFE2"},"Wolffe", ["Companies"] = {"WOLFFE_TEAM","WOLFFE2_TEAM"}},
			["Gree_Clone"] = {"GREE_ASSIGN",{"GREE_RETIRE","GREE_RETIRE"},{"GREE_CLONE","GREE2"},"Gree", ["Companies"] = {"GREE_TEAM","GREE2_TEAM"}},
			["Neyo"] = {"NEYO_ASSIGN",{"NEYO_RETIRE","NEYO_RETIRE"},{"NEYO","NEYO2"},"Neyo", ["Companies"] = {"NEYO_TEAM","NEYO2_TEAM"}},
			["71"] = {"71_ASSIGN",{"71_RETIRE","71_RETIRE"},{"COMMANDER_71","COMMANDER_71_2"},"CRC-09/571", ["Companies"] = {"COMMANDER_71_TEAM","COMMANDER_71_2_TEAM"}},
			["Keller"] = {"KELLER_ASSIGN",{"KELLER_RETIRE"},{"KELLER"},"Keller", ["Companies"] = {"KELLER_TEAM"}},
			["Faie"] = {"FAIE_ASSIGN",{"FAIE_RETIRE"},{"FAIE"},"Faie", ["Companies"] = {"FAIE_TEAM"}},
			["Bacara"] = {"BACARA_ASSIGN",{"BACARA_RETIRE","BACARA_RETIRE"},{"BACARA","BACARA2"},"Bacara", ["Companies"] = {"BACARA_TEAM","BACARA2_TEAM"}},
			["Jet"] = {"JET_ASSIGN",{"JET_RETIRE","JET_RETIRE"},{"JET","JET2"},"Jet", ["Companies"] = {"JET_TEAM","JET2_TEAM"}},
			["Gaffa"] = {"GAFFA_ASSIGN",{"GAFFA_RETIRE"},{"GAFFA_A5RX"},"Gaffa", ["Companies"] = {"GAFFA_TEAM"}},
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Cody",
			"Rex",
			"Appo",
			"Bly",
			"Wolffe",
			"Gree_Clone",
			"Neyo",
			"71",
			"Bacara",
			"Gaffa"
		},
		story_locked_list = {--Heroes not accessible, but able to return with the right conditions
			["Jet"] = true,
		},
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_CLONE_SLOT",
		random_name = "RANDOM_CLONE_ASSIGN",
		global_display_list = "REP_CLONE_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	
	commando_data = {
		total_slots = 3,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 3,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 9,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Alpha"] = {"ALPHA_ASSIGN",{"ALPHA_RETIRE","ALPHA_RETIRE"},{"ALPHA_17","ALPHA_17_2"},"Alpha-17", ["Companies"] = {"ALPHA_17_TEAM","ALPHA_17_2_TEAM"}},
			["Fordo"] = {"FORDO_ASSIGN",{"FORDO_RETIRE","FORDO_RETIRE"},{"FORDO","FORDO2"},"Fordo", ["Companies"] = {"FORDO_TEAM","FORDO2_TEAM"}},
			["Gregor"] = {"GREGOR_ASSIGN",{"GREGOR_RETIRE"},{"GREGOR"},"Gregor", ["Companies"] = {"GREGOR_TEAM"}},
			["Voca"] = {"VOCA_ASSIGN",{"VOCA_RETIRE"},{"VOCA"},"Voca", ["Companies"] = {"VOCA_TEAM"}},
			["Delta"] = {"DELTA_ASSIGN",{"DELTA_RETIRE"},{"DELTA_SQUAD"},"Delta Squad", ["Units"] = {{"BOSS","FIXER","SEV","SCORCH"}}},
			["Omega"] = {"OMEGA_ASSIGN",{"OMEGA_RETIRE"},{"OMEGA_SQUAD"},"Omega Squad", ["Units"] = {{"DARMAN","ATIN","FI","NINER"}}},
			["Ordo"] = {"ORDO_ASSIGN",{"ORDO_RETIRE","ORDO_RETIRE"},{"ORDO_SKIRATA","ORDO_SKIRATA2"},"Ordo Skirata", ["Companies"] = {"ORDO_SKIRATA_TEAM","ORDO_SKIRATA2_TEAM"}},
			["Aden"] = {"ADEN_ASSIGN",{"ADEN_RETIRE","ADEN_RETIRE"},{"ADEN_SKIRATA","ADEN_SKIRATA2"},"A'den Skirata", ["Companies"] = {"ADEN_SKIRATA_TEAM","ADEN_SKIRATA2_TEAM"}},
			["Prudii"] = {"PRUDII_ASSIGN",{"PRUDII_RETIRE","PRUDII_RETIRE"},{"PRUDII_SKIRATA","PRUDII_SKIRATA2"},"Prudii Skirata", ["Companies"] = {"PRUDII_SKIRATA_TEAM","PRUDII_SKIRATA2_TEAM"}}, -- FotR_Enhanced
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Alpha",
			"Fordo",	
			"Gregor",
			"Voca",
			"Delta",
			"Omega",
			"Ordo",
			"Aden",
			"Prudii"
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_COMMANDO_SLOT",
		random_name = "RANDOM_COMMANDO_ASSIGN",
		global_display_list = "REP_COMMANDO_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	
	general_data = {
		total_slots = 3,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 3,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 8,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Rom"] = {"ROM_MOHC_ASSIGN",{"ROM_MOHC_RETIRE"},{"ROM_MOHC"},"Rom Mohc", ["Companies"] = {"ROM_MOHC_TEAM"}},
			["Gentis"] = {"GENTIS_ASSIGN",{"GENTIS_RETIRE"},{"GENTIS_AT_TE"},"Gentis", ["Companies"] = {"GENTIS_TEAM"}},
			["Geen"] = {"GEEN_ASSIGN",{"GEEN_RETIRE"},{"GEEN_UT_AT"},"Locus Geen", ["Companies"] = {"GEEN_TEAM"}},
			["Ozzel"] = {"OZZEL_ASSIGN",{"OZZEL_RETIRE"},{"OZZEL_LAAT"},"Kendal Ozzel", ["Companies"] = {"OZZEL_TEAM"}},
			["Romodi"] = {"ROMODI_ASSIGN",{"ROMODI_RETIRE"},{"ROMODI_A5_JUGGERNAUT"},"Hurst Romodi", ["Companies"] = {"ROMODI_TEAM"}},
			["Solomahal"] = {"SOLOMAHAL_ASSIGN",{"SOLOMAHAL_RETIRE"},{"SOLOMAHAL_RX200"},"Solomahal", ["Companies"] = {"SOLOMAHAL_TEAM"}},
			["Jesra"] = {"JESRA_LOTURE_ASSIGN",{"JESRA_LOTURE_RETIRE"},{"JESRA_LOTURE"},"Jesra Loture", ["Companies"] = {"JESRA_LOTURE_TEAM"}},
			["Jayfon"] = {"JAYFON_ASSIGN",{"JAYFON_RETIRE"},{"JAYFON"},"Jayfon", ["Companies"] = {"JAYFON_TEAM"}},
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			"Rom",
			"Gentis",
			"Ozzel",
			"Romodi",
			"Solomahal",
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_GENERAL_SLOT",
		random_name = "RANDOM_GENERAL_ASSIGN",
		global_display_list = "REP_GENERAL_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	
	--[[
	senator_data = {
		total_slots = 2,			--Max slot number. Set at the start of the GC and never change
		free_hero_slots = 2,		--Slots open to buy
		vacant_hero_slots = 0,	    --Slots that need another action to move to free
		vacant_limit = 8,           --Number of times a lost slot can be reopened
		initialized = false,
		full_list = { --All options for reference operations
			["Organa"] = {"ORGANA_ASSIGN",{"ORGANA_RETIRE"},{"BAIL_ORGANA"},"Bail Organa", ["Companies"]={"BAIL_TEAM"}},
			["Garm"] = {"GARM_ASSIGN",{"GARM_RETIRE"},{"GARM_BEL_IBLIS"},"Garm Bel Iblis", ["Companies"] = {"GARM_TEAM"}},
			["Danu"] = {"GENTIS_ASSIGN",{"GENTIS_RETIRE"},{"GENTIS_AT_TE"},"Gentis", ["Companies"] = {"GENTIS_TEAM"}},
			["Zar"] = {"GEEN_ASSIGN",{"GEEN_RETIRE"},{"FANG_ZAR"},"Fang Zar", ["Companies"] = {"ZAR_TEAM"}},
			["Breemu"] = {"OZZEL_ASSIGN",{"OZZEL_RETIRE"},{"OZZEL_LAAT"},"Kendal Ozzel", ["Companies"] = {"OZZEL_TEAM"}},
			["Alavar"] = {"ROMODI_ASSIGN",{"ROMODI_RETIRE"},{"ROMODI_A5_JUGGERNAUT"},"Hurst Romodi", ["Companies"] = {"ROMODI_TEAM"}},
			["Papanoida"] = {"SOLOMAHAL_ASSIGN",{"SOLOMAHAL_RETIRE"},{"SOLOMAHAL_RX200"},"Solomahal", ["Companies"] = {"SOLOMAHAL_TEAM"}},
			["Padme"] = {"JESRA_LOTURE_ASSIGN",{"JESRA_LOTURE_RETIRE"},{"JESRA_LOTURE"},"Jesra Loture", ["Companies"] = {"JESRA_LOTURE_TEAM"}},
			["Taa"] = {"JAYFON_ASSIGN",{"JAYFON_RETIRE"},{"JAYFON"},"Jayfon", ["Companies"] = {"JAYFON_TEAM"}},
		},
		available_list = {--Heroes currently available for purchase. Seeded with those who have no special prereqs
			
		},
		story_locked_list = {},--Heroes not accessible, but able to return with the right conditions
		active_player = Find_Player("Empire"),
		extra_name = "EXTRA_SENATOR_SLOT",
		random_name = "RANDOM_SENATOR_ASSIGN",
		global_display_list = "REP_SENATOR_LIST", --Name of global array used for documention of currently active heroes
		disabled = true
	}
	]]
	
	fighter_assigns = {
		"Garven_Dreis_Location_Set",
		"Nial_Declann_Location_Set",
		"Rhys_Dallows_Location_Set",
		"Bythen_Forral_Location_Set"
	}
	fighter_assign_enabled = false
	
	viewers = {
		["VIEW_ADMIRALS"] = 1,
		["VIEW_MOFFS"] = 2,
		["VIEW_COUNCIL"] = 3,
		["VIEW_CLONES"] = 4,
		["VIEW_COMMANDOS"] = 5,
		["VIEW_GENERALS"] = 6,
		["VIEW_FIGHTERS"] = 7,
		--["VIEW_SENATORS"] = 8,
	}
	
	old_view = 1
	
	Autem_Checks = 0
	Trachta_Checks = 0
	Phase_II_Checked = false
	Bow_Checks = 0
	Vill_Checks = 0
	Tenant_Checks = 0
	
	Venator_init = false
	VSD_init = false

	Forral_Checks = 0
end

function RepublicHeroes:on_production_finished(planet, object_type_name)--object_type_name, owner)
	--Logger:trace("entering RepublicHeroes:on_production_finished")
	if not self.inited then
		self.inited = true
		self:init_heroes()
		if not moff_data.active_player.Is_Human() then --All options for AI
			Enable_Hero_Options(moff_data)
			Enable_Hero_Options(council_data)
			Enable_Hero_Options(clone_data)
			Enable_Hero_Options(commando_data)
			Enable_Hero_Options(general_data)
		end
	end
	if viewers[object_type_name] and moff_data.active_player.Is_Human() then
		switch_views(viewers[object_type_name])
		local viewer = Find_First_Object(object_type_name)
		if TestValid(viewer) then
			viewer.Despawn()
		end
	end
	Handle_Build_Options(object_type_name, admiral_data)
	Handle_Build_Options(object_type_name, moff_data)
	Handle_Build_Options(object_type_name, council_data)
	Handle_Build_Options(object_type_name, clone_data)
	Handle_Build_Options(object_type_name, commando_data)
	Handle_Build_Options(object_type_name, general_data)
	
	if object_type_name == "REFORM_SQUAD_SEVEN" then
		RepublicHeroes:Remove_Fighter_Set("Reform_Squad_Seven")
		UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_Torrent_Location_Set", true)
		UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_ARC170_Location_Set", true)
	end
	if object_type_name == "REFORM_HUNTER_SQUADRON" then
		RepublicHeroes:Remove_Fighter_Set("Reform_Hunter_Squadron")
		UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_Torrent_Location_Set", true)
		UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_ARC170_Location_Set", true)
	end
end

function switch_views(new_view)
	--Logger:trace("entering RepublicHeroes:switch_views")
	
	local tech_unit
	
	if new_view == 1 then
		tech_unit = Find_Object_Type("VIEW_ADMIRALS")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(admiral_data)
		Show_Hero_Info(admiral_data)
	end
	if new_view == 2 then
		tech_unit = Find_Object_Type("VIEW_MOFFS")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(moff_data)
		Show_Hero_Info(moff_data)
	end
	if new_view == 3 then
		tech_unit = Find_Object_Type("VIEW_COUNCIL")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(council_data)
		Show_Hero_Info(council_data)
	end
	if new_view == 4 then
		tech_unit = Find_Object_Type("VIEW_CLONES")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(clone_data)
		Show_Hero_Info(clone_data)
	end
	if new_view == 5 then
		tech_unit = Find_Object_Type("VIEW_COMMANDOS")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(commando_data)
		Show_Hero_Info(commando_data)
	end
	if new_view == 6 then
		tech_unit = Find_Object_Type("VIEW_GENERALS")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Hero_Options(general_data)
		Show_Hero_Info(general_data)
	end
	if new_view == 7 then
		tech_unit = Find_Object_Type("VIEW_FIGHTERS")
		moff_data.active_player.Lock_Tech(tech_unit)
		Enable_Fighter_Sets()
		fighter_assign_enabled = true
	end
	
	if old_view == 1 and admiral_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_ADMIRALS")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(admiral_data)
	end
	if old_view == 2 and moff_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_MOFFS")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(moff_data)
	end
	if old_view == 3 and council_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_COUNCIL")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(council_data)
	end
	if old_view == 4 and clone_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_CLONES")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(clone_data)
	end
	if old_view == 5 and commando_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_COMMANDOS")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(commando_data)
	end
	if old_view == 6 and general_data.vacant_limit > -1 then
		tech_unit = Find_Object_Type("VIEW_GENERALS")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Hero_Options(general_data)
	end
	if old_view == 7 then
		tech_unit = Find_Object_Type("VIEW_FIGHTERS")
		moff_data.active_player.Unlock_Tech(tech_unit)
		Disable_Fighter_Sets()
		fighter_assign_enabled = false
	end
	
	old_view = new_view
end

function RepublicHeroes:init_heroes()
	--Logger:trace("entering RepublicHeroes:init_heroes")
	init_hero_system(admiral_data)
	init_hero_system(moff_data)
	init_hero_system(council_data)
	init_hero_system(clone_data)
	init_hero_system(commando_data)
	init_hero_system(general_data)
	
	Set_Fighter_Hero("IMA_GUN_DI_DELTA","DAO_VENATOR")
	
	local tech_level = GlobalValue.Get("CURRENT_ERA")
	
	--Handle special actions for starting tech level
	if tech_level > 1 then
		Handle_Hero_Add("Tallon", admiral_data)
		Handle_Hero_Add("Pellaeon", admiral_data)
		Handle_Hero_Add("Baraka", admiral_data)
	end
	
	if tech_level == 2 then
		Handle_Hero_Add("Martz", admiral_data)
		Handle_Hero_Add("Jayfon", general_data)
	end
	
	if tech_level > 2 then
		--Handle_Hero_Exit("Dao", admiral_data)
		Handle_Hero_Exit("Martz", admiral_data)
		Handle_Hero_Exit("71", clone_data)

		Handle_Hero_Add("Tenant", admiral_data)
		Handle_Hero_Add("Jesra", general_data)
		Handle_Hero_Add("Ahsoka", council_data)
	end
	
	if tech_level > 3 then
		--Handle_Hero_Exit("Kilian", admiral_data)
		Handle_Hero_Exit("Knol", council_data)

		Handle_Hero_Add("Autem", admiral_data)

		set_unit_index("Maarisa", 2, admiral_data)
		set_unit_index("Block", 2, admiral_data)

		Eta_Unlock()
		Trachta_Checks = 1
		if not self.hero_clones_p2_disabled then
			self.Phase_II()
		end
	else
		local Grievous = Find_First_Object("Grievous_Malevolence_Hunt_Campaign")
		local McQuarrie = Find_First_Object("McQuarrie_Concept")
		if not TestValid(Grievous) and not TestValid(McQuarrie) then
			Set_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON","YULAREN_RESOLUTE")
		end
	end

	if tech_level > 4 then
		Handle_Hero_Add("Trachta", moff_data)

		Handle_Hero_Exit("Ahsoka", council_data)
		Handle_Hero_Exit("Halcyon", council_data)
		Handle_Hero_Exit("Gregor", commando_data)

		RepublicHeroes:Add_Fighter_Set("Odd_Ball_ARC170_Location_Set")
		RepublicHeroes:Add_Fighter_Set("Warthog_Republic_Z95_Location_Set")
	end
end

--Era transitions
function RepublicHeroes:Era_3()
	--Logger:trace("entering RepublicHeroes:Era_3")
	if Handle_Hero_Exit("Martz", admiral_data) then
		if admiral_data.active_player.Is_Human() then
			StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_REP_HERO_REPLACEMENT_SPEECH_MARTZ", 20, nil, "Piett_Loop", 0)
		end
	end
	Eta_Unlock()
	Clear_Fighter_Hero("BROADSIDE_SHADOW_SQUADRON")
	--RepublicHeroes:Add_Fighter_Set("Warthog_Torrent_Location_Set")
	--RepublicHeroes:Remove_Fighter_Set("Warthog_BTLB_Y-Wing_Location_Set")
end

function RepublicHeroes:Era_4()
	--Logger:trace("entering RepublicHeroes:Era_4")
	if Handle_Hero_Exit("Kilian", admiral_data) then
		if admiral_data.active_player.Is_Human() then
			StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_REP_HERO_REPLACEMENT_SPEECH_KILIAN", 20, nil, "Piett_Loop", 0)
		end
	end
	Autem_Check()
end

function RepublicHeroes:Era_5()
	--Logger:trace("entering RepublicHeroes:Era_5")
	Trachta_Check()
end

function RepublicHeroes:admiral_decrement(quantity, set, vacant)
	--Logger:trace("entering RepublicHeroes:admiral_decrement")
	local decrements = {}
	local systems = {admiral_data, moff_data, council_data, clone_data, commando_data, general_data}
	
	local start = set
	local stop = set
	if set == 0 then
		start = 1
		stop = table.getn(systems)
		decrements = quantity
	else
		decrements[set] = quantity
	end
	
	for id=start,stop do
		if vacant then
			Set_Locked_Slots(systems[id], decrements[id])
		else
			Decrement_Hero_Amount(decrements[id], systems[id])
		end
	end
end

function RepublicHeroes:admiral_lockin(list, set)
	--Logger:trace("entering RepublicHeroes:admiral_lockin")
	if set == 1 then
		lock_retires(list, admiral_data)
	end
	if set == 2 then
		lock_retires(list, moff_data)
	end
	if set == 3 then
		lock_retires(list, council_data)
	end
	if set == 4 then
		lock_retires(list, clone_data)
	end
	if set == 5 then
		lock_retires(list, commando_data)
	end
	if set == 6 then
		lock_retires(list, general_data)
	end
end

function RepublicHeroes:admiral_exit(list, set, storylock)
	--Logger:trace("entering RepublicHeroes:admiral_storylock")
	if set == 1 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, admiral_data, storylock)
		end
	end
	if set == 2 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, moff_data, storylock)
		end
	end
	if set == 3 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, council_data, storylock)
		end
	end
	if set == 4 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, clone_data, storylock)
		end
	end
	if set == 5 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, commando_data, storylock)
		end
	end
	if set == 6 then
		for _, tag in pairs(list) do
			Handle_Hero_Exit(tag, general_data, storylock)
		end
	end
end

function RepublicHeroes:admiral_return(list, set)
	--Logger:trace("entering RepublicHeroes:admiral_return")
	if set == 1 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, admiral_data) then
				Handle_Hero_Add(tag, admiral_data)
			end
		end
	end
	if set == 2 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, moff_data) then
				Handle_Hero_Add(tag, moff_data)
			end
		end
	end
	if set == 3 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, council_data) then
				Handle_Hero_Add(tag, council_data)
			end
		end
	end
	if set == 4 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, clone_data) then
				Handle_Hero_Add(tag, clone_data)
			end
		end
	end
	if set == 5 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, commando_data) then
				Handle_Hero_Add(tag, commando_data)
			end
		end
	end
	if set == 6 then
		for _, tag in pairs(list) do
			if check_hero_exists(tag, general_data) then
				Handle_Hero_Add(tag, general_data)
			end
		end
	end
end

function RepublicHeroes:on_galactic_hero_killed(hero_name, owner)
	--Logger:trace("entering RepublicHeroes:on_galactic_hero_killed")
	local tag_admiral = Handle_Hero_Killed(hero_name, owner, admiral_data)
	if tag_admiral == "Dao" then
		Handle_Hero_Add("Tenant", admiral_data)
		StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_REP_HERO_REPLACEMENT_SPEECH_TENANT", 20, nil, "Piett_Loop", 0)
	elseif tag_admiral == "Yularen" then
		if yularen_second_chance_used == false then
			yularen_second_chance_used = true
			if hero_name == "YULAREN_INVINCIBLE" then 
				UnitUtil.SetLockList("EMPIRE", {"Yularen_Integrity_66_Upgrade_Invincible"}, false)
			end
			admiral_data.full_list["Yularen"].unit_id = 4 --YULAREN_INTEGRITY_66
			Handle_Hero_Add("Yularen", admiral_data)
			if Find_Player("Empire").Is_Human() then
				StoryUtil.Multimedia("TEXT_SPEECH_YULAREN_RETURNS_INTEGRITY_IMP", 15, nil, "Piett_Loop", 0)
			end
		end
	end
	Handle_Hero_Killed(hero_name, owner, moff_data)
	Handle_Hero_Killed(hero_name, owner, council_data)
	local clone_tag = Handle_Hero_Killed(hero_name, owner, clone_data)
	if clone_tag == "Bly" then
		Handle_Hero_Add("Deviss", clone_data)
	elseif clone_tag == "Bacara" then
		Handle_Hero_Add("Jet", clone_data)
	elseif clone_tag == "Appo" then
		Bow_Check()
	elseif clone_tag == "Rex" then
		Vill_Check()
	end
	if hero_name == "ODD_BALL_P1_TEAM" or hero_name == "ODD_BALL_P2_TEAM" then
		if admiral_data.active_player.Is_Human() then
			RepublicHeroes:Add_Fighter_Set("Reform_Squad_Seven")
			UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_Torrent_Location_Set", false)
			UnitUtil.SetBuildable(admiral_data.active_player, "Odd_Ball_ARC170_Location_Set", false)
			Clear_Fighter_Hero("ODD_BALL_TORRENT_SQUAD_SEVEN_SQUADRON")
			Clear_Fighter_Hero("ODD_BALL_ARC170_SQUAD_SEVEN_SQUADRON")
			StoryUtil.ShowScreenText("Squad Seven has taken crippling casualties and must be reformed.", 5, nil, {r = 244, g = 244, b = 0})
		else
			admiral_data.active_player.Give_Money(-1000)
		end
	elseif hero_name == "WARTHOG_P1_TEAM" or hero_name == "WARTHOG_P2_TEAM" then
		if admiral_data.active_player.Is_Human() then
			RepublicHeroes:Add_Fighter_Set("Reform_Hunter_Squadron")
			UnitUtil.SetBuildable(admiral_data.active_player, "Warthog_Torrent_Location_Set", false)
			UnitUtil.SetBuildable(admiral_data.active_player, "Warthog_Republic_Z95_Location_Set", false)
			Clear_Fighter_Hero("WARTHOG_TORRENT_HUNTER_SQUADRON")
			Clear_Fighter_Hero("WARTHOG_REPUBLIC_Z95_HUNTER_SQUADRON")
			StoryUtil.ShowScreenText("Hunter Squadron has taken crippling casualties and must be reformed.", 5, nil, {r = 244, g = 244, b = 0})
		else
			admiral_data.active_player.Give_Money(-1000)
		end
	end
	Handle_Hero_Killed(hero_name, owner, commando_data)
	Handle_Hero_Killed(hero_name, owner, general_data)
end

function Eta_Unlock()
	--Logger:trace("entering RepublicHeroes:Eta_Unlock")
	set_unit_index("Yoda",2,council_data)
	set_unit_index("Mace",2,council_data)
	set_unit_index("Kit",2,council_data)
	set_unit_index("Mundi",2,council_data)
	set_unit_index("Luminara",2,council_data)
	set_unit_index("Barriss",2,council_data)
	set_unit_index("Ahsoka",2,council_data)
	set_unit_index("Aayla",2,council_data)
	set_unit_index("Shaak",2,council_data)
end

function RepublicHeroes:Phase_II()
	--Logger:trace("entering RepublicHeroes:Phase_II")
	if not Phase_II_Checked then
		clone_data.total_slots = clone_data.total_slots + 1
		clone_data.free_hero_slots = clone_data.free_hero_slots + 1
		
		set_unit_index("Cody",2,clone_data)
		set_unit_index("Rex",2,clone_data)
		set_unit_index("Appo",2,clone_data)
		set_unit_index("Bly",2,clone_data)
		set_unit_index("Deviss",2,clone_data)
		set_unit_index("Wolffe",2,clone_data)
		set_unit_index("Gree_Clone",2,clone_data)
		set_unit_index("71",2,clone_data)
		set_unit_index("Neyo",2,clone_data)
		set_unit_index("Bacara",2,clone_data)
		set_unit_index("Jet",2,clone_data)
		
		Handle_Hero_Add("Keller", clone_data)
		Handle_Hero_Add("Faie", clone_data)
		
		set_unit_index("Fordo",2,commando_data)
		set_unit_index("Alpha",2,commando_data)
		set_unit_index("Ordo",2,commando_data)
		set_unit_index("Aden",2,commando_data)
		set_unit_index("Prudii",2,commando_data)

		Bow_Check()
		Vill_Check()
		
		Unlock_Hero_Options(clone_data)
		Get_Active_Heroes(false, clone_data)
	end
	
	Phase_II_Checked = true
end

function RepublicHeroes:Venator_Heroes()
	--Logger:trace("entering RepublicHeroes:Venator_Heroes")
	if not Venator_init then
		admiral_data.total_slots = admiral_data.total_slots + 1
		admiral_data.free_hero_slots = admiral_data.free_hero_slots + 1

		moff_data.total_slots = moff_data.total_slots + 1
		moff_data.free_hero_slots = moff_data.free_hero_slots + 1
		Handle_Hero_Add("Yularen", admiral_data)
		Handle_Hero_Add("Wieler", admiral_data)
		Handle_Hero_Add("Coburn", admiral_data)
		Handle_Hero_Add("Kilian", admiral_data)
		Handle_Hero_Add("Dao", admiral_data)
		Handle_Hero_Add("Denimoor", admiral_data)
		Handle_Hero_Add("Dron", admiral_data)
		--Handle_Hero_Add("Forral", admiral_data) forral's now a fighter hero by default. 
		Handle_Hero_Add("Tarkin", moff_data)
		Handle_Hero_Add("Wessex", moff_data)
		Handle_Hero_Add("Grant", moff_data)
		Handle_Hero_Add("Vorru", moff_data)	
		Handle_Hero_Add("Byluir", moff_data)	
		-- FotR_Enhanced
		Handle_Hero_Add("Block", admiral_data)
		if self.tech_level > 2 then
			Handle_Hero_Exit("Dao", admiral_data)
		end
		
		if self.tech_level > 3 then
			Handle_Hero_Exit("Kilian", admiral_data)
		end
		--[[
		if admiral_data.active_player.Get_Tech_Level() < 4 then
			RepublicHeroes:Add_Fighter_Set("Odd_Ball_Torrent_Location_Set")
			RepublicHeroes:Add_Fighter_Set("Warthog_Torrent_Location_Set")
		end
		]]

		if self.tech_level < 4 then
			RepublicHeroes:Add_Fighter_Set("Odd_Ball_Torrent_Location_Set")
			RepublicHeroes:Add_Fighter_Set("Warthog_Torrent_Location_Set")
		end
		RepublicHeroes:Add_Fighter_Set("Arhul_Narra_Location_Set")
		RepublicHeroes:Add_Fighter_Set("Bythen_Forral_Location_Set")
		local upgrade_unit = Find_Object_Type("Maarisa_Retaliation_Upgrade")
		admiral_data.active_player.Unlock_Tech(upgrade_unit)
		
		Autem_Check()
		Trachta_Check()
		Forral_Check()
	end
	Venator_init = true
end

function Autem_Check()
	--Logger:trace("entering RepublicHeroes:Autem_Check")
	Autem_Checks = Autem_Checks + 1
	if Autem_Checks == 2 then
		Handle_Hero_Add("Autem", admiral_data)
		Handle_Hero_Add("Tenant", admiral_data)
		RepublicHeroes:Add_Fighter_Set("Odd_Ball_ARC170_Location_Set")
		Clear_Fighter_Hero("ODD_BALL_TORRENT_SQUAD_SEVEN_SQUADRON")
		RepublicHeroes:Remove_Fighter_Set("Odd_Ball_Torrent_Location_Set")
		RepublicHeroes:Add_Fighter_Set("Warthog_Torrent_Location_Set")
		Clear_Fighter_Hero("WARTHOG_TORRENT_HUNTER_SQUADRON")
		RepublicHeroes:Remove_Fighter_Set("Warthog_Torrent_Location_Set")
	end
end

function Trachta_Check()
	--Logger:trace("entering RepublicHeroes:Trachta_Check")
	Trachta_Checks = Trachta_Checks + 1
	if Trachta_Checks == 2 then
		Handle_Hero_Add("Trachta", moff_data)
	end
end

function Bow_Check()
	--Logger:trace("entering RepublicHeroes:Bow_Check")
	Bow_Checks = Bow_Checks + 1
	if Bow_Checks == 2 then
		Handle_Hero_Add("Bow", clone_data)
	end
end

function Vill_Check()
	--Logger:trace("entering RepublicHeroes:Vill_Check")
	Vill_Checks = Vill_Checks + 1
	if Vill_Checks == 2 then
		Handle_Hero_Add("Vill", clone_data)
	end
end

function RepublicHeroes:VSD_Heroes()
	if not VSD_init then
		admiral_data.total_slots = admiral_data.total_slots + 1
		admiral_data.free_hero_slots = admiral_data.free_hero_slots + 1
		--Logger:trace("entering RepublicHeroes:VSD_Heroes")
		Handle_Hero_Add("Dodonna", admiral_data)
		Handle_Hero_Add("Screed", admiral_data)
		Handle_Hero_Add("Praji", moff_data)
		Handle_Hero_Add("Ravik", moff_data)
		
		--RepublicHeroes:Add_Fighter_Set("Arhul_Narra_Location_Set")
		RepublicHeroes:Add_Fighter_Set("Jag_ARC170_Location_Set")
	end
	VSD_init = true
end

function RepublicHeroes:VSD2_Heroes()
	--Logger:trace("entering RepublicHeroes:VSD2_Heroes")
	Handle_Hero_Add("Parck", admiral_data)
	Handle_Hero_Add("Therbon", moff_data)
	
	RepublicHeroes:Add_Fighter_Set("Arhul_Narra_Location_Set")
end

function RepublicHeroes:Order_66_Handler()
	--Logger:trace("entering RepublicHeroes:Order_66_Handler")
	
	moff_data.total_slots = moff_data.total_slots + 1
	moff_data.free_hero_slots = moff_data.free_hero_slots + 1
	Unlock_Hero_Options(moff_data)
	Get_Active_Heroes(false, moff_data)
	
	council_data.vacant_limit = -1
	Handle_Hero_Exit("Autem", admiral_data)
	Handle_Hero_Exit("Dallin", admiral_data)

	-- Yularen sphat ability disabling action
	local yularen_resolute_present = Find_First_Object("YULAREN_RESOLUTE_SPHAT") or Find_First_Object("YULAREN_RESOLUTE")
	local yularen_integrity_present = Find_First_Object("YULAREN_INTEGRITY")
	
	if yularen_resolute_present then
		UnitUtil.ReplaceAtLocation("YULAREN_RESOLUTE", "YULAREN_RESOLUTE_66")
		UnitUtil.ReplaceAtLocation("YULAREN_RESOLUTE_SPHAT", "YULAREN_RESOLUTE_66")
		set_unit_index("Yularen", 2, admiral_data)
	elseif yularen_integrity_present then	
		UnitUtil.ReplaceAtLocation("YULAREN_INTEGRITY", "YULAREN_INTEGRITY_66")
		set_unit_index("Yularen", 4, admiral_data)
	end

	Clear_Fighter_Hero("IMA_GUN_DI_DELTA")
	Decrement_Hero_Amount(10, council_data)
	Forral_Check()
	
end

function RepublicHeroes:New_Padawan_Handler()
	--Logger:trace("entering RepublicHeroes:New_Padawan_Handler")
	
	Handle_Hero_Add("Ahsoka", council_data)
end

function RepublicHeroes:Sector_Governance_Decree_Handler()
	--Logger:trace("entering RepublicHeroes:Sector_Governance_Decree_Handler")

	moff_data.total_slots = moff_data.total_slots + 1
	moff_data.free_hero_slots = moff_data.free_hero_slots + 1
	Unlock_Hero_Options(moff_data)
	Get_Active_Heroes(false, moff_data)

	general_data.total_slots = general_data.total_slots + 1
	general_data.free_hero_slots = general_data.free_hero_slots + 1
	Unlock_Hero_Options(general_data)
	Get_Active_Heroes(false, general_data)
end

function RepublicHeroes:Enhanced_Security_Act_Support_Handler()
	--Logger:trace("entering RepublicHeroes:Enhanced_Security_Act_Support_Handler")

	moff_data.total_slots = moff_data.total_slots + 1
	moff_data.free_hero_slots = moff_data.free_hero_slots + 1
	Unlock_Hero_Options(moff_data)
	Get_Active_Heroes(false, moff_data)
end

function RepublicHeroes:Enhanced_Security_Act_Prevent_Handler()
	--Logger:trace("entering RepublicHeroes:Enhanced_Security_Act_Prevent_Handler")

	council_data.total_slots = council_data.total_slots + 1
	council_data.free_hero_slots = council_data.free_hero_slots + 1
	Unlock_Hero_Options(council_data)
	Get_Active_Heroes(false, council_data)
end

function RepublicHeroes:Special_Task_Force_Handler()
	--Logger:trace("entering RepublicHeroes:Special_Task_Force_Handler")

	council_data.total_slots = council_data.total_slots + 1
	council_data.free_hero_slots = council_data.free_hero_slots + 1
	Unlock_Hero_Options(council_data)
	Get_Active_Heroes(false, council_data)

	clone_data.total_slots = clone_data.total_slots + 1
	clone_data.free_hero_slots = clone_data.free_hero_slots + 1
	Unlock_Hero_Options(clone_data)
	Get_Active_Heroes(false, clone_data)

	admiral_data.total_slots = admiral_data.total_slots + 1
	admiral_data.free_hero_slots = admiral_data.free_hero_slots + 1
	Unlock_Hero_Options(admiral_data)
	Get_Active_Heroes(false, admiral_data)
end

function Enable_Fighter_Sets()
	--Logger:trace("entering RepublicHeroes:Enable_Fighter_Sets")
	for _, setter in pairs(fighter_assigns) do
		tech_unit = Find_Object_Type(setter)
		moff_data.active_player.Unlock_Tech(tech_unit)
	end
end

function Disable_Fighter_Sets()
	--Logger:trace("entering RepublicHeroes:Disable_Fighter_Sets")
	for _, setter in pairs(fighter_assigns) do
		tech_unit = Find_Object_Type(setter)
		moff_data.active_player.Lock_Tech(tech_unit)
	end
end

function RepublicHeroes:Add_Fighter_Sets(sets)
--Logger:trace("entering RepublicHeroes:Add_Fighter_Sets")
	for _, set in pairs(sets) do
		RepublicHeroes:Add_Fighter_Set(set, true)
	end
	if fighter_assign_enabled then
		Enable_Fighter_Sets()
	end
end

function RepublicHeroes:Add_Fighter_Set(set, nounlock)
--Logger:trace("entering RepublicHeroes:Add_Fighter_Set")
	--Wrapper for avoiding duplicates in list
	for i, setter in pairs(fighter_assigns) do
		if setter == set then
			return
		end
	end
	table.insert(fighter_assigns,set)
	if fighter_assign_enabled and nounlock == nil then
		Enable_Fighter_Sets()
	end
end

function RepublicHeroes:Remove_Fighter_Sets(sets)
--Logger:trace("entering RepublicHeroes:Disable_Fighter_Sets")
	for _, set in pairs(sets) do
		RepublicHeroes:Remove_Fighter_Set(set, true)
	end
	if fighter_assign_enabled then
		Enable_Fighter_Sets()
	end
end

function RepublicHeroes:Remove_Fighter_Set(set, nolock)
--Logger:trace("entering RepublicHeroes:Disable_Fighter_Set")
	for i, setter in pairs(fighter_assigns) do
		if setter == set then
			table.remove(fighter_assigns,i)
			local assign_unit = Find_Object_Type(setter)
			admiral_data.active_player.Lock_Tech(assign_unit)
		end
	end
	if fighter_assign_enabled and nolock == nil then
		Enable_Fighter_Sets()
	end
end

-- FotR_Enhanced
function RepublicHeroes:Geen_Unlock()
	Handle_Hero_Add("Geen", general_data)
end

function RepublicHeroes:Order_65_Handler()
	--init_hero_system(senator_data)
	Forral_Check()
	-- below doesn't work
	--[[if admiral_data.active_player.Is_Human() then 
		StoryUtil.Multimedia("TEXT_CONQUEST_GOVERNMENT_REP_HERO_SWITCH_SPEECH_FORRAL", 20, nil, "Commander_Moff_Loop", 0)
	end]]
end

function Forral_Check()
	--Logger:trace("entering RepublicHeroes:Forral_Check")
	Forral_Checks = Forral_Checks + 1
	if Forral_Checks == 2 then
		Handle_Hero_Add("Forral", admiral_data)
		Clear_Fighter_Hero("BYTHEN_FORRAL_SQUADRON")
		RepublicHeroes:Remove_Fighter_Set("Bythen_Forral_Location_Set")
	end
end

function RepublicHeroes:Dallin_Unlock()
	Handle_Hero_Add("Dallin", admiral_data)
end