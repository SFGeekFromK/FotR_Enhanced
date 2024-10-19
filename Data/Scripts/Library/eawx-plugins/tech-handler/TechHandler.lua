require("deepcore/std/class")
require("eawx-events/GenericResearch")
require("eawx-events/GenericSwap")
require("eawx-events/TechHelper")

---@class TechManager
TechManager = class()

function TechManager:new(galactic_conquest, human_player, planets, unlocktech)
	self.galactic_conquest = galactic_conquest
	self.human_player = human_player
	self.planets = planets
	self.unlocktech = unlocktech
	
	if self.unlocktech ~= false then
		self.UtatResearch = GenericResearch(self.galactic_conquest, 
			"UTAT_RESEARCH", 
			"Template_Research_Dummy", {"Empire"}, 
			{"Republic_UT_AT_Speeder_Company"}, 
			{}, 
			{"Republic_UT_AT_Speeder_Company", "Republic_UT_AT_Speeder_Company"},"Kuat",
			{"GEEN_UNLOCK"})

		self.VenatorResearch = GenericResearch(self.galactic_conquest, 
			"VENATOR_RESEARCH", 
			"Dummy_Research_Venator", {"Empire"},
			{"Generic_Venator", "Generic_Venator_OFC", "OFC_SPHA_T_Refit"},
			{},
			{},
			"Kuat",
			{"VENATOR_HEROES"})

		self.VictoryResearch = GenericResearch(self.galactic_conquest,
			"VICTORY_RESEARCH",
			"Dummy_Research_Victory", {"Empire"},
			{"Generic_Victory_Destroyer"},
			{},
			{"Generic_Victory_Destroyer", "Generic_Victory_Destroyer"},"Kuat",
			{"VICTORY_HEROES"})

		self.BulwarkResearch = GenericResearch(self.galactic_conquest,
			"BULWARK_RESEARCH",
			"Dummy_Research_Bulwark", {"Rebel"},
			{"Bulwark_I"},
			{}, 
			{"Bulwark_I", "Dua_Ningo_Unrepentant"}, "Foerost")

		self.PhaseIIResearch = GenericResearch(self.galactic_conquest,
			"PHASE_TWO_RESEARCH",
			"Dummy_Research_Clone_Trooper_II", {"Empire"}, 
			{"Clonetrooper_Phase_Two_Team", "Republic_BARC_Company", "ARC_Phase_Two_Team"},
			{"Clonetrooper_Phase_One_Team", "Republic_74Z_Bike_Company", "ARC_Phase_One_Team"}, nil, nil,
			{"CLONE_UPGRADES"})

		self.Victory2Research = GenericResearch(self.galactic_conquest,
			"VICTORY2_RESEARCH",
			"Dummy_Research_Victory2", {"Empire"},
			{"Generic_Victory_Destroyer_Two"},
			{},
			{},
			"Kuat",
			{"VICTORY2_HEROES"})
			
		self.Bulwark2Research = GenericResearch(self.galactic_conquest,
			"BULWARK2_RESEARCH",
			"Dummy_Research_Bulwark2", {"Rebel"},
			{"Bulwark_II"})
		
		--Year One

		self.YearOneCIS = GenericResearch(self.galactic_conquest,
			"YEAR_ONE_CIS",
			"Template_Research_Dummy", {"Rebel"},
			{"Pursuer_Enforcement_Ship_Squadron", "Battleship_Lucrehulk"},
			{"CIS_GAT_Group"},
			{},"Raxus_Second",
			{"YEAR_ONE_CORPS_FINISHED"})

		self.YearOneCorps = GenericResearch(self.galactic_conquest,
			"YEAR_ONE_CORPS",
			"Template_Research_Dummy", {"Trade_Federation", "Commerce_Guild", "Banking_Clan", "Techno_Union"},
			{},
			{"CIS_GAT_Group"},
			{},"Hypori",
			{"YEAR_ONE_REP_FINISHED"})

		self.YearOneRep = GenericResearch(self.galactic_conquest,
			"YEAR_ONE_REP",
			"Template_Research_Dummy", {"Empire"},
			{"Republic_ISP_Company", "Republic_Flashblind_Group"},
			{"Invincible_Cruiser", "Republic_Gaba18_Group", "Republic_AT_XT_Company"})

		-- Year Two

		self.YearTwoCIS = GenericResearch(self.galactic_conquest,
			"YEAR_TWO_CIS",
			"Template_Research_Dummy", {"Rebel"},
			{"HMP_Group", "Destroyer_Droid_II_Company", "Magna_Missile_Company"},
			{"Magna_Company"},
			{},"Raxus_Second",
			{"YEAR_TWO_CORPS_FINISHED"})

		self.YearTwoCorps = GenericResearch(self.galactic_conquest,
			"YEAR_TWO_CORPS",
			"Template_Research_Dummy", {"Trade_Federation", "Commerce_Guild", "Banking_Clan", "Techno_Union"},
			{"HMP_Group", "Destroyer_Droid_II_Company"},
			{},
			{},"Hypori",
			{"YEAR_TWO_REP_FINISHED"})

		self.YearTwoRep = GenericResearch(self.galactic_conquest,
			"YEAR_TWO_REP",
			"Template_Research_Dummy", {"Empire"},
			{"Generic_Acclamator_Assault_Ship_II", "Republic_HAET_Group", "Republic_AT_AP_Walker_Company", "Republic_AT_OT_Walker_Company", "Republic_A6_Juggernaut_Company"},
			{"Republic_Flashblind_Group", "Republic_A5_Juggernaut_Company"})

		-- Year Three
		-- We don't do these.			
			
		self.TechHelper = TechHelper(self.galactic_conquest)
	end

	self.CloneSwap = GenericSwap("CLONE_UPGRADES", "EMPIRE",
		{"Cody", "Rex", "Appo", "Commander_71", "Bacara", "Jet", "Gree_Clone", "Deviss", "Bly", "Wolffe", "Neyo", "Alpha_17", "Fordo", "Ordo_Skirata", "Aden_Skirata"},
		{"Cody2_Team", "Rex2_Team", "Appo2_Team", "Commander_71_2_Team", "Bacara2_Team", "Jet2_Team", "Gree2_Team", "Deviss2_Team", "Bly2_Team", "Wolffe2_Team", "Neyo2_Team", "Alpha_17_2_Team", "Fordo2_Team", "Ordo_Skirata2_Team", "Aden_Skirata2_Team"})

	self.TempestResearch = GenericResearch(self.galactic_conquest,
		"TEMPEST_RESEARCH",
		"Dummy_Research_Tempest", {"Hutt_Cartels"},
		{"Tempest_Cruiser"},
		{}, 
		{"Mika_Tempest"}, "Nal_Hutta")

end

return TechManager