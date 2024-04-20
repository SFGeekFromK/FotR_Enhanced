function DefineRosterOverride(planet)
	planetTable = {
		BALMORRA = "CLASSIC_TF",
		CATO_NEIMOIDIA = "CLASSIC_TF",
		CORELLIA = "CECORELLIAN",	
		DEKO_NEIMOIDIA = "CLASSIC_TF",
		DRUCKENWELL = "CLASSIC_TF",
		ENARC = "CLASSIC_TF",
		HYPORI = "CLASSIC_TF",
		KORU_NEIMOIDIA = "CLASSIC_TF",
		VULPTER = "CLASSIC_TF",
		MINNTOOINE = "FREE_DAC",
		PAMMANT = "FREE_DAC",
		RENDILI = "STARDRIVE",
		SLUIS_VAN = "STARDRIVE",
		KAMINO = "CLONES",
		ARKANIA = "CLONES",
		BYSS = "CLONES",
		COLUMUS = "CLONES",
		KHOMM = "CLONES",
		WAYLAND = "CLONES",
		ENTRALLA = "KUATI",
		GYNDINE = "KUATI",
		KUAT = "KUATI",
		ROTHANA = "ROTHANAN",
		BEGEREN = "SITHWORLD_REP",
		DROMUND = "SITHWORLD_REP",
		KAR_DELBA = "SITHWORLD_REP",
		KORRIBAN = "SITHWORLD_REP",
		YAVIN = "SITHWORLD_REP",
		ZIOST = "SITHWORLD_REP",
		JABIIM = "NIMBUS",
	}
	
	return planetTable[planet]
end

function DefineUnitTable(faction, rosterOverride)
	if faction == "TECHNO_UNION" or faction == "COMMERCE_GUILD" or faction == "BANKING_CLAN" or faction == "TRADE_FEDERATION" then
		faction = "REBEL"
	end
	
	if faction == "EMPIRE" and (rosterOverride == "CLASSIC_TF" or rosterOverride == "FREE_DAC" or rosterOverride == "NIMBUS") then
		rosterOverride = nil
	end
	
	if (faction == "REBEL" or GlobalValue.Get("CURRENT_ERA") <= 1) and rosterOverride == "CLONES" then
		rosterOverride = nil
	end
	
	if faction == "REBEL" and rosterOverride == "STARDRIVE" then
		rosterOverride = "STARDRIVE_CIS"
	end
	
	if faction == "REBEL" and rosterOverride == "KUATI" then
		rosterOverride = "KUATI_CIS"
	end	
	
	if faction == "REBEL" and rosterOverride == "ROTHANAN" then
		rosterOverride = "KUATI_CIS"
	end	

	if faction == "REBEL" and rosterOverride == "SITHWORLD_REP" then
		rosterOverride = "SITHWORLD_CIS"
	end	
	
	local government = GameRandom.Free_Random(1, 8)
	local IF_Gov
	if government == 8 then
		IF_Gov = "Revolt_Scavenger_Base"
	elseif government == 7 then
		IF_Gov = "Revolt_Security_HQ"	
	elseif government == 6 then
		IF_Gov = "Revolt_Corporate_HQ"
	elseif government == 5 then
		IF_Gov = "Revolt_Local_HQ_Urban"
	elseif government == 4 then
		IF_Gov = "Revolt_Local_HQ_Rural"
	elseif government == 3 then
		IF_Gov = "Revolt_PDF_HQ_Urban"
	elseif government == 2 then
		IF_Gov = "Revolt_PDF_HQ_Rural"
	else		
		IF_Gov = "Revolt_PDF_HQ"
	end
	
	local Faction_Table = {
		EMPIRE = {
			Space_Unit_Table = {
				{"Invincible_Cruiser", 1, LastYear = -21}
				,{"Generic_Venator", 1, StartYear = -21}
				,{"Generic_Victory_Destroyer", 1, StartYear = -20}
				,{"Dreadnaught", 4}
				,{"Dreadnaught_Lasers", 4}			
				,{"Carrack_Cruiser_Lasers", 5}
				,{"Generic_Acclamator_Assault_Ship_I", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_Leveler", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_II", 4, StartYear = -19}				
				,{"Class_C_Frigate", 3, LastYear = -21}
				,{"Arquitens", 3, StartYear = -21}
				,{"Pelta_Assault", 3, StartYear = -22}
				,{"Pelta_Support", 3, StartYear = -22}
				,{"LAC", 3}
				,{"Consular_Refit", 3, LastYear = -22}
				,{"Charger_C70", 3, StartYear = -22}				
				,{"Corellian_Corvette", 5}
				,{"Corellian_Gunboat", 5}			
			},
			Land_Unit_Table = {
				{"Republic_Trooper_Team", 5}
				,{"Republic_Navy_Trooper_Squad", 3}
				,{"Special_Tactics_Trooper_Squad", 3}			
				,{"Clonetrooper_Phase_One_Team", 5, LastYear = -21}
				,{"Clonetrooper_Phase_Two_Team", 5, StartYear = -20}
				,{"Clone_Galactic_Marine_Platoon", 1}
				,{"Republic_SD_6_Droid_Company", 1}
				,{"Ailon_Nova_Guard_Squad", 0.5}				
				,{"Republic_AT_PT_Company", 2}
				,{"Republic_AT_RT_Company", 2, StartYear = -22}
				,{"Republic_AT_XT_Company", 2, StartYear = -22, LastYear = -22}
				,{"Republic_Overracer_Speeder_Bike_Company", 2, LastYear = -23}				
				,{"Republic_74Z_Bike_Company", 2, StartYear = -22, LastYear = -21}
				,{"Republic_BARC_Company", 2, StartYear = -20}
				,{"Republic_Republic_ISP_Company", 2, StartYear = -20}				
				,{"Republic_TX130_Company", 2, StartYear = -22}
				,{"Republic_AV7_Company", 2, StartYear = -22}
				,{"Republic_UT_AA_Company", 1, StartYear = -22}			
				,{"Republic_LAAT_Group", 1, StartYear = -22}
				,{"Republic_VAAT_Group", 0.5, LastYear = -21}
				,{"Republic_Gaba18_Group", 1}
				,{"Republic_Flashblind_Group", 0.5, StartYear = -20, LastYear = -20}
				,{"Republic_HAET_Group", 0.5, StartYear = -19}
				,{"Republic_AT_OT_Walker_Company", 0.5, StartYear = -19}
				,{"Republic_AT_AP_Walker_Company", 1, StartYear = -19}
				,{"Republic_A5RX_Company", 0.2, StartYear = -22}							
				,{"Republic_A5_Juggernaut_Company", 1, StartYear = -22}
				,{"Republic_UT_AT_Speeder_Company", 1, StartYear = -21}
				,{"Republic_AT_TE_Walker_Company", 1, StartYear = -22}
				,{"Republic_Gian_Company", 1, LastYear = -21}
				,{"SPHA_T_Company", 1.5, StartYear = -22, LastYear = -22}
			},
			Groundbase_Table = {
				"E_Ground_Barracks",
				"E_Ground_Barracks",
				"E_Ground_Light_Vehicle_Factory",					
				"E_Ground_Heavy_Vehicle_Factory",
				"E_Ground_Advanced_Vehicle_Factory",					
			},
			Starbase_Table = {
                "Empire_Star_Base_1",
                "Empire_Star_Base_2",					
                "Empire_Star_Base_3",
				"Empire_Star_Base_4",									
				"Empire_Star_Base_5",									
            },
			Shipyard_Table = {
                "Republic_Shipyard_Level_One",
                "Republic_Shipyard_Level_Two",					
                "Republic_Shipyard_Level_Three",
				"Republic_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
				"Secondary_Haven",				
                "Secondary_Golan_One",
                "Secondary_Golan_Two"								
            },
			Government_Building = "Empire_MoffPalace",
			GTS_Building = "Ground_Hypervelocity_Gun"
		},
		REBEL = {
			Space_Unit_Table = {
				{"Generic_Providence", 3, StartYear = -22}
				,{"Lucrehulk_Core_Destroyer", 1, StartYear = -22}
				,{"Bulwark_I", 1, StartYear = -20}
				,{"Captor", 4}
				,{"Auxilia", 4}
				,{"Recusant", 4, StartYear = -22}
				,{"C9979_Carrier", 5}
				,{"Hardcell", 5}
				,{"Hardcell_Tender", 2}
				,{"Munificent", 4}
				,{"Munifex", 5}
				,{"Diamond_Frigate", 5}
				,{"Lupus_Missile_Frigate", 5}
				,{"Geonosian_Cruiser", 1}
				,{"CIS_Dreadnaught_Lasers", 1}			
				,{"Gozanti_Cruiser_Squadron", 5}
				,{"Supply_Ship", 2}
			},
			Land_Unit_Table = {
				{"B1_Droid_Squad", 3}
				,{"B2_Droid_Squad", 3, StartYear = -22}
				,{"Destroyer_Droid_Company", 2}
				,{"Destroyer_Droid_II_Company", 1, StartYear = -19}
				,{"Nimbus_Commando_Company", 0.2, StartYear = -21}
				,{"Neimoidian_Guard_Squad", 0.5}
				,{"Skakoan_Combat_Engineer_Squad", 0.5}				
				,{"Crab_Droid_Company", 2}
				,{"Dwarf_Spider_Droid_Company", 2}			
				,{"STAP_Squad", 2}
				,{"CIS_GAT_Group", 2, LastYear = -22}
				,{"AAT_Company", 1}
				,{"HAG_Company", 1}
				,{"HAML_Company", 1}			
				,{"MTT_Company", 1}
				,{"OG9_Company", 1}
				,{"Magna_Company", 1}
				,{"Persuader_Company", 1}
				,{"Persuader_Assault_Company", 0.25}
				,{"Hailfire_Company", 2}
				,{"J1_Artillery_Corp", 1, StartYear = -22}
				,{"CA_Artillery_Company", 1}
				,{"PAC_Company", 1}			
				,{"MAF_Group", 1}
				,{"HMP_Group", 1, StartYear = -19}
			},
			Groundbase_Table = {
				"R_Ground_Barracks",
				"R_Ground_Barracks",
				"R_Ground_Light_Vehicle_Factory",
				"R_Ground_Heavy_Vehicle_Factory",
            },
			Starbase_Table = {
                "NewRepublic_Star_Base_1",
                "NewRepublic_Star_Base_2",					
                "NewRepublic_Star_Base_3",
				"NewRepublic_Star_Base_4",									
				"NewRepublic_Star_Base_5",
            },
			Shipyard_Table = {
                "CIS_Shipyard_Level_One",
                "CIS_Shipyard_Level_Two",					
                "CIS_Shipyard_Level_Three",
				"CIS_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
				"Secondary_TF_Outpost",
                "Secondary_Golan_One",
                "Secondary_Golan_Two"				
            },
			Government_Building = "NewRep_SenatorsOffice",
			GTS_Building = "Ground_Ion_Cannon"
		},
		SECTOR_FORCES = {
			Space_Unit_Table = {
				{"Invincible_Cruiser", 3}
				,{"Generic_Tagge_Battlecruiser", 0.1}			
				,{"Dreadnaught_Lasers", 4}
				,{"Dreadnaught", 3}
				,{"Dreadnaught_Carrier", 2}				
				,{"Carrack_Cruiser_Lasers", 5}		
				,{"Generic_Acclamator_Assault_Ship_I", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_Leveler", 4, StartYear = -22}
				,{"Generic_Praetor", 0.1}
				,{"Citadel_Cruiser_Squadron", 3}
				,{"Galleon", 3}
				,{"Class_C_Frigate", 3}
				,{"Class_C_Support", 3}
				,{"Starbolt", 3}
				,{"CEC_Light_Cruiser", 3}				
				,{"Corellian_Corvette", 5}
				,{"Corellian_Gunboat", 5}
				,{"LAC", 3}
				,{"Consular_Refit", 3}				
				,{"Customs_Corvette", 5}
				,{"IPV1_System_Patrol_Craft", 5}	
			},
			Land_Unit_Table = {
				{"Republic_Trooper_Team", 5}
				,{"Republic_Navy_Trooper_Squad", 3}		
				,{"Special_Tactics_Trooper_Squad", 3}			
				,{"Republic_AT_PT_Company", 2}
				,{"Republic_Overracer_Speeder_Bike_Company", 2}
				,{"Republic_ULAV_Company", 2, StartYear = -22}
				,{"Republic_VAAT_Group", 1}
				,{"Republic_Gaba18_Group", 1}	
				,{"Republic_A5RX_Company", 0.2, StartYear = -22}				
				,{"Republic_A5_Juggernaut_Company", 1, StartYear = -22}
				,{"Republic_A4_Juggernaut_Company", 1}
				,{"Republic_Gian_Company", 1}
			},
			Groundbase_Table = {
                "SF_Ground_Barracks",
                "SF_Ground_Barracks",
                "SF_Ground_Light_Vehicle_Factory",
                "SF_Ground_Advanced_Vehicle_Factory",
            },
			Starbase_Table = {
                "Empire_Star_Base_1",
                "Empire_Star_Base_2",					
                "Empire_Star_Base_3",
				"Empire_Star_Base_4",									
				"Empire_Star_Base_5",									
            },
			Shipyard_Table = {
                "SF_Shipyard_Level_One",
                "SF_Shipyard_Level_Two",					
                "SF_Shipyard_Level_Three",
                "SF_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
				"Secondary_Haven",				
                "Secondary_Golan_One",
                "Secondary_Golan_Two"								
            },
			Government_Building = "Empire_MoffPalace",
			GTS_Building = "Ground_Hypervelocity_Gun"
		},
		HUTT_CARTELS = {
			Space_Unit_Table = {
				{"Light_Minstrel_Yacht", 5}
				,{"Heavy_Minstrel_Yacht", 5}
				,{"Raka_Freighter_Tender", 1}
				,{"Kaloth_Battlecruiser", 3}
				,{"Juvard_Frigate", 5}
				,{"Barabbula_Frigate", 5}
				,{"Szajin_Cruiser", 3}
				,{"Karagga_Destroyer", 3}
				,{"Vontor_Destroyer", 3}
				,{"Voracious_Carrier", 1}
				,{"CIS_Dreadnaught_Lasers", 1}
				,{"Dreadnaught", 1}
				,{"Marauder_Cruiser", 0.2}
				,{"Corellian_Gunboat", 0.2}
				,{"Corellian_Corvette", 0.2}
				,{"IPV1_Gunboat", 0.5}
				,{"Consular_Refit", 0.5}				
				,{"Komrk_Gunship_Squadron", 0.2}
				,{"Gozanti_Cruiser_Squadron", 0.2}
				,{"Gozanti_Cruiser_Raider_Squadron", 1}	
			},
			Land_Unit_Table = {
				{"Hutt_Guard_Squad", 5}
				,{"Hutt_Armored_Platoon", 2}		
				,{"Hutt_Airhook_Company", 4}
				,{"Hutt_Starhawk_Company", 4}
				,{"Hutt_Pongeeta_Swamp_Speeder_Company", 2}
				,{"Hutt_Personnel_Skiff_IV_Company", 2}
				,{"Hutt_Bantha_II_Skiff_Company", 4}
				,{"Hutt_SuperHaul_II_Skiff_Company", 1}
				,{"Hutt_AA_Skiff_Company", 1}
				,{"WLO5_Tank_Company", 4}
				,{"Luxury_Yacht_Company", 1}
				,{"Hutt_Atmospheric_Flyer_Group", 2}
				,{"Hutt_VAAT_Group", 2}
				,{"MAL_Rocket_Vehicle_Company", 1}		
				,{"Hutt_Gamorrean_Guard_Squad", 1}		
				,{"Hutt_Minor_Shell_Hutt_Platoon", 1}						
			},
			Groundbase_Table = {
                "H_Ground_Barracks",
                "H_Ground_Barracks",
                "H_Ground_Light_Vehicle_Factory",
                "H_Ground_Heavy_Vehicle_Factory",
			},
			Starbase_Table = {
				"Hutt_Star_Base_1",
                "Hutt_Star_Base_2",					
                "Hutt_Star_Base_3",
				"Hutt_Star_Base_4",									
				"Hutt_Star_Base_5",	
			},
			Shipyard_Table = {
                "Hutt_Shipyard_Level_One",
                "Hutt_Shipyard_Level_Two",					
                "Hutt_Shipyard_Level_Three",
                "Hutt_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
                nil,				
                "Secondary_Golan_One",
                "Secondary_Golan_Two"							
            },
			Government_Building = "Hutt_LocalOffice",
			GTS_Building = "Ground_Ion_Cannon"
		},
		MANDALORIANS = {
			Space_Unit_Table = {
				{"CIS_Dreadnaught_Lasers", 5}
				,{"CIS_Dreadnaught", 2}
				,{"Neutron_Star", 0.5, StartYear = -21}
				,{"Neutron_Star_Mercenary", 0.5, StartYear = -21}
				,{"Pursuer_Enforcement_Ship_Squadron", 5, StartYear = -21}
				,{"Komrk_Gunship_Squadron", 5}
				,{"Gozanti_Cruiser_Squadron", 1}		
			},
			Land_Unit_Table = {
				{"Mandalorian_Soldier_Company", 5}
				,{"Mandalorian_Commando_Company", 3}
				,{"JU9_Juggernaut_Droid_Squad", 2}
				,{"MAL_Rocket_Vehicle_Company", 1}	
			},
			Groundbase_Table = {
                "Revolt_Rural_PDF_Barracks",
                "Revolt_Urban_PDF_Barracks",
                "Revolt_Rural_Barracks",
                "Revolt_Urban_Barracks",
                "Revolt_Light_Merc_Barracks",
                "Revolt_Merc_Barracks",
                "Revolt_Elite_Merc_Barracks",
                "Revolt_Precinct_House",					
            },
			Starbase_Table = {
                "Empire_Star_Base_1",
                "Empire_Star_Base_2",					
                "Empire_Star_Base_3",
				"Empire_Star_Base_4",									
				"Empire_Star_Base_5",	
            },
			Shipyard_Table = {
                "Republic_Shipyard_Level_One",
                "Republic_Shipyard_Level_Two",					
                "Republic_Shipyard_Level_Three",
                "Republic_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
				"Secondary_TF_Outpost",
				"Secondary_Golan_One",
                "Secondary_Golan_Two"		
            },
			Government_Building = IF_Gov,
			GTS_Building = nil
		},		
		INDEPENDENT_FORCES = {
			Space_Unit_Table = {
				{"Home_One_Type_Liner", 0.2}
				,{"Calamari_Cruiser_Liner", 0.5}
				,{"Kuari_Princess_Liner", 0.2}
				,{"Invincible_Cruiser", 1}
				,{"Generic_Procurator", 0.2}			
				,{"Generic_Tagge_Battlecruiser", 0.05}
				,{"Generic_Praetor", 0.2}			
				,{"Space_ARC_Cruiser", 1}
				,{"Auxiliary_Lucrehulk", 0.4}	
				,{"Auxiliary_Lucrehulk_Control", 0.1}				
				,{"Generic_Lucrehulk", 0.2, StartYear = -21}
				,{"Generic_Lucrehulk_Control", 0.05, StartYear = -21}				
				,{"Battleship_Lucrehulk", 0.05, StartYear = -19}
				,{"Sabaoth_Frigate", 0.2}
				,{"Sabaoth_Hex_Deployer", 0.2}
				,{"Sabaoth_Destroyer", 0.2}
				,{"Dreadnaught_Lasers", 4}
				,{"Neutron_Star", 2, StartYear = -21}			
				,{"Neutron_Star_Mercenary", 1, StartYear = -21}
				,{"Captor", 4}
				,{"Auxilia", 4}
				,{"Munifex", 5}
				,{"Generic_Acclamator_Assault_Ship_I", 1, StartYear = -21}
				,{"Generic_Acclamator_Assault_Ship_Leveler", 2, StartYear = -21}
				,{"Generic_Victory_Destroyer", 1, StartYear = -19}				
				,{"Lupus_Missile_Frigate", 5}
				,{"Carrack_Cruiser_Lasers", 5}
				,{"Carrack_Cruiser", 5, StartYear = -20}
				,{"CEC_Light_Cruiser", 4}			
				,{"Galleon", 3}
				,{"Class_C_Frigate", 3}
				,{"Class_C_Support", 3}
				,{"Dreadnaught_Carrier", 1}
				,{"Starbolt", 2}			
				,{"Light_Minstrel_Yacht", 1}
				,{"Heavy_Minstrel_Yacht", 1}			
				,{"Kaloth_Battlecruiser", 2}
				,{"Corellian_Corvette", 4}
				,{"Corellian_Gunboat", 4}
				,{"Customs_Corvette", 5}
				,{"IPV1_System_Patrol_Craft", 5}
				,{"IPV1_Gunboat", 1}			
				,{"Marauder_Cruiser", 5}
				,{"Interceptor_Frigate", 3}
				,{"Action_VI_Support", 3}
				,{"Super_Transport_VI", 2}
				,{"Super_Transport_VII", 2}
				,{"Super_Transport_XI", 1}		
				,{"Super_Transport_XI_Modified", 1}
				,{"Gozanti_Cruiser_Raider_Squadron", 3}			
				,{"Gozanti_Cruiser_Squadron", 4}
				,{"Citadel_Cruiser_Squadron", 3}
			},
			Land_Unit_Table = {
				{"Police_Responder_Team", 2}
				,{"Security_Trooper_Team", 2}
				,{"Military_Soldier_Team", 3}
				,{"PDF_Soldier_Team", 3}
				,{"PDF_Tactical_Unit_Team", 2}
				,{"Light_Mercenary_Team", 3} 
				,{"Mercenary_Team", 3}    
				,{"Elite_Mercenary_Team", 3}  
				,{"Scavenger_Team", 2}
				,{"Heavy_Scavenger_Team", 1}
				,{"PDF_Force_Cultist_Team", 0.1}				
				,{"B1_Droid_Squad", 2}
				,{"JU9_Juggernaut_Droid_Squad", 2}
				,{"SD_5_Hulk_Infantry_Droid_Company", 1}
				,{"X34_Technical_Company", 2}				
				,{"Republic_AT_PT_Company", 2}
				,{"Espo_Walker_Early_Squad", 2}
				,{"Overracer_Speeder_Bike_Company", 2}
				,{"STAP_Squad", 2}
				,{"Republic_SD_6_Droid_Company", 2}
				,{"LR_57_Droid_Company", 1}
				,{"Destroyer_Droid_Company", 2}
				,{"Arrow_23_Company", 2}
				,{"ULAV_Company", 2, StartYear = -22}
				,{"AAT_Company", 1}
				,{"GAT_Group", 2, StartYear = -20}
				,{"Republic_AT_XT_Company", 0.5, StartYear = -20}
				,{"PDF_AAT_Company", 1}
				,{"Riot_Hailfire_Company", 1}
				,{"Riot_Persuader_Company", 1}
				,{"MZ8_Tank_Company", 1}
				,{"TNT_Company", 1}				
				,{"Republic_A5_Juggernaut_Company", 1, StartYear = -22}
				,{"Republic_A5RX_Company", 1, StartYear = -21}				
				,{"Republic_A6_Juggernaut_Company", 0.2, StartYear = -20}				
				,{"Republic_A4_Juggernaut_Company", 2}
				,{"Hutt_Bantha_II_Skiff_Company", 2}		
				,{"WLO5_Tank_Company", 1}			
				,{"Storm_Cloud_Car_Group", 1}
				,{"Skyhopper_Group", 1}
				,{"Skyhopper_Antivehicle_Group", 1}
				,{"Skyhopper_Primitive_Group", 1}
				,{"Skyhopper_Security_Group", 1}
				,{"Republic_Gaba18_Group", 1}
				,{"CA_Artillery_Company", 1}
				,{"MAL_Rocket_Vehicle_Company", 1}			
				,{"VAAT_Group", 1}				
				,{"JX30_Group", 1}	
				,{"Gian_Company", 1}
				,{"Gian_PDF_Company", 1}
				,{"Gian_Rebel_Company", 1, StartYear = -18}
			},
			Groundbase_Table = {
                "Revolt_Rural_PDF_Barracks",
                "Revolt_Urban_PDF_Barracks",
                "Revolt_Rural_Barracks",
                "Revolt_Urban_Barracks",
                "Revolt_Light_Merc_Barracks",
                "Revolt_Merc_Barracks",
                "Revolt_Elite_Merc_Barracks",
                "Revolt_Precinct_House",
                "Revolt_Scavenger_Outpost",
                "Revolt_Underground_Market",				
                "Revolt_Trade_Post",	
                "Revolt_TDF_Deserter_Base",
                "Revolt_Security_Droid_Factory",	
                "Revolt_OldRep_Light_Factory",
                "Revolt_Walker_Light_Factory",	
                "Revolt_UI_Light_Factory",
                "Revolt_AT_Light_Factory",
                "Revolt_Illegal_Heavy_Factory",	
                "Revolt_Chop_Shop",
                "Revolt_OldRep_Advanced_Factory",					
            },
			Starbase_Table = {
                "Empire_Star_Base_1",
                "Empire_Star_Base_2",					
                "Empire_Star_Base_3",
				"Empire_Star_Base_4",									
				"Empire_Star_Base_5",	
            },
			Shipyard_Table = {
                "Republic_Shipyard_Level_One",
                "Republic_Shipyard_Level_Two",					
                "Republic_Shipyard_Level_Three",
                "Republic_Shipyard_Level_Four",																		
            },
			Defenses_Table = {
                nil,
                nil,
				"Secondary_TF_Outpost",
				"Secondary_Golan_One",
                "Secondary_Golan_Two"		
            },
			Government_Building = IF_Gov,
			GTS_Building = nil
		},
		CLASSIC_TF = {
			Space_Unit_Table = {
				{"Lucrehulk_Core_Destroyer", 1, StartYear = -22}
				,{"Captor", 4}
				,{"Auxilia", 4}
				,{"C9979_Carrier_Subfaction", 5}
				,{"Munifex", 5}
				,{"Lupus_Missile_Frigate", 5}
				,{"Supply_Ship", 2}
			},
			Land_Unit_Table = {
				{"Neimoidian_Guard_Squad", 2}
				,{"B1_Droid_Squad", 3}
				,{"B2_Droid_Squad", 3, StartYear = -22}
				,{"Destroyer_Droid_Company", 2}	
				,{"Neimoidian_Guard_Squad", 2}				
				,{"STAP_Squad", 2}
				,{"AAT_Company", 1}
				,{"HAG_Company", 1}
				,{"HAML_Company", 1}			
				,{"MTT_Company", 1}
				,{"PAC_Company", 1}			
				,{"MAF_Group", 1}
			}
		},
		FREE_DAC = {
			Space_Unit_Table = {
				{"Providence_Dreadnought", 1, StartYear = -22}
				,{"Recusant_Dreadnought", 3, StartYear = -22}
				,{"Generic_Providence", 3, StartYear = -22}
				,{"Recusant", 5, StartYear = -22}
				,{"CIS_Dreadnaught", 0.25}
				,{"CIS_Dreadnaught_Lasers", 0.5}				
				,{"Home_One_Type_Liner", 0.2}
				,{"Calamari_Cruiser_Liner", 0.5}
				,{"Kuari_Princess_Liner", 0.2}
				--,{"Subjugator", 0.1} --I shouldn't... it's not the Jedi way...
			},
			Government_Building = "Free_Dac_HQ",
		},
		STARDRIVE = {
			Space_Unit_Table = {
				{"Invincible_Cruiser", 1}
				,{"Dreadnaught", 4}
				,{"Dreadnaught_Lasers", 3}
				,{"Dreadnaught_Carrier", 1}
				,{"Customs_Corvette", 5}
				,{"Neutron_Star", 0.2, StartYear = -21}
				,{"Generic_Victory_Fleet_Destroyer", 1, StartYear = -20}
				,{"Generic_Victory_Destroyer", 1, StartYear = -20}
			},
			Government_Building = "Rendili_HQ",
		},
		STARDRIVE_CIS = {
			Space_Unit_Table = {
				{"Invincible_Cruiser", 0.2}
				,{"CIS_Dreadnaught", 4}
				,{"CIS_Dreadnaught_Lasers", 3}
				,{"Customs_Corvette", 3}
				,{"Neutron_Star", 0.2, StartYear = -21}
			},
			Government_Building = "Rendili_HQ",
		},
		CECORELLIAN = {
			Space_Unit_Table = {
				{"Starbolt", 3}
				,{"CEC_Light_Cruiser", 3}
				,{"LAC", 3}
				,{"Consular_Refit", 3}
				,{"Charger_C70", 3, StartYear = -22}				
				,{"Corellian_Corvette", 5}
				,{"Corellian_Gunboat", 5}
				,{"Interceptor_Frigate", 0.3}
				,{"Action_VI_Support", 0.3}				
			},
			Government_Building = "CEC_HQ",
		},
		KUATI = {
			Space_Unit_Table = {
				{"Class_C_Frigate", 3}
				,{"Generic_Venator", 2, StartYear = -21}
				,{"Generic_Victory_Destroyer", 1, StartYear = -20}
				,{"Generic_Acclamator_Assault_Ship_I", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_Leveler", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_II", 4, StartYear = -19}				
				,{"Arquitens", 3, StartYear = -21}
				,{"Pelta_Assault", 3, StartYear = -22}
				,{"Pelta_Support", 3, StartYear = -22}
				,{"Galleon", 3}
				,{"Generic_Procurator", 1}
				,{"Munifex", 3, LastYear = -23}
				,{"Lupus_Missile_Frigate", 3, LastYear = -23}
				,{"Captor", 2, LastYear = -23}
				,{"Auxilia", 2, LastYear = -23}
			},
			Land_Unit_Table = {
				{"Security_Trooper_Team", 3}				
				,{"Republic_AT_PT_Company", 0.5}
				,{"Republic_AT_RT_Company", 2, StartYear = -22}
				,{"Republic_AT_XT_Company", 0.5, StartYear = -22, LastYear = -22}
				,{"Republic_TX130_Company", 0.5, StartYear = -22}
				,{"Republic_UT_AA_Company", 1, StartYear = -22}			
				,{"Republic_LAAT_Group", 0.5, StartYear = -22}
				,{"Republic_VAAT_Group", 0.25}
				,{"Republic_A4_Juggernaut_Company", 2, LastYear = -23}
				,{"Republic_A5_Juggernaut_Company", 2, StartYear = -22}
				,{"Republic_A6_Juggernaut_Company", 1, StartYear = -22}
				,{"Republic_RX200_Falchion_Company", 0.5, StartYear = -22}			
				,{"Republic_A5RX_Company", 2, StartYear = -22}				
				,{"Republic_UT_AT_Speeder_Company", 1, StartYear = -22}
				,{"Republic_AT_TE_Walker_Company", 0.5, StartYear = -22}
				,{"Republic_AT_OT_Walker_Company", 2, StartYear = -19}
				,{"Republic_AT_AP_Walker_Company", 2, StartYear = -19}				
			},
			Government_Building = "KDY_HQ",			
		},
		KUATI_CIS = {
			Space_Unit_Table = {
				{"Munifex", 5}
				,{"Lupus_Missile_Frigate", 5}
				,{"Captor", 4}
				,{"Auxilia", 4}
				,{"Storm_Fleet_Destroyer", 3, StartYear = -21}		
			},
			Government_Building = "KDY_HQ",
		},		
		CLONES = {
			Land_Unit_Table = {	
				{"Clonetrooper_Phase_One_Team", 2, LastYear = -21}
				,{"Clonetrooper_Phase_Two_Team", 2, StartYear = -20}
				,{"Clone_Galactic_Marine_Platoon", 1}	
				,{"ARC_Phase_One_Team", 1, LastYear = -21}
				,{"ARC_Phase_Two_Team", 1, StartYear = -20}
				,{"Clone_Commando_Team", 1}
				,{"Clone_Special_Ops_Platoon", 1, LastYear = -21}			
				,{"Clone_Jumptrooper_Phase_One_Company", 1, LastYear = -21}
				,{"Clone_Jumptrooper_Phase_Two_Company", 1, StartYear = -20}		
				,{"Clone_Blaze_Trooper_Squad", 1, StartYear = -20}
			}
		},
		ROTHANAN = {
			Space_Unit_Table = {
				{"Galleon", 1}
				,{"Pelta_Assault", 2, StartYear = -22}
				,{"Pelta_Support", 2, StartYear = -22}				
				,{"Generic_Acclamator_Assault_Ship_I", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_Leveler", 4, StartYear = -22}
				,{"Generic_Acclamator_Assault_Ship_II", 4, StartYear = -19}	
			},	
			Land_Unit_Table = {
				{"Clonetrooper_Phase_One_Team", 2, LastYear = -21}
				,{"Clonetrooper_Phase_Two_Team", 2, StartYear = -20}
				,{"Clone_Galactic_Marine_Platoon", 1}
				,{"Republic_AT_PT_Company", 2}
				,{"Republic_AT_XT_Company", 2, StartYear = -22}
				,{"Republic_TX130_Company", 2, StartYear = -22}
				,{"Republic_TX130_Company", 2, StartYear = -22}				
				,{"Republic_AT_TE_Walker_Company", 2, StartYear = -22}			
				,{"Republic_RX200_Falchion_Company", 1, StartYear = -22}				
				,{"Republic_LAAT_Group", 1, StartYear = -22}
				,{"Republic_VAAT_Group", 0.5}
			},
			Government_Building = "Rothana_HQ",
		},
		SITHWORLD_REP = {
			Space_Unit_Table = {
				{"Galleon", 1}
				,{"IPV1_System_Patrol_Craft", 4}
				,{"Carrack_Cruiser_Lasers", 2}				
				,{"Generic_Acclamator_Assault_Ship_II", 4, StartYear = -19}	
			},	
			Land_Unit_Table = {
				{"Special_Tactics_Trooper_Squad", 3}			
				,{"Sun_Guard_Squad", 4}
				,{"Republic_AV7_Company", 0.5, StartYear = -22}
			}
		},		
		SITHWORLD_CIS = {
			Space_Unit_Table = {
				{"Supply_Ship", 0.5}
				,{"Marauder_Cruiser", 4}
				,{"Geonosian_Cruiser", 2}				
				,{"Recusant", 4, StartYear = -22}
			},	
			Land_Unit_Table = {
				{"B1_Droid_Squad", 3, LastYear = -21}
				,{"B2_Droid_Squad", 3, StartYear = -22}
				,{"HAG_Company", 0.5}
				,{"Sun_Guard_Squad", 4}
			}
		},				
		NIMBUS = {
			Land_Unit_Table = {	
				{"Nimbus_Commando_Company", 3}
			}
		},
	}
	
	local returnValue = Faction_Table[faction]
	
	local override = Faction_Table[rosterOverride]
	
	if returnValue == nil then
		returnValue = Faction_Table["INDEPENDENT_FORCES"]
	end
	
	if override ~= nil and rosterOverride ~= faction then
		if override.Space_Unit_Table ~= nil then
			returnValue.Space_Unit_Table = override.Space_Unit_Table
		end
		if override.Land_Unit_Table ~= nil then
			returnValue.Land_Unit_Table = override.Land_Unit_Table
		end
		if faction == "INDEPENDENT_FORCES" or faction == "WARLORDS" then
			if override.Groundbase_Table ~= nil then
				returnValue.Groundbase_Table = override.Groundbase_Table
			end
			if override.Starbase_Table ~= nil then
				returnValue.Starbase_Table = override.Starbase_Table
			end
			if override.Shipyard_Table ~= nil then
				returnValue.Shipyard_Table = override.Shipyard_Table
			end
			if override.Defenses_Table ~= nil then
				returnValue.Defenses_Table = override.Defenses_Table
			end
			if override.Government_Building ~= nil then
				returnValue.Government_Building = override.Government_Building
			end
			if override.GTS_Building ~= nil then
				returnValue.GTS_Building = override.GTS_Building
			end
		end
	end

	return returnValue
end