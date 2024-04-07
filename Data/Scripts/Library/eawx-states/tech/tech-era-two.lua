require("eawx-util/UnitUtil")
require("PGStoryMode")
require("PGSpawnUnits")

return {
    on_enter = function(self, state_context)

		
        self.VenatorEvents = false
        
		self.entry_time = GetCurrentTime()

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
                "Republic_ISP_Company",
                "Republic_Flashblind_Group",
                "Generic_Acclamator_Assault_Ship_II",
                "Republic_HAET_Group",
                "Republic_AT_AP_Walker_Company",
                "Republic_AT_OT_Walker_Company",
				"Republic_Gian_Company"
            }, false)
			
			UnitUtil.SetLockList("EMPIRE", {

            })
           
            UnitUtil.SetLockList("REBEL", {
                "Auxiliary_Lucrehulk",
                "Battleship_Lucrehulk",
                "HMP_Group",
                "Destroyer_Droid_II_Company",
            }, false)
			
	        UnitUtil.SetLockList("REBEL", {

            })

            UnitUtil.SetLockList("BANKING_CLAN", {
                "HMP_Group",
                "Destroyer_Droid_II_Company"
            }, false)

			UnitUtil.SetLockList("TRADE_FEDERATION", {
                "HMP_Group",
                "Destroyer_Droid_II_Company"
            }, false)

			UnitUtil.SetLockList("COMMERCE_GUILD", {
                "HMP_Group",
                "Destroyer_Droid_II_Company"
            }, false)

			UnitUtil.SetLockList("TECHNO_UNION", {
                "HMP_Group",
                "Destroyer_Droid_II_Company"
            }, false)
			
            UnitUtil.SetLockList("HUTT_CARTELS", {

            }, false)			
			
			 UnitUtil.SetLockList("HUTT_CARTELS", {
				"Consular_Refit"
            })			
			
        end


    end,
    on_update = function(self, state_context)   
    end,
    on_exit = function(self, state_context)
    end
}