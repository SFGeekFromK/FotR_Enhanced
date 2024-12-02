require("deepcore/std/class")
StoryUtil = require("eawx-util/StoryUtil")
UnitUtil = require("eawx-util/UnitUtil")
require("deepcore/crossplot/crossplot")
require("PGStoryMode")
require("eawx-util/Sort")
require("deepcore/std/class")
require("eawx-events/GenericResearch")
require("eawx-events/GenericSwap")
require("eawx-events/TechHelper")

---@class GovernmentRepublic
GovernmentRepublic = class()

function GovernmentRepublic:new(gc,id,gc_name)
	self.RepublicPlayer = Find_Player("Empire")
	self.human_player = Find_Player("local")

	GlobalValue.Set("ChiefOfState", "DUMMY_CHIEFOFSTATE_PALPATINE")
	GlobalValue.Set("ChiefOfStatePreference", "DUMMY_CHIEFOFSTATE_PALPATINE")
	self.ChoiceMade = false
	self.Cycles = 0

	GlobalValue.Set("CLONE_DEFAULT", 1)
	self.CloneSkins = {
		"Default clone armour reset",	
		"Default clone armour set to 212th",
		"Default clone armour set to 501st",
		"Default clone armour set to 104th",
		"Default clone armour set to 327th",
		"Default clone armour set to 187th",
		"Default clone armour set to 21st",
		"Default clone armour set to 41st"		
	}

	GlobalValue.Set("SHIPS_DECOLORED", 0)

	self.War_Mobilization = false
	self.Imperialization = false

	if GlobalValue.Get("CURRENT_ERA") <= 2 then
		self.CurrentMilitarizationTag = "PRE_CLONE_WAR"
	end
	if GlobalValue.Get("CURRENT_ERA") >= 3 then
		self.CurrentMilitarizationTag = "WAR_MOBILIZATION"
		self.War_Mobilization = true
	end

	self.Active_Planets = StoryUtil.GetSafePlanetTable()

	self.rep_starbase = Find_Object_Type("Empire_Star_Base_1")
	self.rep_gov_building = Find_Object_Type("Empire_MoffPalace")

	self.standard_integrate = false

	GCEventTable = {
		["PROGRESSIVE"] = {EventName = "START_REPUBLIC_FUTURE"},
		["FTGU"] = {EventName = "START_REPUBLIC_FUTURE"},
		["MALEVOLENCE"] = {EventName = "START_SPECIAL_TASKFORCE_FUNDING"},
		["RIMWARD"] = {EventName = "START_MILITARY_ENHANCEMENT_BILL"},
		["TENNUUTTA"] = {EventName = "START_BLISSEX_RESEARCH_FUNDING"},
		["KNIGHT_HAMMER"] = {EventName = "START_ENHANCED_SECURITY_ACT"},
		["DURGES_LANCE"] = {EventName = "START_KUAT_POWER_STRUGGLE"},
		["FOEROST"] = {EventName = "START_CORE_WORLDS_SECURITY_ACT"},
		["OUTER_RIM_SIEGES"] = {EventName = "START_SECTOR_GOVERNANCE_DECREE"},
	}

	self.id = id
	self.gc_name = gc_name

	if self.gc_name == "PROGRESSIVE" then
		self.standard_integrate = true
	end

	self.production_finished_event = gc.Events.GalacticProductionFinished
	self.production_finished_event:attach_listener(self.on_construction_finished, self)

	crossplot:subscribe("SENATE_SUPPORT_REACHED", self.ChoiceChecker, self)
end

function GovernmentRepublic:Update()
	--Logger:trace("entering GovernmentRepublic:Update")
	local current = GetCurrentTime()

	self.Cycles = self.Cycles + 1
end

function GovernmentRepublic:on_construction_finished(planet, game_object_type_name)
	--Logger:trace("entering GovernmentRepublic:on_construction_finished")

	if game_object_type_name == "OPTION_CYCLE_CLONES" then
		self:Option_Cycle_Clone_Colour()

	elseif game_object_type_name == "REPUBLIC_FUTURE_SUPPORT_MOTHMA" then
		if self.ChoiceMade == false then
			Story_Event("REPUBLIC_FUTURE_MOTHMA")
			UnitUtil.SetLockList("EMPIRE", {"REPUBLIC_FUTURE_SUPPORT_PALPATINE", "REPUBLIC_FUTURE_SUPPORT_MOTHMA"}, false)
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "REPUBLIC_FUTURE_SUPPORT_PALPATINE" then
		if self.ChoiceMade == false then
			Story_Event("REPUBLIC_FUTURE_PALPATINE")
			UnitUtil.SetLockList("EMPIRE", {"REPUBLIC_FUTURE_SUPPORT_PALPATINE", "REPUBLIC_FUTURE_SUPPORT_MOTHMA"}, false)
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_REDUCED_MILITARY_EXPANSES_BILL" then
		if self.ChoiceMade == false then
			Story_Event("MILITARY_ENHANCEMENT_MOTHMA")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_REDUCED_MILITARY_EXPANSES_BILL", "SUPPORT_MILITARY_ENHANCEMENT_BILL"}, false)
			self:GC_Reduced_Military_Expanses_Bill_Support()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_MILITARY_ENHANCEMENT_BILL" then
		if self.ChoiceMade == false then
			Story_Event("MILITARY_ENHANCEMENT_PESTAGE")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_REDUCED_MILITARY_EXPANSES_BILL", "SUPPORT_MILITARY_ENHANCEMENT_BILL"}, false)
			self:GC_Military_Enhancement_Bill()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_ENHANCED_SECURITY_ACT" then
		if self.ChoiceMade == false then
			Story_Event("ENHANCED_SECURITY_ACT_TARKIN")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_ENHANCED_SECURITY_ACT", "SUPPORT_ENHANCED_SECURITY_ACT_NOT"}, false)
			self:GC_Enhanced_Security_Act_Support()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_ENHANCED_SECURITY_ACT_NOT" then
		if self.ChoiceMade == false then
			Story_Event("ENHANCED_SECURITY_ACT_MOTHMA")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_ENHANCED_SECURITY_ACT", "SUPPORT_ENHANCED_SECURITY_ACT_NOT"}, false)
			self:GC_Enhanced_Security_Act_Prevent()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_KUAT_POWER_STRUGGLE_ONARA" then
		if self.ChoiceMade == false then
			Story_Event("KUAT_POWER_STRUGGLE_ONARA")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_KUAT_POWER_STRUGGLE_ONARA", "SUPPORT_KUAT_POWER_STRUGGLE_GIDDEAN"}, false)
			self:GC_Kuat_Support_Onara()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_KUAT_POWER_STRUGGLE_GIDDEAN" then
		if self.ChoiceMade == false then
			Story_Event("KUAT_POWER_STRUGGLE_GIDDEAN")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_KUAT_POWER_STRUGGLE_ONARA", "SUPPORT_KUAT_POWER_STRUGGLE_GIDDEAN"}, false)
			self:GC_Kuat_Support_Giddean()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_EXPANDED_SENATE_CONTROL_BILL" then
		if self.ChoiceMade == false then
			Story_Event("SECTOR_GOVERNANCE_MOTHMA")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_EXPANDED_SENATE_CONTROL_BILL", "SUPPORT_SECTOR_GOVERNANCE_DECREE"}, false)
			self:GC_Expanded_Senate_Control_Bill()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "SUPPORT_SECTOR_GOVERNANCE_DECREE" then
		if self.ChoiceMade == false then
			Story_Event("SECTOR_GOVERNANCE_PESTAGE")
			UnitUtil.SetLockList("EMPIRE", {"SUPPORT_EXPANDED_SENATE_CONTROL_BILL", "SUPPORT_SECTOR_GOVERNANCE_DECREE"}, false)
			self:GC_Sector_Governance_Decree()
			self.ChoiceMade = true
		end

	elseif game_object_type_name == "DUMMY_RESEARCH_VENATOR" then
		self.War_Mobilization = true

		if self.CurrentMilitarizationTag == "PRE_CLONE_WAR" then
			self.CurrentMilitarizationTag = "WAR_MOBILIZATION"
			crossplot:publish("UPDATE_MOBILIZATION", "empty")
		end

	elseif game_object_type_name == "DUMMY_KDY_CONTRACT" then
		Story_Event("REPUBLIC_KDY_CONTRACTED")
		self.CurrentMilitarizationTag = "IMPERIALIZATION"
		crossplot:publish("UPDATE_MOBILIZATION", "empty")

	elseif game_object_type_name == "DUMMY_RESEARCH_CLONE_TROOPER_II" then
		if self.gc_name == "RIMWARD" then
			UnitUtil.DespawnList({"DUMMY_RESEARCH_CLONE_TROOPER_II"})

			UnitUtil.SetLockList("EMPIRE", {"CLONETROOPER_PHASE_ONE_TEAM", "REPUBLIC_74Z_BIKE_COMPANY", "ARC_PHASE_ONE_TEAM"}, false)
			UnitUtil.SetLockList("EMPIRE", {"CLONETROOPER_PHASE_TWO_TEAM", "REPUBLIC_BARC_COMPANY", "ARC_PHASE_TWO_TEAM"})
			crossplot:publish("CLONE_UPGRADES", "empty")
			GlobalValue.Set("CURRENT_CLONE_PHASE", 2)
		end
	end
end


function GovernmentRepublic:ChoiceChecker()
	--Logger:trace("entering GovernmentRepublic:ChoiceChecker")
	if self.gc_name == "PROGRESSIVE" or self.gc_name == "FTGU" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		else
		   self:GC_AI_Republic_Future()
		end
	end
	if self.gc_name == "MALEVOLENCE" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		end
	   self:GC_Special_Taskforce_Funding()
	end
	if self.gc_name == "RIMWARD" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		else
		   self:GC_Reduced_Military_Expanses_Bill_Support()
		end
	end
	if self.gc_name == "TENNUUTTA" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		end
		self:GC_Blissex_Research_Funding()
	end
	if self.gc_name == "KNIGHT_HAMMER" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		else
		   self:GC_Enhanced_Security_Act_Support()
		end
	end
	if self.gc_name == "DURGES_LANCE" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		else
		   self:GC_Kuat_Support_Giddean()
		end
	end
	if self.gc_name == "FOEROST" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		end
		self:GC_Core_Worlds_Security_Act()
	end
	if self.gc_name == "OUTER_RIM_SIEGES" then
		if self.RepublicPlayer.Is_Human() then
		   Story_Event(GCEventTable[self.gc_name].EventName)
		else
		   self:GC_Sector_Governance_Decree()
		end
	end
end


function GovernmentRepublic:GC_AI_Republic_Future()
	--Logger:trace("entering GovernmentRepublic:GC_AI_Republic_Future")
	local enabled = true
	
	if TestValid(FindPlanet("CORUSCANT")) then
		if FindPlanet("CORUSCANT").Get_Owner() ~= self.RepublicPlayer then
			enabled = false
		end
	end

	if enabled == true then
		self.CurrentMilitarizationTag = "IMPERIALIZATION"
		crossplot:publish("UPDATE_MOBILIZATION", "empty")

		UnitUtil.SetLockList("EMPIRE", {"Jedi_Temple", "Republic_Jedi_Squad", "View_Council", "Generic_Venator_OFC"}, false) -- FotR_Enhanced

		UnitUtil.DespawnList({
			"YODA", "YODA2",
			"MACE_WINDU", "MACE_WINDU2", 
			"PLO_KOON",
			"KIT_FISTO", "KIT_FISTO2",
			"KI_ADI_MUNDI", "KI_ADI_MUNDI2",
			"LUMINARA_UNDULI", "LUMINARA_UNDULI2",
			"BARRISS_OFFEE","BARRISS_OFFEE2",
			"AHSOKA","AHSOKA2",
			"AAYLA_SECURA","AAYLA_SECURA2",
			"SHAAK_TI","SHAAK_TI2",
			"RAHM_KOTA",
			"NEJAA_HALCYON",
			"KNOL_VENNARI",
			"OPPO_RANCISIS",
			"OBI_WAN", "OBI_WAN2",
			"JEDI_TEMPLE",
			"REPUBLIC_JEDI_KNIGHT",
			"KOTAS_MILITIA_TROOPER", "KOTAS_MILITIA_TROOPER_GUNNER_HEAVY", "KOTAS_MILITIA_TROOPER_GRENADIER", "KOTAS_MILITIA_TROOPER_HAT", "KOTAS_MILITIA_TROOPER_SERGEANT_SPAWNER",
			"ANTARIAN_RANGER_RIFLE", "ANTARIAN_RANGER_RIFLE_GRENADIER", "ANTARIAN_RANGER_RIFLE_CAPTAIN_SPAWNER",
		})
		-- FotR_Enhanced
		local Non_OFC_Units = {
			"Generic_Venator",
			"Generic_Acclamator_Assault_Ship_I",
			"Charger_C70",
		}

        for _, Non_OFC_Unit in pairs(Non_OFC_Units) do --Loop each unit in Non_OFC_Units
			local OFC_Unit = Non_OFC_Unit.."_OFC" --Assign suffix name to unit
			if TestValid(Find_First_Object(OFC_Unit)) then --Check OFC object exists
				local Unit_Object_List = Find_All_Objects_Of_Type(OFC_Unit) --Get all objects of OFC unit
				if table.getn(Unit_Object_List) ~= 0 then --Check if list is not empty
					for _, despawn_target in pairs(Unit_Object_List) do --Loop through list
						UnitUtil.ReplaceAtLocation(despawn_target, Non_OFC_Unit) --Replace OFC unit with non OFC
					end
				end
			end
		end
		
		local SPHA_T_Ven = "Generic_Venator_SPHA_T" --Same process as above
		if TestValid(Find_First_Object(SPHA_T_Ven)) then
			local SPHA_T_List = Find_All_Objects_Of_Type(SPHA_T_Ven)
			if table.getn(SPHA_T_List) ~= 0 then
				for _, despawn_target in pairs(SPHA_T_List) do
					UnitUtil.ReplaceAtLocation(despawn_target, "Generic_Venator")
				end
			end
		end
		GlobalValue.Set("SHIPS_DECOLORED", 1)
		-- FotR_Enhanced
		UnitUtil.SetLockList("EMPIRE", { --[[FotR_Enhanced]] "Yularen_Resolute_66_Upgrade_Invincible", "Yularen_Integrity_66_Upgrade_Invincible", "Tarkin_Executrix_Upgrade",}) 

		UnitUtil.ReplaceAtLocation("Anakin", "Vader_Team")
		UnitUtil.ReplaceAtLocation("Anakin2", "Vader_Team")

		StoryUtil.SpawnAtSafePlanet("CORUSCANT", Find_Player("Empire"), StoryUtil.GetSafePlanetTable(), {"Emperor_Palpatine_Team","Mulleen_Imperator","Rohn_Team"})
		crossplot:publish("ORDER_66_EXECUTED", "empty")
	else
		UnitUtil.DespawnList({"Sate_Pestage"})	
		local Mothma_Spawns = {"Mon_Mothma_Team", "Garm_Team", "Bail_Team", "Raymus_Tantive"}
		StoryUtil.SpawnAtSafePlanet("CORUSCANT", self.RepublicPlayer, self.Active_Planets, Mothma_Spawns)  
		
		UnitUtil.SetLockList("EMPIRE", {"Tallon_Battalion_Upgrade", "Neutron_Star"})
		-- FotR_Enhanced
		crossplot:publish("ORDER_65_EXECUTED", "empty")
		--	
	end
end

function GovernmentRepublic:GC_Special_Taskforce_Funding()
	--Logger:trace("entering GovernmentRepublic:GC_Special_Taskforce_Funding")
	crossplot:publish("SPECIAL_TASK_FORCE_FUNDED", "empty")
	crossplot:publish("REPUBLIC_ADMIRAL_RETURN", {"Tenant"}, 1)
	crossplot:publish("REPUBLIC_ADMIRAL_RETURN", {"Luminara"}, 3)
	crossplot:publish("REPUBLIC_ADMIRAL_RETURN", {"Gree_Clone"}, 4)

	StoryUtil.SpawnAtSafePlanet("KALIIDA_NEBULA", self.RepublicPlayer, self.Active_Planets, {"Luminara_Unduli_Delta_Team", "Gree_Team", "Tenant_Venator"})
end

function GovernmentRepublic:GC_Reduced_Military_Spending_Bill()
	--Logger:trace("entering GovernmentRepublic:GC_Reduced_Military_Spending_Bill")

	StoryUtil.SpawnAtSafePlanet("CORUSCANT", self.RepublicPlayer, self.Active_Planets, {"Giddean_Team"})
	UnitUtil.SetLockList("EMPIRE", {"Tallon_Battalion_Upgrade", "Neutron_Star"})
end

function GovernmentRepublic:GC_Blissex_Research_Funding()
	--Logger:trace("entering GovernmentRepublic:GC_Blissex_Research_Funding")
	StoryUtil.SpawnAtSafePlanet("HANDOOINE", self.RepublicPlayer, self.Active_Planets, {"Mulleen_Imperator"})
end

function GovernmentRepublic:GC_Reduced_Military_Expanses_Bill_Support()
	--Logger:trace("entering GovernmentRepublic:GC_Reduced_Military_Expanses_Bill_Support")
	StoryUtil.SpawnAtSafePlanet("BOTHAWUI", self.RepublicPlayer, self.Active_Planets, {"Bail_Team","Raymus_Tantive"})
	UnitUtil.SetLockList("EMPIRE", {"Neutron_Star","Tallon_Battalion_Upgrade"})
end

function GovernmentRepublic:GC_Military_Enhancement_Bill()
	--Logger:trace("entering GovernmentRepublic:GC_Military_Enhancement_Bill")
	UnitUtil.SetLockList("EMPIRE", {"DUMMY_RESEARCH_CLONE_TROOPER_II"})
end

function GovernmentRepublic:GC_Enhanced_Security_Act_Support()
	--Logger:trace("entering GovernmentRepublic:GC_Enhanced_Security_Act_Support")

	crossplot:publish("ENHANCED_SECURITY_ACT_SUPPORTED", "empty")
end

function GovernmentRepublic:GC_Enhanced_Security_Act_Prevent()
	--Logger:trace("entering GovernmentRepublic:GC_Enhanced_Security_Act_Support")

	crossplot:publish("ENHANCED_SECURITY_ACT_PREVENTED", "empty")
end

function GovernmentRepublic:GC_Kuat_Support_Onara()
	--Logger:trace("entering GovernmentRepublic:GC_Kuat_Support_Onara")

	UnitUtil.SetLockList("EMPIRE", {"Onara_Kuat_Mandator_Upgrade"})
	StoryUtil.SpawnAtSafePlanet("KUAT", self.RepublicPlayer, self.Active_Planets, {"Ottegru_Grey_Team"})
end

function GovernmentRepublic:GC_Kuat_Support_Giddean()
	--Logger:trace("entering GovernmentRepublic:GC_Kuat_Support_Giddean")

	UnitUtil.DespawnList({"ONARA_KUAT"})
	StoryUtil.SpawnAtSafePlanet("BYSS", self.RepublicPlayer, self.Active_Planets, {"Giddean_Team", "Kuat_of_Kuat_Procurator"})
	UnitUtil.SetLockList("EMPIRE", {"Lancer_Frigate"})
end

function GovernmentRepublic:GC_Core_Worlds_Security_Act()
	--Logger:trace("entering GovernmentRepublic:GC_Core_Worlds_Security_Act")

	crossplot:publish("SECTOR_GOVERNANCE_DECREE_SUPPORTED", "empty")
end

function GovernmentRepublic:GC_Expanded_Senate_Control_Bill()
	--Logger:trace("entering GovernmentRepublic:GC_Expanded_Senate_Control_Bill")

	StoryUtil.SpawnAtSafePlanet("CORUSCANT", self.RepublicPlayer, self.Active_Planets, {"Giddean_Team"})
	UnitUtil.SetLockList("EMPIRE", {"Tallon_Battalion_Upgrade", "Neutron_Star"})
end

function GovernmentRepublic:GC_Sector_Governance_Decree()
	--Logger:trace("entering GovernmentRepublic:GC_Sector_Governance_Decree")

	crossplot:publish("SECTOR_GOVERNANCE_DECREE_SUPPORTED", "empty")
end


function GovernmentRepublic:Option_Cycle_Clone_Colour()
	--Logger:trace("entering GovernmentRepublic:Option_Cycle_Clone_Colour")

	UnitUtil.DespawnList({"OPTION_CYCLE_CLONES"})
	local clone_skin = GlobalValue.Get("CLONE_DEFAULT")
	clone_skin = clone_skin + 1
	if clone_skin > 8 then
		clone_skin = 1
	end
	GlobalValue.Set("CLONE_DEFAULT", clone_skin)
	StoryUtil.ShowScreenText(self.CloneSkins[clone_skin], 5)
end

function GovernmentRepublic:UpdateDisplay(favour_table, market_name, market_list)
	--Logger:trace("entering GovernmentRepublic:UpdateDisplay")
	local plot = Get_Story_Plot("Conquests\\Player_Agnostic_Plot.xml")
	local government_display_event = plot.Get_Event("Government_Display")

	if self.RepublicPlayer.Is_Human() then
		government_display_event.Clear_Dialog_Text()

		government_display_event.Set_Reward_Parameter(1, "EMPIRE")

		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_APPROVAL", favour_table.favour)
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CURRENT_CHANCELLOR", Find_Object_Type(GlobalValue.Get("ChiefOfState")))
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_NONE")

		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_KDY_OVERVIEW_HEADER")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_KDY_OVERVIEW")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_NONE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_KDY_LIST_01")
		for i, ship in ipairs(SortKeysByElement(market_list,"order","asc")) do
			local ship_data = market_list[ship]
			if ship_data.locked == false and ship_data.gc_locked == false then
				government_display_event.Add_Dialog_Text(ship_data.readable_name .. ": "..tostring(ship_data.amount) .." - [ ".. tostring(ship_data.chance/10) .."%% ] ")
			end
		end
		
		government_display_event.Add_Dialog_Text("TEXT_NONE")
		government_display_event.Add_Dialog_Text("Currently Unavailable:")
		for i, ship in ipairs(SortKeysByElement(market_list,"order","asc")) do
			local ship_data = market_list[ship]
			if ship_data.locked == true and ship_data.gc_locked == false then
				government_display_event.Add_Dialog_Text(ship_data.readable_name .." - "..ship_data.text_requirement)
			end
		end

		government_display_event.Add_Dialog_Text("TEXT_NONE")

		local admiral_list = GlobalValue.Get("REP_MOFF_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_MOFF_LIST")
			
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		local admiral_list = GlobalValue.Get("REP_ADMIRAL_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_ADMIRAL_LIST")
			
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		local admiral_list = GlobalValue.Get("REP_COUNCIL_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_COUNCIL_LIST")
				
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end		
		local admiral_list = GlobalValue.Get("REP_GENERAL_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_GENERAL_LIST")
				
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		local admiral_list = GlobalValue.Get("REP_COMMANDO_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_COMMANDO_LIST")
				
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		local admiral_list = GlobalValue.Get("REP_CLONE_LIST")
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_CLONE_LIST")
			
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		local admiral_list = GlobalValue.Get("REP_SENATOR_LIST")
		--[[
		if admiral_list ~= nil then
			if table.getn(admiral_list) > 0 then
				government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
				government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_SENATOR_LIST")
			
				for index, obj in pairs(admiral_list) do
					government_display_event.Add_Dialog_Text(obj)
				end
			end
		end
		]]

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_NONE")

		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_FUNCTION")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_MOD_HEADER")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BASE1")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BASE2")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BASE3")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BASE4")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BASE5")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_MOD_CONQUEST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_MOD_MISSION")

		government_display_event.Add_Dialog_Text("TEXT_NONE")

		if self.gc_name == "PROGRESSIVE" or self.gc_name == "FTGU" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_MON_MOTHMA_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_DELEGATIONOF2000_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_DELEGATIONOF2000_2")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_DELEGATIONOF2000_3")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_PALPATINE_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ORDER66_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ORDER66_2")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ORDER66_3")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ORDER66_4")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_2")
		
		elseif self.gc_name == "MALEVOLENCE" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_SPECIAL_TASKFORCE_FUNDING_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_SPECIAL_TASKFORCE_FUNDING_1")
		
		elseif self.gc_name == "RIMWARD" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_INCREASED_MILITARY_BILL_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_INCREASED_MILITARY_BILL_1")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_2")
		
		elseif self.gc_name == "TENNUUTTA" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BLISSEX_RESEARCH_FUNDING_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_BLISSEX_RESEARCH_FUNDING_1")
		
		elseif self.gc_name == "KNIGHT_HAMMER" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ENHANCED_SECURITY_ACT_SUPPORT_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ENHANCED_SECURITY_ACT_SUPPORT_1")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ENHANCED_SECURITY_ACT_PREVENT_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_ENHANCED_SECURITY_ACT_PREVENT_1")
		
		elseif self.gc_name == "DURGES_LANCE" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_POWER_STRUGGLE_KUAT_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_POWER_STRUGGLE_KUAT_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_POWER_STRUGGLE_KUAT_2")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_POWER_STRUGGLE_ONARA_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_KUAT_POWER_STRUGGLE_ONARA_1")
		
		elseif self.gc_name == "FOEROST" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CORE_WORLDS_SECURITY_ACT_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CORE_WORLDS_SECURITY_ACT_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CORE_WORLDS_SECURITY_ACT_2")
		
		elseif self.gc_name == "OUTER_RIM_SIEGES" then
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_CHOICE_REWARD_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_SECTOR_GOVERNANCE_DECREE_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_SECTOR_GOVERNANCE_DECREE_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_SECTOR_GOVERNANCE_DECREE_2")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_HEADER")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_1")
			government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_APPROVAL_REDUCED_MILITARY_BILL_2")
		end

		government_display_event.Add_Dialog_Text("TEXT_NONE")


		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_SECTORFORCES_HEADER")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_SECTORFORCES")

		government_display_event.Add_Dialog_Text("TEXT_NONE")

		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_HEADER")
		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_0")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_1")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_2")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_3")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_4")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_5")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_HERO_SYSTEM_6")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_LIST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_HAUSER")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_WESSEL")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_SEERDON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_TARKIN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_WESSEX")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_GRANT")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_VORRU")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_BYLUIR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_TRACHTA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_RAVIK")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_PRAJI")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_MOFF_THERBON")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_LIST")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_NEEDA") -- FotR_Enhanced
		--government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DALLIN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DALLIN_RENDILI") -- FotR_Enhanced
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_MAARISA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_PELLAEON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_TALLON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_BARAKA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_MARTZ")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_GRUMBY")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_YULAREN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_COBURN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DENIMOOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DRON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_FORRAL")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_WIELER")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_KILIAN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DAO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_AUTEM")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_TENANT")
        government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_BLOCK") -- FotR_Enhanced
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_SCREED")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_DODONNA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_ADMIRAL_PARCK")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_LIST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_YODA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_MACE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_PLO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_KIT")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_AAYLA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_MUNDI")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_LUMINARA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_BARRISS")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_AHSOKA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_SHAAK")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_KOTA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_HALCYON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_OPPO")
		--government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COUNCIL_KNOL")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_LIST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_ROM")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_GENTIS")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_GEEN")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_OZZEL")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_ROMODI")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_SOLOMAHAL")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_JAYFON")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_GENERAL_JESRA")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_LIST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_ALPHA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_FORDO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_GREGOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_VOCA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_DELTA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_OMEGA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_ORDO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_COMMANDO_ADEN")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_LIST")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_REX")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_APPO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_CODY")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_BLY")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_DEVISS")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_WOLFFE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_GREE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_BACARA")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_JET")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_NEYO")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_71")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_KELLER")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_FAIE")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_VILL")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_BOW")
		government_display_event.Add_Dialog_Text("TEXT_GOVERNMENT_REPUBLIC_CLONE_GAFFA")

		government_display_event.Add_Dialog_Text("TEXT_DOCUMENTATION_BODY_SEPARATOR")
		government_display_event.Add_Dialog_Text("TEXT_NONE")
		government_display_event.Add_Dialog_Text("TEXT_NONE")
		government_display_event.Add_Dialog_Text("TEXT_NONE")

		Story_Event("GOVERNMENT_DISPLAY")
	end
end

return GovernmentRepublic
