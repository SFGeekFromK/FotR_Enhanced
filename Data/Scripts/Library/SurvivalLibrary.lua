return {
    ["STARBASE_TYPES"] = {
        ["REBEL"] = "Survival_CIS_Starbase",
        ["EMPIRE"] = "Survival_Republic_Starbase",
        ["HUTT_CARTELS"] = "Survival_Hutt_Cartels_Starbase"
	},
    ["UPGRADE_TYPES"] = {
        ["SURVIVAL_REP_LEVEL_2_STARBASE_UPGRADE"] = "Space_Level_Two_Tech_Upgrade",
        ["SURVIVAL_CIS_LEVEL_2_STARBASE_UPGRADE"] = "Space_Level_Two_Tech_Upgrade",
        ["SURVIVAL_HUTT_CARTELS_LEVEL_2_STARBASE_UPGRADE"] = "Space_Level_Two_Tech_Upgrade",
        ["SURVIVAL_REP_LEVEL_3_STARBASE_UPGRADE"] = "Space_Level_Three_Tech_Upgrade",
        ["SURVIVAL_CIS_LEVEL_3_STARBASE_UPGRADE"] = "Space_Level_Three_Tech_Upgrade",
        ["SURVIVAL_HUTT_CARTELS_LEVEL_3_STARBASE_UPGRADE"] = "Space_Level_Three_Tech_Upgrade",
        ["SURVIVAL_REP_LEVEL_4_STARBASE_UPGRADE"] = "Space_Level_Four_Tech_Upgrade",
        ["SURVIVAL_CIS_LEVEL_4_STARBASE_UPGRADE"] = "Space_Level_Four_Tech_Upgrade",
        ["SURVIVAL_HUTT_CARTELS_LEVEL_4_STARBASE_UPGRADE"] = "Space_Level_Four_Tech_Upgrade",
        ["SURVIVAL_REP_LEVEL_5_STARBASE_UPGRADE"] = "Space_Level_Five_Tech_Upgrade",
        ["SURVIVAL_CIS_LEVEL_5_STARBASE_UPGRADE"] = "Space_Level_Five_Tech_Upgrade",
        ["SURVIVAL_HUTT_CARTELS_LEVEL_5_STARBASE_UPGRADE"] = "Space_Level_Five_Tech_Upgrade"
    },
	["ALTERNATE_RESEARCH_TYPES"] = {
        ["REBEL"] = "Survival_CIS_Alternate_Research_Starbase",
        ["EMPIRE"] = "Survival_Republic_Alternate_Research_Starbase",
        ["HUTT_CARTELS"] = "Survival_Hutt_Cartels_Alternate_Research_Starbase"
	},
    ["UNIT_OPTIONS"] ={
		{	Find_Object_Type("LAC"), --Republic
			Find_Object_Type("Corellian_Corvette"),
			Find_Object_Type("Customs_Corvette"),
			Find_Object_Type("Consular_Refit"),
			Find_Object_Type("Charger_C70"),
			Find_Object_Type("Corellian_Gunboat"),
			Find_Object_Type("Lancer_Frigate"),
			Find_Object_Type("Pelta_Assault"),
			Find_Object_Type("CEC_Light_Cruiser"),
			Find_Object_Type("Arquitens"),
			Find_Object_Type("Class_C_Frigate"),
			Find_Object_Type("Victory_I_Frigate"),
			Find_Object_Type("Carrack_Cruiser_Lasers"),
			Find_Object_Type("Carrack_Cruiser"),
			Find_Object_Type("Diamond_Frigate"),-- CIS
			Find_Object_Type("Hardcell"),
			Find_Object_Type("Hardcell_Tender"),
			Find_Object_Type("Lupus_Missile_Frigate"),
			Find_Object_Type("Marauder_Cruiser"),
			Find_Object_Type("Geonosian_Cruiser"),
			Find_Object_Type("C9979_Carrier"),
			Find_Object_Type("Munifex"),
			Find_Object_Type("Sabaoth_Frigate"),
			Find_Object_Type("Light_Minstrel_Yacht"),-- Hutts
			Find_Object_Type("Raka_Freighter_Tender"),
			Find_Object_Type("Heavy_Minstrel_Yacht"),
			Find_Object_Type("Kaloth_Battlecruiser"),
			Find_Object_Type("Juvard_Frigate"),
			Find_Object_Type("IPV1_System_Patrol_Craft"),-- Other
			Find_Object_Type("Interceptor_Frigate"),
			Find_Object_Type("Action_VI_Support"),
			Find_Object_Type("Super_Transport_VI"),
			Find_Object_Type("Super_Transport_VII"),
			-- FotR_Enhanced
			Find_Object_Type("Umbaran_Frigate"),
		},
		{
			Find_Object_Type("Starbolt"),-- Republic
			Find_Object_Type("Dreadnaught_Lasers"),
			Find_Object_Type("Dreadnaught"),
			Find_Object_Type("Neutron_Star"),
			Find_Object_Type("Dreadnaught_Carrier"),
			Find_Object_Type("Generic_Gladiator"),
			Find_Object_Type("Generic_Acclamator_Assault_Ship_I"),
			Find_Object_Type("Generic_Acclamator_Assault_Ship_Leveler"),
			Find_Object_Type("Generic_Acclamator_Assault_Ship_II"),
			Find_Object_Type("Generic_Imperial_I_Frigate"),
			Find_Object_Type("Auxilia"),-- CIS
			Find_Object_Type("Munificent"),
			Find_Object_Type("Recusant"),
			Find_Object_Type("Captor"),
			Find_Object_Type("Sabaoth_Hex_Deployer"),
			Find_Object_Type("Barabbula_Frigate"),-- Hutts
			Find_Object_Type("Kossak_Frigate"),
			Find_Object_Type("Super_Transport_XI"),-- Other
		},
        {
            Find_Object_Type("Generic_Venator"),-- Republic
            Find_Object_Type("Generic_Victory_Destroyer"),
            Find_Object_Type("Generic_Victory_Fleet_Destroyer"),
            Find_Object_Type("Generic_Victory_Destroyer_Two"),
            Find_Object_Type("Storm_Fleet_Destroyer"),-- CIS
            Find_Object_Type("Lucrehulk_Core_Destroyer"),
            Find_Object_Type("Bulwark_I"),
			Find_Object_Type("Generic_Providence"),
			Find_Object_Type("Sabaoth_Destroyer"),
			Find_Object_Type("Szajin_Cruiser"),--Hutts
			Find_Object_Type("Karagga_Destroyer"),
			Find_Object_Type("Super_Transport_XI_Modified"),-- Other
			Find_Object_Type("Space_ARC_Cruiser"),
			Find_Object_Type("Calamari_Cruiser_Liner"),
			-- FotR_Enhanced
			Find_Object_Type("Generic_Venator_OFC"),
			Find_Object_Type("Generic_Venator_SPHA_T"),
        },
        {
            Find_Object_Type("Invincible_Cruiser"),-- Republic
            Find_Object_Type("Generic_Star_Destroyer"),
            Find_Object_Type("Generic_Tector"),
            Find_Object_Type("Generic_Maelstrom"),
            Find_Object_Type("Recusant_Dreadnought"),-- CIS
            Find_Object_Type("Bulwark_II"),
			Find_Object_Type("Providence_Dreadnought"),
			Find_Object_Type("Auxiliary_Lucrehulk"),
			Find_Object_Type("Auxiliary_Lucrehulk_Control"),
			Find_Object_Type("Vontor_Destroyer"),-- Hutts
			Find_Object_Type("Voracious_Carrier"),
			Find_Object_Type("Home_One_Type_Liner"),-- Other
        },
        {
            Find_Object_Type("Generic_Procurator"),-- Republic
            Find_Object_Type("Generic_Secutor"),
			Find_Object_Type("Generic_Praetor"),
            Find_Object_Type("Generic_Mandator"),
            Find_Object_Type("Generic_Mandator_II"),
            Find_Object_Type("Generic_Lucrehulk"),-- CIS
            Find_Object_Type("Generic_Lucrehulk_Control"),
            Find_Object_Type("Battleship_Lucrehulk"),
			Find_Object_Type("Subjugator"),
			Find_Object_Type("DorBulla_Warship"),
			Find_Object_Type("Generic_Tagge_Battlecruiser"),-- Other
        },
        {
        }
    },
    ["BOSS_UNITS"] = {
        {},
        {
            Find_Object_Type("Baraka_Nexu"),
			Find_Object_Type("Canteval_Munificent"),
			Find_Object_Type("Dallin_Kebir"),
			Find_Object_Type("Grievous_Munificent"),
			Find_Object_Type("Harsol_Munificent"),
			Find_Object_Type("Hauser_Dreadnaught"),
			Find_Object_Type("Maarisa_Captor"),
			Find_Object_Type("Martz_Prosecutor"),
			Find_Object_Type("McQuarrie_Concept"),
			Find_Object_Type("Mellor_Yago_Rendili_Reign"),
			Find_Object_Type("Pellaeon_Leveler"),
			Find_Object_Type("Raymus_Tantive"),
			Find_Object_Type("Shonn_Recusant"),
			Find_Object_Type("Shu_Mai_Castell"),
			Find_Object_Type("Solenoid_CR90"),
			Find_Object_Type("Stark_Recusant"),
			Find_Object_Type("Tallon_Sundiver"),
			Find_Object_Type("Treetor_Captor"),
			Find_Object_Type("Wessel_Acclamator"),
			Find_Object_Type("Zozridor_Slayke_Carrack"),
			Find_Object_Type("Zozridor_Slayke_CR90"),
			-- FotR_Enhanced
			Find_Object_Type("Needa_Integrity"),
        },
        {
            Find_Object_Type("Autem_Venator"),
			Find_Object_Type("AutO_Providence"),
			Find_Object_Type("Byluir_Venator"),
			Find_Object_Type("Calli_Trilm_Bulwark"),
			Find_Object_Type("Coburn_Triumphant"),
			Find_Object_Type("Dao_Venator"),
			Find_Object_Type("Dellso_Providence"),
			Find_Object_Type("Denimoor_Tenacious"),
			Find_Object_Type("Dodonna_Ardent"),
			Find_Object_Type("Dron_Venator"),
			Find_Object_Type("Dua_Ningo_Unrepentant"),
			Find_Object_Type("Forral_Vensenor"),
			Find_Object_Type("Grant_Venator"),
			Find_Object_Type("Invisible_Hand"),
			Find_Object_Type("Kilian_Endurance"),
			Find_Object_Type("Maarisa_Retaliation"),
			Find_Object_Type("Parck_Strikefast"),
			Find_Object_Type("Praji_Valorum"),
			Find_Object_Type("Ravik_Victory"),
			Find_Object_Type("Screed_Arlionne"),
			Find_Object_Type("Tarkin_Venator"),
			Find_Object_Type("TF1726_Munificent"),
			Find_Object_Type("Therbon_Cerulean_Sunrise"),
			Find_Object_Type("Trachta_Venator"),
			Find_Object_Type("Vetlya_Core_Destroyer"),
			Find_Object_Type("Vorru_Venator"),
			Find_Object_Type("Wessex_Redoubt"),
			Find_Object_Type("Wieler_Resilient"),
			Find_Object_Type("Yularen_Integrity"),
			Find_Object_Type("Yularen_Resolute"),
			-- FotR_Enhanced
			Find_Object_Type("TJ912_Recusant"),
			Find_Object_Type("TM171_DH_Omni"),
			Find_Object_Type("Block_Negotiator"),
			Find_Object_Type("Block_Vigilance"),
        },
        {
			Find_Object_Type("Coy_Imperator"),
			Find_Object_Type("Grievous_Recusant"),
			Find_Object_Type("Grumby_Invincible"),
			Find_Object_Type("Kreuge_Gibbon"),
			Find_Object_Type("Merai_Free_Dac"),
			Find_Object_Type("Mulleen_Imperator"),
			Find_Object_Type("Seerdon_Invincible"),
			Find_Object_Type("Tarkin_Executrix"),
			Find_Object_Type("Trench_Invincible"),
			Find_Object_Type("Trench_Invulnerable"),
			Find_Object_Type("Yularen_Invincible"),
			Find_Object_Type("K2B4_Providence")
        },
        {
			Find_Object_Type("Doctor_Instinction"),
			Find_Object_Type("Grievous_Malevolence"),
			Find_Object_Type("Onara_Kuat_Mandator"),
			Find_Object_Type("Tallon_Battalion"),
			Find_Object_Type("Tonith_Corpulentus"),
			Find_Object_Type("Tuuk_Procurer")
        },
    }

}