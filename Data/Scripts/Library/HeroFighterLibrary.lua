--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              [TR]Jorritkarwehr
--*   @Date:                2018-03-20T01:27:01+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            HeroFighterLibrary.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2021-05-25T09:58:	14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************
function Get_Hero_Entries(upgrade_object)
	--Index is name of build option to open popup
	--Hero_Squadron = name of spawned squadron
	--PopupHeader = name of header object for popup
	--Options = first item in sublist is popup option suffix. Locations is a list of all heroes who are associated with this option. Optionally, GroundPerceptions is a list of perceptions to detect these heroes for ground forms. Hero and perception order must match
	--NoInit = optional parameter to prevent fighter from being automatically assigned to the first listed hero in the first option on startup
	--Faction = specifies faction for perceptions
	--NoPlayerInit = NoInit for the player only. Requires Faction
	--GroundCompany = name of company to add to reinforcements when squadron/ship is in orbit. Requires GroundPerceptions and Faction
	
	--When piggybacking reinforcement system to check for orbital object instead of squadron, set a dummy index that does not match any buildable object and set NoInit to prevent all the missing fields from causing errors. 
	--GroundReinforcementPerception = the perception to detect when a unit is in orbit. Requires Faction and GroundCompany
	--NoSpawnFlag = nameof global variable that will prevent spawn

	local heroes = {
	--GAR
	["ARHUL_NARRA_LOCATION_SET"] = {
		Hero_Squadron = "ARHUL_NARRA_GUARDIAN_SQUADRON",
		PopupHeader = "ARHUL_NARRA_SELECTOR_HEADER",
		Options = {
			-- FotR_Enhanced Assignable Heroes changed
			--{"DODONNA", Locations = {"DODONNA_ARDENT"}},
			{"TARKIN", Locations = {"TARKIN_VENATOR","TARKIN_EXECUTRIX"}},
			{"PARCK", Locations = {"PARCK_STRIKEFAST"}},
			{"THERBON", Locations = {"THERBON_CERULEAN_SUNRISE"}},
		}
	},
	["ERK_HARMAN_LOCATION_SET"] = {
		Hero_Squadron = "ERK_HARMAN_SQUADRON",
		PopupHeader = "ERK_HARMAN_SELECTOR_HEADER",
		Options = {
			{"SLAYKE", Locations = {"ZOZRIDOR_SLAYKE_CARRACK","ZOZRIDOR_SLAYKE_CR90"}},
			{"TARKIN", Locations = {"TARKIN_VENATOR","TARKIN_EXECUTRIX"}},
		}
	},
	["GARVEN_DREIS_LOCATION_SET"] = {
		Hero_Squadron = "GARVEN_DREIS_RAREFIED_SQUADRON",
		PopupHeader = "GARVEN_DREIS_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			{"RAVIK", Locations = {"RAVIK_VICTORY"}},
			{"PRAJI", Locations = {"PRAJI_VALORUM"}},
			{"GRUMBY", Locations = {"GRUMBY_INVINCIBLE"}},
			{"SCREED", Locations = {"SCREED_ARLIONNE"}},
		}
	},
	["NIAL_DECLANN_LOCATION_SET"] = {
		Hero_Squadron = "NIAL_DECLANN_SQUADRON",
		PopupHeader = "NIAL_DECLANN_SELECTOR_HEADER",
		Options = {
			--{"BARAKA", Locations = {"BARAKA_NEXU"}},
			{"WESSEL", Locations = {"WESSEL_ACCLAMATOR"}},
			{"PELLAEON", Locations = {"PELLAEON_LEVELER"}},
			{"MARTZ", Locations = {"MARTZ_PROSECUTOR"}},
			{"TALLON", Locations = {"TALLON_SUNDIVER","TALLON_BATTALION"}},
		}
	},
	["RHYS_DALLOWS_LOCATION_SET"] = {
		Hero_Squadron = "RHYS_DALLOWS_BRAVO_SQUADRON",
		PopupHeader = "RHYS_DALLOWS_SELECTOR_HEADER",
		Options = {
			--{"DALLIN", Locations = {"DALLIN_KEBIR"}}, text also changed
			{"HAUSER", Locations = {"HAUSER_DREADNAUGHT"}},
			{"MAARISA", Locations = {"MAARISA_CAPTOR","MAARISA_RETALIATION"}},
			{"GRANT", Locations = {"GRANT_VENATOR"}},
		}
	},
	["ODD_BALL_TORRENT_LOCATION_SET"] = {
		Hero_Squadron = "ODD_BALL_TORRENT_SQUAD_SEVEN_SQUADRON",
		PopupHeader = "ODD_BALL_P1_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			-- FotR_Enhanced Assignable Heroes changed
			{
			"YULAREN", Locations = {"YULAREN_RESOLUTE","YULAREN_INTEGRITY","YULAREN_INVINCIBLE","YULAREN_RESOLUTE_SPHAT","YULAREN_RESOLUTE_66","YULAREN_INTEGRITY_66"}, 
			GroundPerceptions = {"Yularen_Resolute_In_Orbit","Yularen_Integrity_In_Orbit","Yularen_Invincible_In_Orbit", "Yularen_Resolute_SPHAT_In_Orbit","Yularen_Resolute_66_In_Orbit","Yularen_Integrity_66_In_Orbit"}
			},
			{"WESSEX", Locations = {"WESSEX_REDOUBT"}, GroundPerceptions = {"Wessex_In_Orbit"}},
			{"BLOCK", Locations = {"BLOCK_NEGOTIATOR","BLOCK_VIGILANCE"}, GroundPerceptions = {"Block_Negotiator_In_Orbit","Block_Vigilance_In_Orbit"}}
		},
		GroundCompany = "Odd_Ball_P1_Team",
		Faction = "Empire"
	},
	["ODD_BALL_ARC170_LOCATION_SET"] = {
		Hero_Squadron = "ODD_BALL_ARC170_SQUAD_SEVEN_SQUADRON",
		PopupHeader = "ODD_BALL_P2_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			-- FotR_Enhanced Assignable Heroes changed
			{
			"YULAREN", Locations = {"YULAREN_RESOLUTE","YULAREN_INTEGRITY","YULAREN_INVINCIBLE","YULAREN_RESOLUTE_SPHAT","YULAREN_RESOLUTE_66","YULAREN_INTEGRITY_66"}, 
			GroundPerceptions = {"Yularen_Resolute_In_Orbit","Yularen_Integrity_In_Orbit","Yularen_Invincible_In_Orbit", "Yularen_Resolute_SPHAT_In_Orbit","Yularen_Resolute_66_In_Orbit","Yularen_Integrity_66_In_Orbit"}
			},
			{"WESSEX", Locations = {"WESSEX_REDOUBT"}, GroundPerceptions = {"Wessex_In_Orbit"}},
			{"BLOCK", Locations = {"BLOCK_NEGOTIATOR","BLOCK_VIGILANCE"}, GroundPerceptions = {"Block_Negotiator_In_Orbit","Block_Vigilance_In_Orbit"}}
		},
		GroundCompany = "Odd_Ball_P2_Team",
		Faction = "Empire"
	},
	-- FotR_Enhanced
	["WARTHOG_TORRENT_LOCATION_SET"] = {
		Hero_Squadron = "WARTHOG_TORRENT_HUNTER_SQUADRON",
		PopupHeader = "WARTHOG_P1_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			{"WIELER", Locations = {"WIELER_RESILIENT"}, GroundPerceptions = {"Wieler_In_Orbit"}},
			{"COBURN", Locations = {"COBURN_TRIUMPHANT"}, GroundPerceptions = {"Coburn_In_Orbit"}},
			{"DRON", Locations = {"DRON_VENATOR"}, GroundPerceptions = {"Dron_In_Orbit"}},
			{"KILIAN", Locations = {"KILIAN_ENDURANCE"}, GroundPerceptions = {"Kilian_In_Orbit"}},
		},
		GroundCompany = "Warthog_P1_Team",
		Faction = "Empire"

	},
	["WARTHOG_REPUBLIC_Z95_LOCATION_SET"] = {
		Hero_Squadron = "WARTHOG_REPUBLIC_Z95_HUNTER_SQUADRON",
		PopupHeader = "WARTHOG_P2_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			{"WIELER", Locations = {"WIELER_RESILIENT"}, GroundPerceptions = {"Wieler_In_Orbit"}},
			{"COBURN", Locations = {"COBURN_TRIUMPHANT"}, GroundPerceptions = {"Coburn_In_Orbit"}},
			{"DRON", Locations = {"DRON_VENATOR"}, GroundPerceptions = {"Dron_In_Orbit"}},
			{"KILIAN", Locations = {"KILIAN_ENDURANCE"}, GroundPerceptions = {"Kilian_In_Orbit"}},
		},
		GroundCompany = "Warthog_P2_Team",
		Faction = "Empire"

	},
	["JAG_ARC170_LOCATION_SET"] = {
		Hero_Squadron = "JAG_ARC170_127TH_SQUADRON",
		PopupHeader = "JAG_P2_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			{"DODONNA", Locations = {"DODONNA_ARDENT"}},
			{"DALLIN", Locations =  {"DALLIN_KEBIR"}},
			{"AUTEM", Locations = {"AUTEM_VENATOR"}},
		},
		Faction = "Empire"

	},
	["BYTHEN_FORRAL_LOCATION_SET"] = {
		Hero_Squadron = "BYTHEN_FORRAL_SQUADRON",
		PopupHeader = "BYTHEN_FORRAL_SELECTOR_HEADER",
		Options = {
			{"BARAKA", Locations = {"BARAKA_NEXU"}},
			{"SEERDON", Locations = {"SEERDON_INVINCIBLE"}},
			{"DENIMOOR", Locations = {"DENIMOOR_TENACIOUS"}}
		},
		Faction = "Empire"
	},
	--CIS
	["DFS1VR_LOCATION_SET"] = {
		Hero_Squadron = "DFS1VR_31ST_SQUADRON",
		PopupHeader = "DFS1VR_SELECTOR_HEADER",
		Options = {
			{"TF1726", Locations = {"TF1726_MUNIFICENT"}},
			{"K2B4", Locations = {"K2B4_PROVIDENCE"}},
			{"AUTO", Locations = {"AUTO_PROVIDENCE"}},
			{"DOCTOR", Locations = {"DOCTOR_INSTINCTION"}},
			{"COLICOID", Locations = {"COLICOID_SWARM"}},
		}
	},
	["NAS_GHENT_LOCATION_SET"] = {
		Hero_Squadron = "NAS_GHENT_SQUADRON",
		PopupHeader = "NAS_GHENT_SELECTOR_HEADER",
		Options = {
			{"GRIEVOUS", Locations = {"GRIEVOUS_RECUSANT","GRIEVOUS_MUNIFICENT","INVISIBLE_HAND","GRIEVOUS_MALEVOLENCE","GRIEVOUS_MALEVOLENCE_2", "GRIEVOUS_MALEVOLENCE_HUNT_CAMPAIGN"}},
			{"STARK", Locations = {"STARK_RECUSANT"}},
		}
	},
	["RAINA_QUILL_LOCATION_SET"] = {
		Hero_Squadron = "RAINA_QUILL_SQUADRON",
		PopupHeader = "RAINA_QUILL_SELECTOR_HEADER",
		Options = {
			{"NINGO", Locations = {"DUA_NINGO_UNREPENTANT"}},
			{"HARSOL", Locations = {"HARSOL_MUNIFICENT"}},
			{"MERAI", Locations = {"MERAI_FREE_DAC"}},
			{"SHONN", Locations = {"SHONN_RECUSANT"}},
		}
	},
	["VULPUS_LOCATION_SET"] = {
		Hero_Squadron = "VULPUS_SQUADRON",
		PopupHeader = "VULPUS_SELECTOR_HEADER",
		Options = {
			{"TONITH", Locations = {"TONITH_CORPULENTUS"}},
			{"LUCID", Locations = {"LUCID_VOICE"}},
			{"CALLI", Locations = {"CALLI_TRILM_BULWARK"}},
			{"K2B4", Locations = {"K2B4_PROVIDENCE"}},
		}
	},
	["GRIEVOUS_MUNIFICENT_GROUND"] = {
		NoInit = true,
		GroundReinforcementPerception = "HFM_Malevolence_In_Orbit",
		GroundCompany = "Grievous_Team_Munificent",
		Faction = "Rebel",
		NoSpawnFlag = "GRIEVOUS_DEAD",
	},

	--Hutts
	["PIKNAB_CARSELS_LOCATION_SET"] = {
		Hero_Squadron = "Piknab_Carsels_Gungan_Glory_Squadron",
		PopupHeader = "PIKNAB_CARSELS_SELECTOR_HEADER",
		Options = {
			{"RIBOGA", Locations = {"RIBOGA_RIGHTFUL_DOMINION"}},
			{"ULAL", Locations = {"ULAL_POTALA_UM_VAR"}},
			{"GANIS", Locations = {"GANIS_NAL_HUTTA_JEWEL"}},
			{"JABBA", Locations = {"JABBA_STAR_JEWEL"}},
			{"JILIAC", Locations = {"JILIAC_DRAGON_PEARL"}},
		}
	},
	["SSURUSSK_LOCATION_SET"] = {
		Hero_Squadron = "SSURUSSK_NEBULA_RAIDERS",
		PopupHeader = "SSURUSSK_SELECTOR_HEADER",
		NoInit = true,
		Options = {
			{"PUNDAR", Locations = {"PUNDAR_PROFIT"}},
			{"QUIST", Locations = {"QUIST_PINNACE"}},
			{"SLAGORTH", Locations = {"SLAGORTH_ARC"}},
			{"SELIMA_KIM", Locations = {"SELIMA_KIM_BLOODTHIRSTY"}},
			{"EYTTYRMIN_BATIIV", Locations = {"EYTTYRMIN_BATIIV"}},
			{"SORORITY", Locations = {"VEILED_QUEEN_SAVRIP"}},
			{"ZAN_DANE", Locations = {"DANE_SWEET_VICTORY"}},
			{"TARGRIM", Locations = {"TARGRIM_C9979"}},
			{"AYCEN", Locations = {"AYCEN_FREEJACK"}},
			{"NORULAC", Locations = {"NORULAC_FREEBOOTERS"}},
			{"ARDELLA", Locations = {"ARDELLA_SMOKESWIMMER"}},
			{"RENTHAL", Locations = {"RENTHALS_FIST"}},
			{"DREDNAR", Locations = {"DREDNAR_SABLE_III"}},
			{"VULTURE_PIRATES", Locations = {"VULTURE_PIRATES"}},
			{"LOOSE_CANNON", Locations = {"LOOSE_CANNON_PIRATES"}},
		}
	},
}


if upgrade_object ~= nil then
		return heroes[upgrade_object]
	end
	return heroes
end