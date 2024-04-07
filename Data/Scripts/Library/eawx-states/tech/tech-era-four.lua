require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")

return {
    on_enter = function(self, state_context)
       
        self.entry_time = GetCurrentTime()

        self.BattleshipEvents = false

        if self.entry_time <= 5 then

            UnitUtil.SetLockList("EMPIRE", {
                "Dreadnaught_Lasers",
                "Dreadnaught_Carrier",
                "Galleon",
                "Citadel_Cruiser_Squadron",
                "Republic_A4_Juggernaut_Company",
                "Republic_Navy_Trooper_Squad",
                "Republic_Trooper_Team",
                "Special_Tactics_Trooper_Squad",				
				"Republic_ULAV_Company",
                "Invincible_Cruiser",
                "Republic_Gaba18_Group",
                "Republic_AT_XT_Company",
				"Republic_Gian_Company"
            }, false)
           
            UnitUtil.SetLockList("REBEL", {
                "Auxiliary_Lucrehulk",
                "CIS_GAT_Group",
            }, false)
			
	        UnitUtil.SetLockList("REBEL", {
				"Pursuer_Enforcement_Ship_Squadron",
				"Battleship_Lucrehulk",
            })

			UnitUtil.SetLockList("BANKING_CLAN", {
				"GAT_Group"
            }, false)
			

			UnitUtil.SetLockList("TRADE_FEDERATION", {
				"GAT_Group"
            }, false)
	

			UnitUtil.SetLockList("COMMERCE_GUILD", {
				"GAT_Group"
            }, false)
			

			UnitUtil.SetLockList("TECHNO_UNION", {
				"GAT_Group"
            }, false)
			
            UnitUtil.SetLockList("HUTT_CARTELS", {

            }, false)			
			
			 UnitUtil.SetLockList("HUTT_CARTELS", {
				"Consular_Refit"
            })			
			
			
        else
            
        end

    end,
    on_update = function(self, state_context)  
    end,
    on_exit = function(self, state_context)
    end
}