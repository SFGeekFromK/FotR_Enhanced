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
--*       File:              HeroRespawn.lua                                                     *
--*       File Created:      Monday, 24th February 2020 02:19                                      *
--*       Author:            [TR] Jorritkarwehr                                                             *
--*       Last Modified:     Monday, 24th February 2020 02:34                                      *
--*       Modified By:       [TR] Jorritkarwehr                                                             *
--*       Copyright:         Thrawns Revenge Development Team                                      *
--*       License:           This code may not be used without the author's explicit permission    *
--**************************************************************************************************

require("PGSpawnUnits")
require("deepcore/std/class")
require("eawx-util/StoryUtil")
require("PGDebug")
require("SetFighterResearch")

HeroRespawn = class()

function HeroRespawn:new(herokilled_finished_event, human_player)
    self.human_player = human_player
    herokilled_finished_event:attach_listener(self.on_galactic_hero_killed, self)
	self.durge_chance = 105
	self.dooku_died = false
	self.ventress_died = false
end

function HeroRespawn:on_galactic_hero_killed(hero_name, owner)
    --Logger:trace("entering HeroRespawn:on_galactic_hero_killed")
	
	if hero_name == "GRIEVOUS_TEAM_RECUSANT" then
		self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
		Transfer_Fighter_Hero("GRIEVOUS_RECUSANT", "GRIEVOUS_MUNIFICENT")
    elseif hero_name == "GRIEVOUS_TEAM" then
		self:spawn_grievous("Grievous_Team_Munificent","GRIEVOUS_RESPAWN_MUNIFICENT")
		Transfer_Fighter_Hero("INVISIBLE_HAND", "GRIEVOUS_MUNIFICENT")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE" then
		self:spawn_grievous("Grievous_Team","GRIEVOUS_RESPAWN_INVISIBLE_HAND")
		Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE", "INVISIBLE_HAND")
	elseif hero_name == "GRIEVOUS_TEAM_MALEVOLENCE_2" then
		self:spawn_grievous("Grievous_Team_Recusant","GRIEVOUS_RESPAWN_RECUSANT")
		Transfer_Fighter_Hero("GRIEVOUS_MALEVOLENCE_2", "GRIEVOUS_RECUSANT")
	elseif hero_name == "GRIEVOUS_MUNIFICENT_GROUND" then
		GlobalValue.Set("GRIEVOUS_DEAD", true)
	elseif hero_name == "DURGE_TEAM" then
		self:check_durge()
	elseif hero_name == "DOOKU_TEAM" then
		self:check_dooku_doppelganger()
	elseif hero_name == "YULAREN_RESOLUTE" then
		self:spawn_yularen("Yularen_Integrity")
	elseif hero_name == "YULAREN_INVINCIBLE" then
		self:spawn_yularen("Yularen_Integrity_66")
	elseif hero_name == "TRENCH_INVINCIBLE" then
		self:start_cyber_trench_countdown()
	elseif hero_name == "TRENCH_INVINCIBLE" then
		self:start_cyber_trench_countdown()
	elseif hero_name == "ZOZRIDOR_SLAYKE_CARRACK" then
		self:slaykes_second_chance()
	-- FotR_Enhanced
	--elseif hero_name == "VENTRESS_TEAM" then
	--	self:check_ventress_recover()
	elseif hero_name == "BLOCK_NEGOTIATOR" then
		self:spawn_block("BLOCK_VIGILANCE")
	elseif hero_name == "YULAREN_RESOLUTE_SPHAT" then
		self:spawn_yularen("Yularen_Integrity")
	elseif hero_name == "YULAREN_RESOLUTE_66" then
		self:spawn_yularen("Yularen_Integrity_66")
	end
end

function HeroRespawn:spawn_grievous(team, event)
	--Logger:trace("entering HeroRespawn:spawn_grievous")

	local p_CIS = Find_Player("Rebel")
	local planet
	local capital = Find_First_Object("NewRep_Senate")
	if TestValid(capital) then
		planet = capital.Get_Planet_Location()
	end
	if not TestValid(planet) then
		planet = StoryUtil.FindFriendlyPlanet(p_CIS)
	end
	if not StoryUtil.CheckFriendlyPlanet(planet,p_CIS) then
		planet = StoryUtil.FindFriendlyPlanet(p_CIS)
	end
	if planet then
		SpawnList({team}, planet, p_CIS, true, false)
		Story_Event(event)
	end
end

function HeroRespawn:spawn_yularen(team)
	--Logger:trace("entering HeroRespawn:spawn_yularen")

	local p_republic = Find_Player("Empire")
	local planet
	local capital = Find_First_Object("Remnant_Capital")
	if TestValid(capital) then
		planet = capital.Get_Planet_Location()
	end
	if not TestValid(planet) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if not StoryUtil.CheckFriendlyPlanet(planet,p_republic) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if planet then
		SpawnList({team}, planet, p_republic, true, false)
		if Find_Player("Empire").Is_Human() then
			StoryUtil.Multimedia("TEXT_SPEECH_YULAREN_RETURNS_INTEGRITY", 15, nil, "Piett_Loop", 0)
		end
	end
end

function HeroRespawn:check_durge()
	--Logger:trace("entering HeroRespawn:check_durge")

	local check = GameRandom(1, 100)
	if self.durge_chance >= check then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		if planet then
			SpawnList({"Durge_Team"}, planet, p_CIS, true, false)
			StoryUtil.Multimedia("TEXT_SPEECH_DURGE_RETURNS", 20, nil, "Durge_Loop", 0)
			self.durge_chance = self.durge_chance - 10
			StoryUtil.ShowScreenText("Revive chance: " .. tostring(self.durge_chance), 5)
		else
			StoryUtil.Multimedia("TEXT_SPEECH_DURGE_GONE", 20, nil, "Durge_Loop", 0)
		end
	else
		StoryUtil.Multimedia("TEXT_SPEECH_DURGE_GONE", 20, nil, "Durge_Loop", 0)
	end
end

function HeroRespawn:check_dooku_doppelganger()
	--Logger:trace("entering HeroRespawn:check_dooku_doppelganger")
	if self.dooku_died == false then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		StoryUtil.SpawnAtSafePlanet("SERENNO", p_CIS, StoryUtil.GetSafePlanetTable(), {"Dooku_Team"})
		StoryUtil.Multimedia("TEXT_SPEECH_DOOKU_DOPPELGANGER_SPAWN", 15, nil, "Dooku_Loop", 0)
		self.dooku_died = true
	end
end

function HeroRespawn:slaykes_second_chance()
	--Logger:trace("entering HeroRespawn:slaykes_second_chance")
	local p_republic = Find_Player("Empire")
	local planet = StoryUtil.FindFriendlyPlanet(p_republic)
	StoryUtil.SpawnAtSafePlanet("ERIADU", p_republic, StoryUtil.GetSafePlanetTable(), {"Zozridor_Slayke_CR90"})
end

function HeroRespawn:start_cyber_trench_countdown()
	--Logger:trace("entering HeroRespawn:start_cyber_trench_countdown")
	
	Story_Event("TRENCH_COUNTDOWN_BEGINS")
end

-- FotR_Enhanced
function HeroRespawn:spawn_block(team)
	--Logger:trace("entering HeroRespawn:spawn_block")

	local p_republic = Find_Player("Empire")
	local planet
	local capital = Find_First_Object("Remnant_Capital")
	if TestValid(capital) then
		planet = capital.Get_Planet_Location()
	end
	if not TestValid(planet) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if not StoryUtil.CheckFriendlyPlanet(planet,p_republic) then
		planet = StoryUtil.FindFriendlyPlanet(p_republic)
	end
	if planet then
		SpawnList({team}, planet, p_republic, true, false)
		if Find_Player("Empire").Is_Human() then
			StoryUtil.Multimedia("TEXT_SPEECH_BLOCK_RETURNS_VIGILANCE", 15, nil, "Piett_Loop", 0)
		end
	end
end


--[[
function HeroRespawn:check_ventress_recover()
	--Logger:trace("entering HeroRespawn:check_ventress_recover")
	if self.ventress_died == false then
		local p_CIS = Find_Player("Rebel")
		local planet = StoryUtil.FindFriendlyPlanet(p_CIS)
		StoryUtil.SpawnAtSafePlanet("BOZ_PITY", p_CIS, StoryUtil.GetSafePlanetTable(), {"Ventress_Team"})
		StoryUtil.Multimedia("TEXT_SPEECH_VENGEFUL_RECOVER_SPAWN", 15, nil, "Dooku_Loop", 0)
		self.ventress_died = true
	end
end
]]