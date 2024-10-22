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
--*   @Filename:            UnitSwitcherLibrary.lua
--*   @Last modified by:    [TR]Jorritkarwehr
--*   @Last modified time:  2018-03-26T09:58:14+02:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************

function Get_Swap_Entry(upgrade_object)
	local swaps = {
		["GRIEVOUSRECU2IH"] = {"Grievous_Recusant","Grievous_Team"},
		["GRIEVOUSIH2RECU"] = {"Invisible_Hand","Grievous_Team_Recusant"},
		["GRIEVOUS_TEAM_PROVIDENCE_MUNIFICENT"] = {"Grievous_Munificent","Grievous_Team"},
		["GRIEVOUS_TEAM_RECUSANT_MUNIFICENT"] = {"Grievous_Munificent","Grievous_Team_Recusant"},
		["GRIEVOUS_TEAM_MALEVOLENCE_PROVIDENCE"] = {"Invisible_Hand","Grievous_Team_Malevolence"},
		["GRIEVOUS_TEAM_MALEVOLENCE_RECUSANT"] = {"Grievous_Recusant","Grievous_Team_Malevolence"},
		["DUMMY_RESEARCH_MALEVOLENCE_2_RECUSANT"] = {"Grievous_Recusant","Grievous_Team_Malevolence_2"},
		["DUMMY_RESEARCH_MALEVOLENCE_2_MUNIFICENT"] = {"Grievous_Munificent","Grievous_Team_Malevolence_2"},
		["YULAREN_RESOLUTE_UPGRADE_INVINCIBLE"] = {"Yularen_Resolute","Yularen_Invincible"},
		["YULAREN_INTEGRITY_UPGRADE_INVINCIBLE"] = {"Yularen_Integrity","Yularen_Invincible"},
		["MAARISA_RETALIATION_UPGRADE"] = {"Maarisa_Captor","Maarisa_Retaliation"},
		["TALLON_BATTALION_UPGRADE"] = {"Tallon_Sundiver","Tallon_Battalion"},
		["TARKIN_EXECUTRIX_UPGRADE"] = {"Tarkin_Venator","Tarkin_Executrix"},
		["ONARA_KUAT_MANDATOR_UPGRADE"] = {"Onara_Kuat","Onara_Kuat_Mandator"},
		["DREADNAUGHT_CARRIER_UPGRADE"] = {"Dreadnaught_Lasers","Dreadnaught_Carrier",["location_check"] = true},
		["MANDATOR_II_UPGRADE"] = {"Generic_Mandator","Generic_Mandator_II",["location_check"] = true},
		["BATTLECARRIER_LUCREHULK_UPGRADE"] = {"Auxiliary_Lucrehulk","Generic_Lucrehulk",["location_check"] = true},
		["VENATOR_REFIT_UPGRADE"] = {"Generic_Venator","Venator_Refit",["location_check"] = true},
		["SUPPORT_PROTECTORS"] = {nil,{"Spar_Team", "Fenn_Shysa_Team", "Tobbi_Dala_Team", "Mandalorian_Soldier_Company", "Mandalorian_Commando_Company"}},
		["SUPPORT_DEATH_WATCH"] = {nil,{"Pre_Vizsla_Team", "Bo_Katan_Team", "Lorka_Gedyc_Team", "Mandalorian_Soldier_Company", "Mandalorian_Commando_Company"}},
		["SHADOW_COLLECTIVE"] = {nil,{"Darth_Maul_Team", "Savage_Opress_Team", "Mandalorian_Commando_Company", "Mandalorian_Commando_Company"}},
		--FotR_Enhanced
		["OFC_SPHA_T_REFIT"] = {"Generic_Venator_OFC","Generic_Venator_SPHA_T",["location_check"] = true},
	}
	return swaps[upgrade_object]
end