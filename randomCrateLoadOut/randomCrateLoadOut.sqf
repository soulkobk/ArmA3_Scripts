/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2016 soulkobk (soulkobk.blogspot.com)

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.

	----------------------------------------------------------------------------------------------
	
	Name: randomCrateLoadOut.sqf
	Version: 1.0.1
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:40 PM 07/10/2016
	Modification Date: 2:20 PM 10/10/2016
	
	Description:
	For use with A3Wasteland 1.3x mission (A3Wasteland.com). This script is a replacement mission
	crate load-out script that will randomly select and place items in to mission crates.
	
	Place this script in the mission file, in path \server\functions\randomCrateLoadOut.sqf
	and edit \server\functions\serverCompile.sqf and place...	
	randomCrateLoadOut = [_path, "randomCrateLoadOut.sqf"] call mf_compile;
	underneath the line...
	_path = "server\functions";
	
	It will totally replace the A3Wasteland function 'fn_refillbox'. You will need to search and
	replace the text/function in all your mission scripts in order to get this script to function.
	See Example: below.

	The custom function will disable damage to the crate, lock the crate until mission is completed,
	and randomly fill the crate with loot. To edit the script and how it functions, see the code
	below from lines 64 to 1109. Some loot is commented out by default (OP items), I have left
	them in should you want them in your A3Wasteland mission.

	Parameter(s): <object> call randomCrateLoadOut;

	Example: (missions)
	_box1 = createVehicle ["Box_NATO_WpsSpecial_F", _missionPos, [], 5, "None"];
	_box1 setDir random 360;
	// [_box1, "mission_USSpecial"] call fn_refillbox; // <- this line is now null
	_box1 call randomCrateLoadOut; // new randomCrateLoadOut function call
	
	Example: (outposts)
	["Box_FIA_Wps_F",[-5,4.801,0],90,{_this call randomCrateLoadOut;}]
	
	Change Log:
	1.0.0 -	original base script.
	1.0.1 -	description/config changes for a clearer understanding of how this script functions and
			what function (fn_refillbox) it replaces.

	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

// #define __DEBUG__

_backPacks =
[
	// "B_AA_01_weapon_F", // Static Titan Launcher (AA) [NATO]
	"B_AssaultPack_blk", // Assault Pack (Black)
	"B_AssaultPack_cbr", // Assault Pack (Coyote)
	"B_AssaultPack_dgtl", // Assault Pack (Digi)
	// "B_AssaultPack_Kerry", // US Assault Pack (Kerry)
	"B_AssaultPack_khk", // Assault Pack (Khaki)
	"B_AssaultPack_mcamo", // Assault Pack (MTP)
	"B_AssaultPack_ocamo", // Assault Pack (Hex)
	"B_AssaultPack_rgr", // Assault Pack (Green)
	"B_AssaultPack_sgg", // Assault Pack (Sage)
	"B_AssaultPack_tna_F", // Assault Pack (Tropic)
	// "B_AT_01_weapon_F", // Static Titan Launcher (AT) [NATO]
	"B_Bergen_dgtl_F", // Bergen Backpack (Digital)
	"B_Bergen_hex_F", // Bergen Backpack (Hex)
	"B_Bergen_mcamo_F", // Bergen Backpack (MTP)
	"B_Bergen_tna_F", // Bergen Backpack (Tropic)
	"B_Carryall_cbr", // Carryall Backpack (Coyote)
	"B_Carryall_ghex_F", // Carryall Backpack (Green Hex)
	"B_Carryall_khk", // Carryall Backpack (Khaki)
	"B_Carryall_mcamo", // Carryall Backpack (MTP)
	"B_Carryall_ocamo", // Carryall Backpack (Hex)
	"B_Carryall_oli", // Carryall Backpack (Olive)
	"B_Carryall_oucamo", // Carryall Backpack (Urban)
	"B_FieldPack_blk", // Field Pack (Black)
	"B_FieldPack_cbr", // Field Pack (Coyote)
	"B_FieldPack_ghex_F", // Field Pack (Green Hex)
	"B_FieldPack_khk", // Field Pack (Khaki)
	"B_FieldPack_ocamo", // Field Pack (Hex)
	"B_FieldPack_oli", // Field Pack (Olive)
	"B_FieldPack_oucamo", // Field Pack (Urban)
	// "B_GMG_01_A_weapon_F", // Dismantled Autonomous GMG [NATO]
	// "B_GMG_01_high_weapon_F", // Dismantled Mk32 GMG (Raised) [NATO]
	// "B_GMG_01_weapon_F", // Dismantled Mk32 GMG [NATO]
	// "B_HMG_01_A_weapon_F", // Dismantled Autonomous MG [NATO]
	// "B_HMG_01_high_weapon_F", // Dismantled Mk30 HMG (Raised) [NATO]
	// "B_HMG_01_support_F", // Folded Tripod [NATO]
	// "B_HMG_01_support_high_F", // Folded Tripod (Raised) [NATO]
	// "B_HMG_01_weapon_F", // Dismantled Mk30 HMG [NATO]
	"B_Kitbag_cbr", // Kitbag (Coyote)
	"B_Kitbag_mcamo", // Kitbag (MTP)
	"B_Kitbag_rgr", // Kitbag (Green)
	"B_Kitbag_sgg", // Kitbag (Sage)
	// "B_Mortar_01_support_F", // Folded Mk6 Mortar Bipod [NATO]
	// "B_Mortar_01_weapon_F", // Folded Mk6 Mortar Tube [NATO]
	// "B_Parachute", // Steerable Parachute
	// "B_Static_Designator_01_weapon_F", // Remote Designator Bag [NATO]
	"B_TacticalPack_blk", // Tactical Backpack (Black)
	"B_TacticalPack_mcamo", // Tactical Backpack (MTP)
	"B_TacticalPack_ocamo", // Tactical Backpack (Hex)
	"B_TacticalPack_oli", // Tactical Backpack (Olive)
	"B_TacticalPack_rgr", // Tactical Backpack (Green)
	// "B_UAV_01_backpack_F", // UAV Bag [NATO]
	"B_ViperHarness_blk_F", // Viper Harness (Black)
	"B_ViperHarness_ghex_F", // Viper Harness (Green Hex)
	"B_ViperHarness_hex_F", // Viper Harness (Hex)
	"B_ViperHarness_khk_F", // Viper Harness (Khaki)
	"B_ViperHarness_oli_F", // Viper Harness (Olive)
	"B_ViperLightHarness_blk_F", // Viper Light Harness (Black)
	"B_ViperLightHarness_ghex_F", // Viper Light Harness (Green Hex)
	"B_ViperLightHarness_hex_F", // Viper Light Harness (Hex)
	"B_ViperLightHarness_khk_F", // Viper Light Harness (Khaki)
	"B_ViperLightHarness_oli_F" // Viper Light Harness (Olive)
	// "I_AA_01_weapon_F", // Static Titan Launcher (AA) [AAF]
	// "I_AT_01_weapon_F", // Static Titan Launcher (AT) [AAF]
	// "I_GMG_01_A_weapon_F", // Dismantled Autonomous GMG [AAF]
	// "I_GMG_01_high_weapon_F", // Dismantled Mk32 GMG (Raised) [AAF]
	// "I_GMG_01_weapon_F", // Dismantled Mk32 GMG [AAF]
	// "I_HMG_01_A_weapon_F", // Dismantled Autonomous MG [AAF]
	// "I_HMG_01_high_weapon_F", // Dismantled Mk30 HMG (Raised) [AAF]
	// "I_HMG_01_support_F", // Folded Tripod [AAF]
	// "I_HMG_01_support_high_F", // Folded Tripod (Raised) [AAF]
	// "I_HMG_01_weapon_F", // Dismantled Mk30 HMG [AAF]
	// "I_Mortar_01_support_F", // Folded Mk6 Mortar Bipod [AAF]
	// "I_Mortar_01_weapon_F", // Folded Mk6 Mortar Tube [AAF]
	// "I_UAV_01_backpack_F", // UAV Bag [AAF]
	// "O_AA_01_weapon_F", // Static Titan Launcher (AA) [CSAT]
	// "O_AT_01_weapon_F", // Static Titan Launcher (AT) [CSAT]
	// "O_GMG_01_A_weapon_F", // Dismantled Autonomous GMG [CSAT]
	// "O_GMG_01_high_weapon_F", // Dismantled Mk32 GMG (Raised) [CSAT]
	// "O_GMG_01_weapon_F", // Dismantled Mk32 GMG [CSAT]
	// "O_HMG_01_A_weapon_F", // Dismantled Autonomous MG [CSAT]
	// "O_HMG_01_high_weapon_F", // Dismantled Mk30 HMG (Raised) [CSAT]
	// "O_HMG_01_support_F", // Folded Tripod [CSAT]
	// "O_HMG_01_support_high_F", // Folded Tripod (Raised) [CSAT]
	// "O_HMG_01_weapon_F", // Dismantled Mk30 HMG [CSAT]
	// "O_Mortar_01_support_F", // Folded Mk6 Mortar Bipod [CSAT]
	// "O_Mortar_01_weapon_F", // Folded Mk6 Mortar Tube [CSAT]
	// "O_Static_Designator_02_weapon_F", // Remote Designator Bag [CSAT]
	// "O_UAV_01_backpack_F" // UAV Bag [CSAT]
];

_binoculars =
[
	"Laserdesignator", // Laser Designator (Sand) BINOCULAR"
	"Laserdesignator_01_khk_F", // Laser Designator (Khaki) BINOCULAR"
	"Laserdesignator_02", // Laser Designator (Hex) BINOCULAR"
	"Laserdesignator_02_ghex_F", // Laser Designator (Green Hex) BINOCULAR"
	"Laserdesignator_03", // Laser Designator (Olive) BINOCULAR"
	// "NVGoggles", // NV Goggles (Brown) BINOCULAR"
	// "NVGogglesB_blk_F", // ENVG-II (Black) BINOCULAR"
	// "NVGogglesB_grn_F", // ENVG-II (Green) BINOCULAR"
	// "NVGogglesB_gry_F", // ENVG-II (Grey) BINOCULAR"
	// "NVGoggles_INDEP", // NV Goggles (Green) BINOCULAR"
	// "NVGoggles_OPFOR", // NV Goggles (Black) BINOCULAR"
	// "NVGoggles_tna_F", // NV Goggles (Tropic) BINOCULAR"
	"O_NVGoggles_ghex_F", // Compact NVG (Green Hex) BINOCULAR"
	"O_NVGoggles_hex_F", // Compact NVG (Hex) BINOCULAR"
	"O_NVGoggles_urb_F", // Compact NVG (Urban) BINOCULAR"
	"Rangefinder" // Rangefinder BINOCULAR"
];

_bipods =
[
	"bipod_01_F_blk", // Bipod (Black) [NATO] BIPOD"
	"bipod_01_F_khk", // Bipod (Khaki) [NATO] BIPOD"
	"bipod_01_F_mtp", // Bipod (MTP) [NATO] BIPOD"
	"bipod_01_F_snd", // Bipod (Sand) [NATO] BIPOD"
	"bipod_02_F_blk", // Bipod (Black) [CSAT] BIPOD"
	"bipod_02_F_hex", // Bipod (Hex) [CSAT] BIPOD"
	"bipod_02_F_tan", // Bipod (Tan) [CSAT] BIPOD"
	"bipod_03_F_blk", // Bipod (Black) [AAF] BIPOD"
	"bipod_03_F_oli" // Bipod (Olive) [AAF] BIPOD"
];

_headGear =
[
	// "H_Bandanna_blu", // Bandana (Blue)
	// "H_Bandanna_camo", // Bandana (Woodland)
	// "H_Bandanna_cbr", // Bandana (Coyote)
	// "H_Bandanna_gry", // Bandana (Black)
	// "H_Bandanna_khk", // Bandana (Khaki)
	// "H_Bandanna_khk_hs", // Bandana (Headset)
	// "H_Bandanna_mcamo", // Bandana (MTP)
	// "H_Bandanna_sand", // Bandana (Sand)
	// "H_Bandanna_sgg", // Bandana (Sage)
	// "H_Bandanna_surfer", // Bandana (Surfer)
	// "H_Bandanna_surfer_blk", // Bandana (Surfer, Black)
	// "H_Bandanna_surfer_grn", // Bandana (Surfer, Green)
	// "H_Beret_02", // Beret [NATO]
	// "H_Beret_blk", // Beret (Black)
	// "H_Beret_Colonel", // Beret [NATO] (Colonel)
	// "H_Beret_gen_F", // Beret (Gendarmerie)
	// "H_Booniehat_dgtl", // Booniehat [AAF]
	// "H_Booniehat_khk", // Booniehat (Khaki)
	// "H_Booniehat_khk_hs", // Booniehat (Headset)
	// "H_Booniehat_mcamo", // Booniehat (MTP)
	// "H_Booniehat_oli", // Booniehat (Olive)
	// "H_Booniehat_tan", // Booniehat (Sand)
	// "H_Booniehat_tna_F", // Booniehat (Tropic)
	// "H_Cap_blk", // Cap (Black)
	// "H_Cap_blk_CMMG", // Cap (CMMG)
	// "H_Cap_blk_ION", // Cap (ION)
	// "H_Cap_blk_Raven", // Cap [AAF]
	// "H_Cap_blu", // Cap (Blue)
	// "H_Cap_brn_SPECOPS", // Cap [OPFOR]
	// "H_Cap_grn", // Cap (Green)
	// "H_Cap_grn_BI", // Cap (BI)
	// "H_Cap_headphones", // Rangemaster Cap
	// "H_Cap_khaki_specops_UK", // Cap (UK)
	// "H_Cap_marshal", // Marshal Cap
	// "H_Cap_oli", // Cap (Olive)
	// "H_Cap_oli_hs", // Cap (Olive, Headset)
	// "H_Cap_police", // Cap (Police)
	// "H_Cap_press", // Cap (Press)
	// "H_Cap_red", // Cap (Red)
	// "H_Cap_surfer", // Cap (Surfer)
	// "H_Cap_tan", // Cap (Tan)
	// "H_Cap_tan_specops_US", // Cap (US MTP)
	// "H_Cap_usblack", // Cap (US Black)
	"H_CrewHelmetHeli_B", // Heli Crew Helmet [NATO]
	"H_CrewHelmetHeli_I", // Heli Crew Helmet [AAF]
	"H_CrewHelmetHeli_O", // Heli Crew Helmet [CSAT]
	// "H_Hat_blue", // Hat (Blue)
	// "H_Hat_brown", // Hat (Brown)
	// "H_Hat_camo", // Hat (Camo)
	// "H_Hat_checker", // Hat (Checker)
	// "H_Hat_grey", // Hat (Grey)
	// "H_Hat_tan", // Hat (Tan)
	"H_HelmetB", // Combat Helmet
	"H_HelmetB_black", // Combat Helmet (Black)
	"H_HelmetB_camo", // Combat Helmet (Camo)
	"H_HelmetB_desert", // Combat Helmet (Desert)
	"H_HelmetB_Enh_tna_F", // Enhanced Combat Helmet (Tropic)
	"H_HelmetB_grass", // Combat Helmet (Grass)
	"H_HelmetB_light", // Light Combat Helmet
	"H_HelmetB_light_black", // Light Combat Helmet (Black)
	"H_HelmetB_light_desert", // Light Combat Helmet (Desert)
	"H_HelmetB_light_grass", // Light Combat Helmet (Grass)
	"H_HelmetB_light_sand", // Light Combat Helmet (Sand)
	"H_HelmetB_light_snakeskin", // Light Combat Helmet (Snakeskin)
	"H_HelmetB_Light_tna_F", // Light Combat Helmet (Tropic)
	"H_HelmetB_sand", // Combat Helmet (Sand)
	"H_HelmetB_snakeskin", // Combat Helmet (Snakeskin)
	"H_HelmetB_TI_tna_F", // Stealth Combat Helmet
	"H_HelmetB_tna_F", // Combat Helmet (Tropic)
	"H_HelmetCrew_B", // Crew Helmet [NATO]
	"H_HelmetCrew_I", // Crew Helmet [AAF]
	"H_HelmetCrew_O", // Crew Helmet [CSAT]
	"H_HelmetCrew_O_ghex_F", // Crew Helmet (Green Hex) [CSAT]
	// "H_HelmetIA", // Modular Helmet
	"H_HelmetLeaderO_ghex_F", // Defender Helmet (Green Hex)
	"H_HelmetLeaderO_ocamo", // Defender Helmet (Hex)
	"H_HelmetLeaderO_oucamo", // Defender Helmet (Urban)
	"H_HelmetO_ghex_F", // Protector Helmet (Green Hex)
	"H_HelmetO_ocamo", // Protector Helmet (Hex)
	"H_HelmetO_oucamo", // Protector Helmet (Urban)
	// "H_HelmetO_ViperSP_ghex_F", // Special Purpose Helmet (Green Hex)
	// "H_HelmetO_ViperSP_hex_F", // Special Purpose Helmet (Hex)
	"H_HelmetSpecB", // Enhanced Combat Helmet
	"H_HelmetSpecB_blk", // Enhanced Combat Helmet (Black)
	"H_HelmetSpecB_paint1", // Enhanced Combat Helmet (Grass)
	"H_HelmetSpecB_paint2", // Enhanced Combat Helmet (Desert)
	"H_HelmetSpecB_sand", // Enhanced Combat Helmet (Sand)
	"H_HelmetSpecB_snakeskin", // Enhanced Combat Helmet (Snakeskin)
	"H_HelmetSpecO_blk", // Assassin Helmet (Black)
	"H_HelmetSpecO_ghex_F", // Assassin Helmet (Green Hex)
	"H_HelmetSpecO_ocamo", // Assassin Helmet (Hex)
	// "H_Helmet_Skate", // Skate Helmet
	// "H_MilCap_blue", // Military Cap (Blue)
	// "H_MilCap_dgtl", // Military Cap [AAF]
	// "H_MilCap_gen_F", // Military Cap (Gendarmerie)
	// "H_MilCap_ghex_F", // Military Cap (Green Hex)
	// "H_MilCap_gry", // Military Cap (Grey)
	// "H_MilCap_mcamo", // Military Cap (MTP)
	// "H_MilCap_ocamo", // Military Cap (Hex)
	// "H_MilCap_tna_F", // Military Cap (Tropic)
	"H_PilotHelmetFighter_B", // Pilot Helmet [NATO]
	"H_PilotHelmetFighter_I", // Pilot Helmet [AAF]
	"H_PilotHelmetFighter_O", // Pilot Helmet [CSAT]
	"H_PilotHelmetHeli_B", // Heli Pilot Helmet [NATO]
	"H_PilotHelmetHeli_I", // Heli Pilot Helmet [AAF]
	"H_PilotHelmetHeli_O" // Heli Pilot Helmet [CSAT]
	// "H_RacingHelmet_1_black_F", // Racing Helmet (Black)
	// "H_RacingHelmet_1_blue_F", // Racing Helmet (Blue)
	// "H_RacingHelmet_1_F", // Racing Helmet (Fuel)
	// "H_RacingHelmet_1_green_F", // Racing Helmet (Green)
	// "H_RacingHelmet_1_orange_F", // Racing Helmet (Orange)
	// "H_RacingHelmet_1_red_F", // Racing Helmet (Red)
	// "H_RacingHelmet_1_white_F", // Racing Helmet (White)
	// "H_RacingHelmet_1_yellow_F", // Racing Helmet (Yellow)
	// "H_RacingHelmet_2_F", // Racing Helmet (Bluking)
	// "H_RacingHelmet_3_F", // Racing Helmet (Redstone)
	// "H_RacingHelmet_4_F", // Racing Helmet (Vrana)
	// "H_ShemagOpen_khk", // Shemag (White)
	// "H_ShemagOpen_tan", // Shemag (Tan)
	// "H_Shemag_olive", // Shemag (Olive)
	// "H_Shemag_olive_hs", // Shemag (Olive, Headset)
	// "H_StrawHat", // Straw Hat
	// "H_StrawHat_dark", // Straw Hat (Dark)
	// "H_Watchcap_blk", // Beanie
	// "H_Watchcap_camo", // Beanie (Green)
	// "H_Watchcap_cbr", // Beanie (Coyote)
	// "H_Watchcap_khk" // Beanie (Khaki)
];

_items =
[
	"B_UavTerminal", // UAV Terminal [NATO]
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	"FirstAidKit", // First Aid Kit
	// "ItemCompass", // Compass
	"ItemGPS", // GPS
	// "ItemMap", // Map
	// "ItemRadio", // Radio
	// "ItemWatch", // Watch
	"I_UavTerminal", // UAV Terminal [AAF]
	"Medikit", // Medikit
	"Medikit", // Medikit
	"Medikit", // Medikit
	"Medikit", // Medikit
	"Medikit", // Medikit
	"O_UavTerminal", // UAV Terminal [CSAT]
	"ToolKit",// Toolkit
	"ToolKit",// Toolkit
	"ToolKit",// Toolkit
	"ToolKit",// Toolkit
	"ToolKit"// Toolkit
];

_launcherWeapons =
[
	"launch_B_Titan_F", // Titan MPRL (Sand)
	"launch_B_Titan_short_F", // Titan MPRL Compact (Sand)
	"launch_B_Titan_short_tna_F", // Titan MPRL Compact (Tropic)
	"launch_B_Titan_tna_F", // Titan MPRL (Tropic)
	"launch_I_Titan_F", // Titan MPRL (Digital)
	"launch_I_Titan_short_F", // Titan MPRL Compact (Olive)
	"launch_NLAW_F", // PCML
	"launch_O_Titan_F", // Titan MPRL (Hex)
	"launch_O_Titan_ghex_F", // Titan MPRL (Green Hex)
	"launch_O_Titan_short_F", // Titan MPRL Compact (Coyote)
	"launch_O_Titan_short_ghex_F", // Titan MPRL Compact (Green Hex)
	"launch_RPG32_F", // RPG-42 Alamut
	"launch_RPG32_ghex_F", // RPG-42 Alamut (Green Hex)
	"launch_RPG7_F" // RPG-7
	// "MineDetector" // Mine Detector
];

_magazines =
[
	"100Rnd_580x42_Mag_F", // 5.8 mm 100Rnd Mag
	"100Rnd_580x42_Mag_Tracer_F", // 5.8 mm 100Rnd Tracer (Green) Mag
	"100Rnd_65x39_caseless_mag", // 6.5 mm 100Rnd Mag
	"100Rnd_65x39_caseless_mag_Tracer", // 6.5 mm 100Rnd Tracer (Red) Mag
	"10Rnd_127x54_Mag", // 12.7mm 10Rnd Mag
	"10Rnd_338_Mag", // .338 LM 10Rnd Mag
	"10Rnd_50BW_Mag_F", // .50 BW 10Rnd Caseless Mag
	"10Rnd_762x51_Mag", // 7.62mm 10Rnd Mag
	"10Rnd_762x54_Mag", // 7.62mm 10Rnd Mag
	"10Rnd_93x64_DMR_05_Mag", // 9.3mm 10Rnd Mag
	"10Rnd_9x21_Mag", // 9 mm 10Rnd Mag
	"11Rnd_45ACP_Mag", // .45 ACP 11Rnd Mag
	"130Rnd_338_Mag", // .338 NM 130Rnd Belt
	"150Rnd_556x45_Drum_Mag_F", // 5.56 mm 150Rnd Mag
	"150Rnd_556x45_Drum_Mag_Tracer_F", // 5.56 mm 150Rnd Tracer (Red) Mag
	"150Rnd_762x51_Box", // 7.62 mm 150Rnd Box
	"150Rnd_762x51_Box_Tracer", // 7.62 mm 150Rnd Tracer (Green) Box
	"150Rnd_762x54_Box", // 7.62 mm 150Rnd Box
	"150Rnd_762x54_Box_Tracer", // 7.62 mm 150Rnd Tracer (Green) Box
	"150Rnd_93x64_Mag", // 9.3mm 150Rnd Belt
	"16Rnd_9x21_green_Mag", // 9 mm 16Rnd Reload Tracer (Green) Mag
	"16Rnd_9x21_Mag", // 9 mm 16Rnd Mag
	"16Rnd_9x21_red_Mag", // 9 mm 16Rnd Reload Tracer (Red) Mag
	"16Rnd_9x21_yellow_Mag", // 9 mm 16Rnd Reload Tracer (Yellow) Mag
	"1Rnd_HE_Grenade_shell", // 40 mm HE Grenade Round
	"1Rnd_SmokeBlue_Grenade_shell", // Smoke Round (Blue)
	"1Rnd_SmokeGreen_Grenade_shell", // Smoke Round (Green)
	"1Rnd_SmokeOrange_Grenade_shell", // Smoke Round (Orange)
	"1Rnd_SmokePurple_Grenade_shell", // Smoke Round (Purple)
	"1Rnd_SmokeRed_Grenade_shell", // Smoke Round (Red)
	"1Rnd_SmokeYellow_Grenade_shell", // Smoke Round (Yellow)
	"1Rnd_Smoke_Grenade_shell", // Smoke Round (White)
	"200Rnd_556x45_Box_F", // 5.56 mm 200Rnd Reload Tracer (Yellow) Box
	"200Rnd_556x45_Box_Red_F", // 5.56 mm 200Rnd Reload Tracer (Red) Box
	"200Rnd_556x45_Box_Tracer_F", // 5.56 mm 200Rnd Tracer (Yellow) Box
	"200Rnd_556x45_Box_Tracer_Red_F", // 5.56 mm 200Rnd Tracer (Red) Box
	"200Rnd_65x39_cased_Box", // 6.5 mm 200Rnd Belt
	"200Rnd_65x39_cased_Box_Tracer", // 6.5 mm 200Rnd Belt Tracer (Yellow)
	"20Rnd_556x45_UW_mag", // 5.56 mm 20Rnd Dual Purpose Mag
	"20Rnd_650x39_Cased_Mag_F", // 6.5 mm 20Rnd Mag
	"20Rnd_762x51_Mag", // 7.62 mm 20Rnd Mag
	"30Rnd_45ACP_Mag_SMG_01", // .45 ACP 30Rnd Vermin Mag
	"30Rnd_45ACP_Mag_SMG_01_Tracer_Green", // .45 ACP 30Rnd Vermin Tracers (Green) Mag
	"30Rnd_45ACP_Mag_SMG_01_Tracer_Red", // .45 ACP 30Rnd Vermin Tracers (Red) Mag
	"30Rnd_45ACP_Mag_SMG_01_Tracer_Yellow", // .45 ACP 30Rnd Vermin Tracers (Yellow) Mag
	"30Rnd_545x39_Mag_F", // 5.45 mm 30Rnd Reload Tracer (Yellow) Mag
	"30Rnd_545x39_Mag_Green_F", // 5.45 mm 30Rnd Reload Tracer (Green) Mag
	"30Rnd_545x39_Mag_Tracer_F", // 5.45 mm 30Rnd Tracer (Yellow) Mag
	"30Rnd_545x39_Mag_Tracer_Green_F", // 5.45 mm 30Rnd Tracer (Green) Mag
	"30Rnd_556x45_Stanag", // 5.56 mm 30rnd STANAG Reload Tracer (Yellow) Mag
	"30Rnd_556x45_Stanag_green", // 5.56 mm 30rnd STANAG Reload Tracer (Green) Mag
	"30Rnd_556x45_Stanag_red", // 5.56 mm 30rnd STANAG Reload Tracer (Red) Mag
	"30Rnd_556x45_Stanag_Tracer_Green", // 5.56 mm 30rnd Tracer (Green) Mag
	"30Rnd_556x45_Stanag_Tracer_Red", // 5.56 mm 30rnd Tracer (Red) Mag
	"30Rnd_556x45_Stanag_Tracer_Yellow", // 5.56 mm 30rnd Tracer (Yellow) Mag
	"30Rnd_580x42_Mag_F", // 5.8 mm 30Rnd Mag
	"30Rnd_580x42_Mag_Tracer_F", // 5.8 mm 30Rnd Tracer (Green) Mag
	"30Rnd_65x39_caseless_green", // 6.5mm 30Rnd Caseless Mag
	"30Rnd_65x39_caseless_green_mag_Tracer", // 6.5 mm 30Rnd Tracer (Green) Caseless Mag
	"30Rnd_65x39_caseless_mag", // 6.5 mm 30Rnd STANAG Mag
	"30Rnd_65x39_caseless_mag_Tracer", // 6.5 mm 30Rnd Tracer (Red) Mag
	"30Rnd_762x39_Mag_F", // 7.62 mm 30Rnd Reload Tracer (Yellow) Mag
	"30Rnd_762x39_Mag_Green_F", // 7.62 mm 30Rnd Reload Tracer (Green) Mag
	"30Rnd_762x39_Mag_Tracer_F", // 7.62 mm 30Rnd Tracer (Yellow) Mag
	"30Rnd_762x39_Mag_Tracer_Green_F", // 7.62 mm 30Rnd Tracer (Green) Mag
	"30Rnd_9x21_Green_Mag", // 9 mm 30Rnd Reload Tracer (Green) Mag
	"30Rnd_9x21_Mag", // 9 mm 30Rnd Mag
	"30Rnd_9x21_Mag_SMG_02", // 9 mm 30Rnd Mag
	"30Rnd_9x21_Mag_SMG_02_Tracer_Green", // 9 mm 30Rnd Reload Tracer (Green) Mag
	"30Rnd_9x21_Mag_SMG_02_Tracer_Red", // 9 mm 30Rnd Reload Tracer (Red) Mag
	"30Rnd_9x21_Mag_SMG_02_Tracer_Yellow", // 9 mm 30Rnd Reload Tracer (Yellow) Mag
	"30Rnd_9x21_Red_Mag", // 9 mm 30Rnd Reload Tracer (Red) Mag
	"30Rnd_9x21_Yellow_Mag", // 9 mm 30Rnd Reload Tracer (Yellow) Mag
	"3Rnd_HE_Grenade_shell", // 40 mm 3Rnd HE Grenade
	"3Rnd_SmokeBlue_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Blue)
	"3Rnd_SmokeGreen_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Green)
	"3Rnd_SmokeOrange_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Orange)
	"3Rnd_SmokePurple_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Purple)
	"3Rnd_SmokeRed_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Red)
	"3Rnd_SmokeYellow_Grenade_shell", // 3Rnd 3GL Smoke Rounds (Yellow)
	"3Rnd_Smoke_Grenade_shell", // 3Rnd 3GL Smoke Rounds (White)
	"3Rnd_UGL_FlareCIR_F", // 3Rnd 3GL Flares (IR)
	"3Rnd_UGL_FlareGreen_F", // 3Rnd 3GL Flares (Green)
	"3Rnd_UGL_FlareRed_F", // 3Rnd 3GL Flares (Red)
	"3Rnd_UGL_FlareWhite_F", // 3Rnd 3GL Flares (White)
	"3Rnd_UGL_FlareYellow_F", // 3Rnd 3GL Flares (Yellow)
	"5Rnd_127x108_APDS_Mag", // 12.7mm 5Rnd APDS Mag
	"5Rnd_127x108_Mag", // 12.7 mm 5Rnd Mag
	"6Rnd_45ACP_Cylinder", // .45 ACP 6Rnd Cylinder
	"6Rnd_GreenSignal_F", // 6Rnd Signal Cylinder (Green)
	"6Rnd_RedSignal_F", // 6Rnd Signal Cylinder (Red)
	"7Rnd_408_Mag", // .408 7Rnd LRR Mag
	"9Rnd_45ACP_Mag", // .45 ACP 9Rnd Mag
	"FlareGreen_F", // Flare (Green)
	"FlareRed_F", // Flare (Red)
	"FlareWhite_F", // Flare (White)
	"FlareYellow_F", // Flare (Yellow)
	"Laserbatteries", // Designator Batteries
	"NLAW_F", // PCML Missile
	"RPG32_F", // RPG-42 Rocket
	"RPG32_HE_F", // RPG-42 HE Rocket
	"RPG7_F", // PG-7VM HEAT Grenade
	"Titan_AA", // Titan AA Missile
	"Titan_AP", // Titan AP Missile
	"Titan_AT", // Titan AT Missile
	"UGL_FlareCIR_F", // Flare Round (IR)
	"UGL_FlareGreen_F", // Flare Round (Green)
	"UGL_FlareRed_F", // Flare Round (Red)
	"UGL_FlareWhite_F", // Flare Round (White)
	"UGL_FlareYellow_F" // Flare Round (Yellow)
];

_throwables =
[
	// "B_IR_Grenade", // IR Grenade [NATO]
	"HandGrenade", // RGO Grenade
	"HandGrenade", // RGO Grenade
	// "I_IR_Grenade", // IR Grenade [AAF]
	"MiniGrenade", // RGN Grenade
	"MiniGrenade", // RGN Grenade
	// "O_IR_Grenade", // IR Grenade [CSAT]
	// "SmokeShell", // Smoke Grenade (White)
	"SmokeShellBlue", // Smoke Grenade (Blue)
	"SmokeShellGreen", // Smoke Grenade (Green)
	// "SmokeShellOrange", // Smoke Grenade (Orange)
	// "SmokeShellPurple", // Smoke Grenade (Purple)
	"SmokeShellRed", // Smoke Grenade (Red)
	// "SmokeShellYellow" // Smoke Grenade (Yellow)
	"Chemlight_blue", // Chemlight (Blue)
	"Chemlight_green", // Chemlight (Green)
	"Chemlight_red" // Chemlight (Red)
	// "Chemlight_yellow", // Chemlight (Yellow)
];

_muzzles =
[
	"muzzle_snds_338_black", // Sound Suppressor (.338, Black)
	"muzzle_snds_338_green", // Sound Suppressor (.338, Green)
	"muzzle_snds_338_sand", // Sound Suppressor (.338, Sand)
	"muzzle_snds_58_blk_F", // Stealth Sound Suppressor (5.8 mm, Black)
	"muzzle_snds_58_ghex_F", // Stealth Sound Suppressor (5.8 mm, Green Hex)
	"muzzle_snds_58_hex_F", // Sound Suppressor (5.8 mm, Hex)
	"muzzle_snds_65_TI_blk_F", // Stealth Sound Suppressor (6.5 mm, Black)
	"muzzle_snds_65_TI_ghex_F", // Stealth Sound Suppressor (6.5 mm, Green Hex)
	"muzzle_snds_65_TI_hex_F", // Stealth Sound Suppressor (6.5 mm, Hex)
	"muzzle_snds_93mmg", // Sound Suppressor (9.3mm, Black)
	"muzzle_snds_93mmg_tan", // Sound Suppressor (9.3mm, Tan)
	"muzzle_snds_acp", // Sound Suppressor (.45 ACP)
	"muzzle_snds_B", // Sound Suppressor (7.62 mm)
	"muzzle_snds_B_khk_F", // Sound Suppressor (7.62 mm, Khaki)
	"muzzle_snds_B_snd_F", // Sound Suppressor (7.62 mm, Sand)
	"muzzle_snds_H", // Sound Suppressor (6.5 mm)
	"muzzle_snds_H_khk_F", // Sound Suppressor (6.5 mm, Khaki)
	"muzzle_snds_H_snd_F", // Sound Suppressor (6.5 mm, Sand)
	"muzzle_snds_L", // Sound Suppressor (9 mm)
	"muzzle_snds_M", // Sound Suppressor (5.56 mm)
	"muzzle_snds_m_khk_F", // Sound Suppressor (5.56 mm, Khaki)
	"muzzle_snds_m_snd_F" // Sound Suppressor (5.56 mm, Sand)
];

_optics =
[
	"optic_Aco", // ACO (Red)
	"optic_ACO_grn", // ACO (Green)
	"optic_ACO_grn_smg", // ACO SMG (Green)
	"optic_Aco_smg", // ACO SMG (Red)
	"optic_AMS", // AMS (Black)
	"optic_AMS_khk", // AMS (Khaki)
	"optic_AMS_snd", // AMS (Sand)
	"optic_Arco", // ARCO
	"optic_Arco_blk_F", // ARCO (Black)
	"optic_Arco_ghex_F", // ARCO (Green Hex)
	"optic_DMS", // DMS
	"optic_DMS_ghex_F", // DMS (Green Hex)
	"optic_ERCO_blk_F", // ERCO (Black)
	"optic_ERCO_khk_F", // ERCO (Khaki)
	"optic_ERCO_snd_F", // ERCO (Sand)
	"optic_Hamr", // RCO
	"optic_Hamr_khk_F", // RCO (Khaki)
	"optic_Holosight", // Mk17 Holosight
	"optic_Holosight_blk_F", // Mk17 Holosight (Black)
	"optic_Holosight_khk_F", // Mk17 Holosight (Khaki)
	"optic_Holosight_smg", // Mk17 Holosight SMG
	"optic_Holosight_smg_blk_F", // Mk17 Holosight SMG (Black)
	"optic_KHS_blk", // Kahlia (Black)
	"optic_KHS_hex", // Kahlia (Hex)
	"optic_KHS_old", // Kahlia (Old)
	"optic_KHS_tan", // Kahlia (Tan)
	"optic_LRPS", // LRPS
	"optic_LRPS_ghex_F", // LRPS (Green Hex)
	"optic_LRPS_tna_F", // LRPS (Tropic)
	"optic_MRCO", // MRCO
	"optic_MRD", // MRD
	"optic_Nightstalker", // Nightstalker
	"optic_NVS", // NVS
	"optic_SOS", // MOS
	"optic_SOS_khk_F", // MOS (Khaki)
	"optic_tws", // TWS
	"optic_tws_mg", // TWS MG
	"optic_Yorris" // Yorris J2
];

_primaryWeapons =
[
	"arifle_AK12_F", // AK-12 7.62 mm
	"arifle_AK12_GL_F", // AK-12 GL 7.62 mm
	"arifle_AKM_F", // AKM 7.62 mm
	"arifle_AKS_F", // AKS-74U 5.45 mm
	"arifle_ARX_blk_F", // Type 115 6.5 mm (Black)
	"arifle_ARX_ghex_F", // Type 115 6.5 mm (Green Hex)
	"arifle_ARX_hex_F", // Type 115 6.5 mm (Hex)
	"arifle_CTARS_blk_F", // CAR-95-1 5.8mm (Black)
	"arifle_CTARS_blk_Pointer_F", // CAR-95-1 5.8mm (Black)
	"arifle_CTARS_ghex_F", // CAR-95-1 5.8mm (Green Hex)
	"arifle_CTARS_hex_F", // CAR-95-1 5.8mm (Hex)
	"arifle_CTAR_blk_ACO_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_ACO_Pointer_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_ACO_Pointer_Snds_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_ARCO_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_ARCO_Pointer_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_ARCO_Pointer_Snds_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_Pointer_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_ghex_F", // CAR-95 5.8 mm (Green Hex)
	"arifle_CTAR_GL_blk_ACO_F", // CAR-95 GL 5.8 mm (Black)
	"arifle_CTAR_GL_blk_ACO_Pointer_Snds_F", // CAR-95 GL 5.8 mm (Black)
	"arifle_CTAR_GL_blk_F", // CAR-95 GL 5.8 mm (Black)
	"arifle_CTAR_GL_ghex_F", // CAR-95 GL 5.8 mm (Green Hex)
	"arifle_CTAR_GL_hex_F", // CAR-95 GL 5.8 mm (Hex)
	"arifle_CTAR_hex_F", // CAR-95 5.8 mm (Hex)
	"arifle_Katiba_ACO_F", // Katiba 6.5 mm
	"arifle_Katiba_ACO_pointer_F", // Katiba 6.5 mm
	"arifle_Katiba_ACO_pointer_snds_F", // Katiba 6.5 mm
	"arifle_Katiba_ARCO_F", // Katiba 6.5 mm
	"arifle_Katiba_ARCO_pointer_F", // Katiba 6.5 mm
	"arifle_Katiba_ARCO_pointer_snds_F", // Katiba 6.5 mm
	"arifle_Katiba_C_ACO_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_C_ACO_pointer_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_C_ACO_pointer_snds_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_C_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_F", // Katiba 6.5 mm
	"arifle_Katiba_GL_ACO_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_ACO_pointer_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_ACO_pointer_snds_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_ARCO_pointer_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_Nstalker_pointer_F", // Katiba GL 6.5 mm
	"arifle_Katiba_pointer_F", // Katiba 6.5 mm
	"arifle_Mk20C_ACO_F", // Mk20C 5.56 mm (Camo)
	"arifle_Mk20C_ACO_pointer_F", // Mk20C 5.56 mm (Camo)
	"arifle_Mk20C_F", // Mk20C 5.56 mm (Camo)
	"arifle_Mk20C_plain_F", // Mk20C 5.56 mm
	"arifle_Mk20_ACO_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_ACO_pointer_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_GL_ACO_F", // Mk20 EGLM 5.56 mm (Camo)
	"arifle_Mk20_GL_F", // Mk20 EGLM 5.56 mm (Camo)
	"arifle_Mk20_GL_MRCO_pointer_F", // Mk20 EGLM 5.56 mm (Camo)
	"arifle_Mk20_GL_plain_F", // Mk20 EGLM 5.56 mm
	"arifle_Mk20_Holo_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_MRCO_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_MRCO_plain_F", // Mk20 5.56 mm
	"arifle_Mk20_MRCO_pointer_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_plain_F", // Mk20 5.56 mm
	"arifle_Mk20_pointer_F", // Mk20 5.56 mm (Camo)
	"arifle_MXC_ACO_F", // MXC 6.5 mm
	"arifle_MXC_ACO_pointer_F", // MXC 6.5 mm
	"arifle_MXC_ACO_pointer_snds_F", // MXC 6.5 mm
	"arifle_MXC_Black_F", // MXC 6.5 mm (Black)
	"arifle_MXC_F", // MXC 6.5 mm
	"arifle_MXC_Holo_F", // MXC 6.5 mm
	"arifle_MXC_Holo_pointer_F", // MXC 6.5 mm
	"arifle_MXC_Holo_pointer_snds_F", // MXC 6.5 mm
	"arifle_MXC_khk_ACO_F", // MXC 6.5 mm (Khaki)
	"arifle_MXC_khk_ACO_Pointer_Snds_F", // MXC 6.5 mm (Khaki)
	"arifle_MXC_khk_F", // MXC 6.5 mm (Khaki)
	"arifle_MXC_khk_Holo_Pointer_F", // MXC 6.5 mm (Khaki)
	"arifle_MXC_SOS_point_snds_F", // MXC 6.5 mm
	"arifle_MXM_Black_F", // MXM 6.5 mm (Black)
	"arifle_MXM_DMS_F", // MXM 6.5 mm
	"arifle_MXM_DMS_LP_BI_snds_F", // MXM 6.5 mm
	"arifle_MXM_F", // MXM 6.5 mm
	"arifle_MXM_Hamr_LP_BI_F", // MXM 6.5 mm
	"arifle_MXM_Hamr_pointer_F", // MXM 6.5 mm
	"arifle_MXM_khk_F", // MXM 6.5 mm (Khaki)
	"arifle_MXM_khk_MOS_Pointer_Bipod_F", // MXM 6.5 mm (Khaki)
	"arifle_MXM_RCO_pointer_snds_F", // MXM 6.5 mm
	"arifle_MXM_SOS_pointer_F", // MXM 6.5 mm
	"arifle_MX_ACO_F", // MX 6.5 mm
	"arifle_MX_ACO_pointer_F", // MX 6.5 mm
	"arifle_MX_ACO_pointer_snds_F", // MX 6.5 mm
	"arifle_MX_Black_F", // MX 6.5 mm (Black)
	"arifle_MX_Black_Hamr_pointer_F", // MX 6.5 mm (Black)
	"arifle_MX_F", // MX 6.5 mm
	"arifle_MX_GL_ACO_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_ACO_pointer_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_Black_F", // MX 3GL 6.5 mm (Black)
	"arifle_MX_GL_Black_Hamr_pointer_F", // MX 3GL 6.5 mm (Black)
	"arifle_MX_GL_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_Hamr_pointer_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_Holo_pointer_snds_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_khk_ACO_F", // MX 3GL 6.5 mm (Khaki)
	"arifle_MX_GL_khk_F", // MX 3GL 6.5 mm (Khaki)
	"arifle_MX_GL_khk_Hamr_Pointer_F", // MX 3GL 6.5 mm (Khaki)
	"arifle_MX_GL_khk_Holo_Pointer_Snds_F", // MX 3GL 6.5 mm (Khaki)
	"arifle_MX_Hamr_pointer_F", // MX 6.5 mm
	"arifle_MX_Holo_pointer_F", // MX 6.5 mm
	"arifle_MX_khk_ACO_Pointer_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_ACO_Pointer_Snds_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_Hamr_Pointer_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_Hamr_Pointer_Snds_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_Holo_Pointer_F", // MX 6.5 mm (Khaki)
	"arifle_MX_khk_Pointer_F", // MX 6.5 mm (Khaki)
	"arifle_MX_pointer_F", // MX 6.5 mm
	"arifle_MX_RCO_pointer_snds_F", // MX 6.5 mm
	"arifle_MX_SW_Black_F", // MX SW 6.5 mm (Black)
	"arifle_MX_SW_Black_Hamr_pointer_F", // MX SW 6.5 mm (Black)
	"arifle_MX_SW_F", // MX SW 6.5 mm
	"arifle_MX_SW_Hamr_pointer_F", // MX SW 6.5 mm
	"arifle_MX_SW_khk_F", // MX SW 6.5 mm (Khaki)
	"arifle_MX_SW_khk_Pointer_F", // MX SW 6.5 mm (Khaki)
	"arifle_MX_SW_pointer_F", // MX SW 6.5 mm
	"arifle_SDAR_F", // SDAR 5.56 mm
	"arifle_SPAR_01_blk_F", // SPAR-16 5.56 mm (Black)
	"arifle_SPAR_01_GL_blk_F", // SPAR-16 GL 5.56 mm (Black)
	"arifle_SPAR_01_GL_khk_F", // SPAR-16 GL 5.56 mm (Khaki)
	"arifle_SPAR_01_GL_snd_F", // SPAR-16 GL 5.56 mm (Sand)
	"arifle_SPAR_01_khk_F", // SPAR-16 5.56 mm (Khaki)
	"arifle_SPAR_01_snd_F", // SPAR-16 5.56 mm (Sand)
	"arifle_SPAR_02_blk_F", // SPAR-16S 5.56 mm (Black)
	"arifle_SPAR_02_khk_F", // SPAR-16S 5.56 mm (Khaki)
	"arifle_SPAR_02_snd_F", // SPAR-16S 5.56 mm (Sand)
	"arifle_SPAR_03_blk_F", // SPAR-17 7.62 mm (Black)
	"arifle_SPAR_03_khk_F", // SPAR-17 7.62 mm (Khaki)
	"arifle_SPAR_03_snd_F", // SPAR-17 7.62 mm (Sand)
	"arifle_TRG20_ACO_F", // TRG-20 5.56 mm
	"arifle_TRG20_ACO_Flash_F", // TRG-20 5.56 mm
	"arifle_TRG20_ACO_pointer_F", // TRG-20 5.56 mm
	"arifle_TRG20_F", // TRG-20 5.56 mm
	"arifle_TRG20_Holo_F", // TRG-20 5.56 mm
	"arifle_TRG21_ACO_pointer_F", // TRG-21 5.56 mm
	"arifle_TRG21_ARCO_pointer_F", // TRG-21 5.56 mm
	"arifle_TRG21_F", // TRG-21 5.56 mm
	"arifle_TRG21_GL_ACO_pointer_F", // TRG-21 EGLM 5.56 mm
	"arifle_TRG21_GL_F", // TRG-21 EGLM 5.56 mm
	"arifle_TRG21_GL_MRCO_F", // TRG-21 EGLM 5.56 mm
	"arifle_TRG21_MRCO_F", // TRG-21 5.56 mm
	"hgun_PDW2000_F", // PDW2000 9 mm
	"hgun_PDW2000_Holo_F", // PDW2000 9 mm
	"hgun_PDW2000_Holo_snds_F", // PDW2000 9 mm
	"hgun_PDW2000_snds_F", // PDW2000 9 mm
	"LMG_03_F", // LIM-85 5.56 mm
	"LMG_Mk200_BI_F", // Mk200 6.5 mm
	"LMG_Mk200_F", // Mk200 6.5 mm
	"LMG_Mk200_LP_BI_F", // Mk200 6.5 mm
	"LMG_Mk200_MRCO_F", // Mk200 6.5 mm
	"LMG_Mk200_pointer_F", // Mk200 6.5 mm
	"LMG_Zafir_ARCO_F", // Zafir 7.62 mm
	"LMG_Zafir_F", // Zafir 7.62 mm
	"LMG_Zafir_pointer_F", // Zafir 7.62 mm
	"MMG_01_hex_ARCO_LP_F", // Navid 9.3 mm (Hex)
	"MMG_01_hex_F", // Navid 9.3 mm (Hex)
	"MMG_01_tan_F", // Navid 9.3 mm (Tan)
	"MMG_02_black_F", // SPMG .338 (Black)
	"MMG_02_black_RCO_BI_F", // SPMG .338 (Black)
	"MMG_02_camo_F", // SPMG .338 (MTP)
	"MMG_02_sand_F", // SPMG .338 (Sand)
	"MMG_02_sand_RCO_LP_F", // SPMG .338 (Sand)
	"SMG_01_ACO_F", // Vermin SMG .45 ACP
	"SMG_01_F", // Vermin SMG .45 ACP
	"SMG_01_Holo_F", // Vermin SMG .45 ACP
	"SMG_01_Holo_pointer_snds_F", // Vermin SMG .45 ACP
	"SMG_02_ACO_F", // Sting 9 mm
	"SMG_02_ARCO_pointg_F", // Sting 9 mm
	"SMG_02_F", // Sting 9 mm
	"SMG_05_F", // Protector 9 mm
	"srifle_DMR_01_ACO_F", // Rahim 7.62 mm
	"srifle_DMR_01_ARCO_F", // Rahim 7.62 mm
	"srifle_DMR_01_DMS_BI_F", // Rahim 7.62 mm
	"srifle_DMR_01_DMS_F", // Rahim 7.62 mm
	"srifle_DMR_01_DMS_snds_BI_F", // Rahim 7.62 mm
	"srifle_DMR_01_DMS_snds_F", // Rahim 7.62 mm
	"srifle_DMR_01_F", // Rahim 7.62 mm
	"srifle_DMR_01_MRCO_F", // Rahim 7.62 mm
	"srifle_DMR_01_SOS_F", // Rahim 7.62 mm
	"srifle_DMR_02_ACO_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_ARCO_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_camo_AMS_LP_F", // MAR-10 .338 (Camo)
	"srifle_DMR_02_camo_F", // MAR-10 .338 (Camo)
	"srifle_DMR_02_DMS_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_MRCO_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_sniper_AMS_LP_S_F", // MAR-10 .338 (Sand)
	"srifle_DMR_02_sniper_F", // MAR-10 .338 (Sand)
	"srifle_DMR_02_SOS_F", // MAR-10 .338 (Black)
	"srifle_DMR_03_ACO_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_AMS_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_ARCO_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_DMS_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_DMS_snds_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_khaki_F", // Mk-I EMR 7.62 mm (Khaki)
	"srifle_DMR_03_MRCO_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_multicam_F", // Mk-I EMR 7.62 mm (Camo)
	"srifle_DMR_03_SOS_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_tan_AMS_LP_F", // Mk-I EMR 7.62 mm (Sand)
	"srifle_DMR_03_tan_F", // Mk-I EMR 7.62 mm (Sand)
	"srifle_DMR_03_woodland_F", // Mk-I EMR 7.62 mm (Woodland)
	"srifle_DMR_04_ACO_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_ARCO_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_DMS_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_MRCO_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_NS_LP_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_SOS_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_Tan_F", // ASP-1 Kir 12.7 mm (Tan)
	"srifle_DMR_05_ACO_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_ARCO_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_blk_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_DMS_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_DMS_snds_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_hex_F", // Cyrus 9.3 mm (Hex)
	"srifle_DMR_05_KHS_LP_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_MRCO_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_SOS_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_tan_f", // Cyrus 9.3 mm (Tan)
	"srifle_DMR_06_camo_F", // Mk14 7.62 mm (Camo)
	"srifle_DMR_06_camo_khs_F", // Mk14 7.62 mm (Camo)
	"srifle_DMR_06_olive_F", // Mk14 7.62 mm (Olive)
	"srifle_DMR_07_blk_DMS_F", // CMR-76 6.5 mm (Black)
	"srifle_DMR_07_blk_DMS_Snds_F", // CMR-76 6.5 mm (Black)
	"srifle_DMR_07_blk_F", // CMR-76 6.5 mm (Black)
	"srifle_DMR_07_ghex_F", // CMR-76 6.5 mm (Green Hex)
	"srifle_DMR_07_hex_F", // CMR-76 6.5 mm (Hex)
	"srifle_EBR_ACO_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_ARCO_pointer_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_ARCO_pointer_snds_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_DMS_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_DMS_pointer_snds_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_Hamr_pointer_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_MRCO_LP_BI_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_MRCO_pointer_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_SOS_F", // Mk18 ABR 7.62 mm
	"srifle_GM6_camo_F", // GM6 Lynx 12.7 mm (Camo)
	"srifle_GM6_camo_LRPS_F", // GM6 Lynx 12.7 mm (Camo)
	"srifle_GM6_camo_SOS_F", // GM6 Lynx 12.7 mm (Camo)
	"srifle_GM6_F", // GM6 Lynx 12.7 mm
	"srifle_GM6_ghex_F", // GM6 Lynx 12.7 mm (Green Hex)
	"srifle_GM6_ghex_LRPS_F", // GM6 Lynx 12.7 mm (Green Hex)
	"srifle_GM6_LRPS_F", // GM6 Lynx 12.7 mm
	"srifle_GM6_SOS_F", // GM6 Lynx 12.7 mm
	"srifle_LRR_camo_F", // M320 LRR .408 (Camo)
	"srifle_LRR_camo_LRPS_F", // M320 LRR .408 (Camo)
	"srifle_LRR_camo_SOS_F", // M320 LRR .408 (Camo)
	"srifle_LRR_F", // M320 LRR .408
	"srifle_LRR_LRPS_F", // M320 LRR .408
	"srifle_LRR_SOS_F", // M320 LRR .408
	"srifle_LRR_tna_F", // M320 LRR .408 (Tropic)
	"srifle_LRR_tna_LRPS_F" // M320 LRR .408 (Tropic)
];

_secondaryWeapons =
[
	"hgun_ACPC2_F", // ACP-C2 .45 ACP
	"hgun_ACPC2_snds_F", // ACP-C2 .45 ACP
	"hgun_P07_F", // P07 9 mm
	"hgun_P07_khk_F", // P07 9 mm (Khaki)
	"hgun_P07_snds_F", // P07 9 mm
	"hgun_Pistol_01_F", // PM 9 mm
	"hgun_Pistol_heavy_01_F", // 4-five .45 ACP
	"hgun_Pistol_heavy_01_MRD_F", // 4-five .45 ACP
	"hgun_Pistol_heavy_01_snds_F", // 4-five .45 ACP
	"hgun_Pistol_heavy_02_F", // Zubr .45 ACP
	"hgun_Pistol_heavy_02_Yorris_F", // Zubr .45 ACP
	"hgun_Pistol_Signal_F", // Starter Pistol
	"hgun_Rook40_F", // Rook-40 9 mm
	"hgun_Rook40_snds_F" // Rook-40 9 mm
];

_uniforms =
[
	"U_BG_Guerilla1_1", // Guerilla Garment
	"U_BG_Guerilla2_1", // Guerilla Outfit (Plain, Dark)
	"U_BG_Guerilla2_2", // Guerilla Outfit (Pattern)
	"U_BG_Guerilla2_3", // Guerilla Outfit (Plain, Light)
	"U_BG_Guerilla3_1", // Guerilla Smocks
	"U_BG_Guerrilla_6_1", // Guerilla Apparel
	"U_BG_leader", // Guerilla Uniform
	"U_B_CombatUniform_mcam", // Combat Fatigues (MTP)
	"U_B_CombatUniform_mcam_tshirt", // Combat Fatigues (MTP) (Tee)
	"U_B_CombatUniform_mcam_vest", // Recon Fatigues (MTP)
	"U_B_CombatUniform_mcam_worn", // Worn Combat Fatigues (MTP)
	"U_B_CTRG_1", // CTRG Combat Uniform
	"U_B_CTRG_2", // CTRG Combat Uniform (Tee)
	"U_B_CTRG_3", // CTRG Combat Uniform (Rolled-up)
	"U_B_CTRG_Soldier_2_F", // CTRG Stealth Uniform (Tee)
	"U_B_CTRG_Soldier_3_F", // CTRG Stealth Uniform (Rolled-up)
	"U_B_CTRG_Soldier_F", // CTRG Stealth Uniform
	"U_B_CTRG_Soldier_urb_1_F", // CTRG Urban Uniform
	"U_B_CTRG_Soldier_urb_2_F", // CTRG Urban Uniform (Tee)
	"U_B_CTRG_Soldier_urb_3_F", // CTRG Urban Uniform (Rolled-up)
	"U_B_FullGhillie_ard", // Full Ghillie (Arid) [NATO]
	"U_B_FullGhillie_lsh", // Full Ghillie (Lush) [NATO]
	"U_B_FullGhillie_sard", // Full Ghillie (Semi-Arid) [NATO]
	"U_B_GEN_Commander_F", // Gendarmerie Commander Uniform
	"U_B_GEN_Soldier_F", // Gendarmerie Uniform
	"U_B_GhillieSuit", // Ghillie Suit [NATO]
	"U_B_HeliPilotCoveralls", // Heli Pilot Coveralls [NATO]
	"U_B_PilotCoveralls", // Pilot Coveralls [NATO]
	"U_B_Protagonist_VR", // VR Suit [NATO]
	"U_B_survival_uniform", // Survival Fatigues
	"U_B_T_FullGhillie_tna_F", // Full Ghillie (Jungle) [NATO]
	"U_B_T_Sniper_F", // Ghillie Suit (Tropic) [NATO]
	"U_B_T_Soldier_AR_F", // Combat Fatigues (Tropic, Tee)
	"U_B_T_Soldier_F", // Combat Fatigues (Tropic)
	"U_B_T_Soldier_SL_F", // Recon Fatigues (Tropic)
	"U_B_Wetsuit", // Wetsuit [NATO]
	// "U_Competitor", // Competitor Suit
	// "U_C_Driver_1", // Driver Coverall (Fuel)
	// "U_C_Driver_1_black", // Driver Coverall (Black)
	// "U_C_Driver_1_blue", // Driver Coverall (Blue)
	// "U_C_Driver_1_green", // Driver Coverall (Green)
	// "U_C_Driver_1_orange", // Driver Coverall (Orange)
	// "U_C_Driver_1_red", // Driver Coverall (Red)
	// "U_C_Driver_1_white", // Driver Coverall (White)
	// "U_C_Driver_1_yellow", // Driver Coverall (Yellow)
	// "U_C_Driver_2", // Driver Coverall (Bluking)
	// "U_C_Driver_3", // Driver Coverall (Redstone)
	// "U_C_Driver_4", // Driver Coverall (Vrana)
	// "U_C_HunterBody_grn", // Hunting Clothes
	// "U_C_Journalist", // Journalist Clothes
	// "U_C_Man_casual_1_F", // Casual Clothes (Navy)
	// "U_C_Man_casual_2_F", // Casual Clothes (Blue)
	// "U_C_Man_casual_3_F", // Casual Clothes (Green)
	// "U_C_Man_casual_4_F", // Summer Clothes (Sky)
	// "U_C_Man_casual_5_F", // Summer Clothes (Yellow)
	// "U_C_Man_casual_6_F", // Summer Clothes (Red)
	// "U_C_man_sport_1_F", // Sport Clothes (Beach)
	// "U_C_man_sport_2_F", // Sport Clothes (Orange)
	// "U_C_man_sport_3_F", // Sport Clothes (Blue)
	// "U_C_Poloshirt_blue", // Commoner Clothes (Blue)
	// "U_C_Poloshirt_burgundy", // Commoner Clothes (Burgundy)
	// "U_C_Poloshirt_redwhite", // Commoner Clothes (Red-White)
	// "U_C_Poloshirt_salmon", // Commoner Clothes (Salmon)
	// "U_C_Poloshirt_stripped", // Commoner Clothes (Striped)
	// "U_C_Poloshirt_tricolour", // Commoner Clothes (Tricolor)
	// "U_C_Poor_1", // Worn Clothes
	// "U_C_Scientist", // Scientist Clothes
	// "U_C_WorkerCoveralls", // Worker Coveralls
	"U_I_CombatUniform", // Combat Fatigues [AAF]
	"U_I_CombatUniform_shortsleeve", // Combat Fatigues [AAF] (Rolled-up)
	// "U_I_C_Soldier_Bandit_1_F", // Bandit Clothes (Polo Shirt)
	// "U_I_C_Soldier_Bandit_2_F", // Bandit Clothes (Skull)
	// "U_I_C_Soldier_Bandit_3_F", // Bandit Clothes (Tee)
	// "U_I_C_Soldier_Bandit_4_F", // Bandit Clothes (Checkered)
	// "U_I_C_Soldier_Bandit_5_F", // Bandit Clothes (Tank Top)
	"U_I_C_Soldier_Camo_F", // Syndikat Uniform
	"U_I_C_Soldier_Para_1_F", // Paramilitary Garb (Tee)
	"U_I_C_Soldier_Para_2_F", // Paramilitary Garb (Jacket)
	"U_I_C_Soldier_Para_3_F", // Paramilitary Garb (Shirt)
	"U_I_C_Soldier_Para_4_F", // Paramilitary Garb (Tank Top)
	"U_I_C_Soldier_Para_5_F", // Paramilitary Garb (Shorts)
	"U_I_FullGhillie_ard", // Full Ghillie (Arid) [AAF]
	"U_I_FullGhillie_lsh", // Full Ghillie (Lush) [AAF]
	"U_I_FullGhillie_sard", // Full Ghillie (Semi-Arid) [AAF]
	"U_I_GhillieSuit", // Ghillie Suit [AAF]
	"U_I_G_resistanceLeader_F", // Combat Fatigues (Stavrou)
	// "U_I_G_Story_Protagonist_F", // Worn Combat Fatigues (Kerry)
	"U_I_HeliPilotCoveralls", // Heli Pilot Coveralls [AAF]
	"U_I_OfficerUniform", // Combat Fatigues [AAF] (Officer)
	"U_I_pilotCoveralls", // Pilot Coveralls [AAF]
	"U_I_Protagonist_VR", // VR Suit [AAF]
	"U_I_Wetsuit", // Wetsuit [AAF]
	// "U_Marshal", // Marshal Clothes
	// "U_OrestesBody", // Jacket and Shorts
	"U_O_CombatUniform_ocamo", // Fatigues (Hex) [CSAT]
	"U_O_CombatUniform_oucamo", // Fatigues (Urban) [CSAT]
	"U_O_FullGhillie_ard", // Full Ghillie (Arid) [CSAT]
	"U_O_FullGhillie_lsh", // Full Ghillie (Lush) [CSAT]
	"U_O_FullGhillie_sard", // Full Ghillie (Semi-Arid) [CSAT]
	"U_O_GhillieSuit", // Ghillie Suit [CSAT]
	"U_O_OfficerUniform_ocamo", // Officer Fatigues (Hex)
	"U_O_PilotCoveralls", // Pilot Coveralls [CSAT]
	"U_O_Protagonist_VR", // VR Suit [CSAT]
	"U_O_SpecopsUniform_ocamo", // Recon Fatigues (Hex)
	"U_O_T_FullGhillie_tna_F", // Full Ghillie (Jungle) [CSAT]
	"U_O_T_Officer_F", // Officer Fatigues (Green Hex) [CSAT]
	"U_O_T_Sniper_F", // Ghillie Suit (Green Hex) [CSAT]
	"U_O_T_Soldier_F", // Fatigues (Green Hex) [CSAT]
	"U_O_V_Soldier_Viper_F", // Special Purpose Suit (Green Hex)
	"U_O_V_Soldier_Viper_hex_F", // Special Purpose Suit (Hex)
	"U_O_Wetsuit", // Wetsuit [CSAT]
	"U_Rangemaster" // Rangemaster Suit
];

_vests =
[
	"V_BandollierB_blk", // Slash Bandolier (Black)
	"V_BandollierB_cbr", // Slash Bandolier (Coyote)
	"V_BandollierB_ghex_F", // Slash Bandolier (Green Hex)
	"V_BandollierB_khk", // Slash Bandolier (Khaki)
	"V_BandollierB_oli", // Slash Bandolier (Olive)
	"V_BandollierB_rgr", // Slash Bandolier (Green)
	"V_Chestrig_blk", // Chest Rig (Black)
	"V_Chestrig_khk", // Chest Rig (Khaki)
	"V_Chestrig_oli", // Chest Rig (Olive)
	"V_Chestrig_rgr", // Chest Rig (Green)
	"V_HarnessOGL_brn", // LBV Grenadier Harness
	"V_HarnessOGL_ghex_F", // LBV Grenadier Harness (Green Hex)
	"V_HarnessOGL_gry", // LBV Grenadier Harness (Grey)
	"V_HarnessO_brn", // LBV Harness
	"V_HarnessO_ghex_F", // LBV Harness (Green Hex)
	"V_HarnessO_gry", // LBV Harness (Grey)
	"V_I_G_resistanceLeader_F", // Tactical Vest (Stavrou)
	"V_PlateCarrier1_blk", // Carrier Lite (Black)
	"V_PlateCarrier1_rgr", // Carrier Lite (Green)
	"V_PlateCarrier1_rgr_noflag_F", // Carrier Lite (Green, No Flag)
	"V_PlateCarrier1_tna_F", // Carrier Lite (Tropic)
	"V_PlateCarrier2_blk", // Carrier Rig (Black)
	"V_PlateCarrier2_rgr", // Carrier Rig (Green)
	"V_PlateCarrier2_rgr_noflag_F", // Carrier Rig (Green, No Flag)
	"V_PlateCarrier2_tna_F", // Carrier Rig (Tropic)
	"V_PlateCarrierGL_blk", // Carrier GL Rig (Black)
	"V_PlateCarrierGL_mtp", // Carrier GL Rig (MTP)
	"V_PlateCarrierGL_rgr", // Carrier GL Rig (Green)
	"V_PlateCarrierGL_tna_F", // Carrier GL Rig (Tropic)
	"V_PlateCarrierH_CTRG", // CTRG Plate Carrier Rig Mk.2 (Heavy)
	"V_PlateCarrierIA1_dgtl", // GA Carrier Lite (Digi)
	"V_PlateCarrierIA2_dgtl", // GA Carrier Rig (Digi)
	"V_PlateCarrierIAGL_dgtl", // GA Carrier GL Rig (Digi)
	"V_PlateCarrierIAGL_oli", // GA Carrier GL Rig (Olive)
	"V_PlateCarrierL_CTRG", // CTRG Plate Carrier Rig Mk.1 (Light)
	"V_PlateCarrierSpec_blk", // Carrier Special Rig (Black)
	"V_PlateCarrierSpec_mtp", // Carrier Special Rig (MTP)
	"V_PlateCarrierSpec_rgr", // Carrier Special Rig (Green)
	"V_PlateCarrierSpec_tna_F", // Carrier Special Rig (Tropic)
	"V_PlateCarrier_Kerry", // US Plate Carrier Rig (Kerry)
	// "V_Press_F", // Vest (Press)
	"V_Rangemaster_belt", // Rangemaster Belt
	"V_RebreatherB", // Rebreather [NATO]
	"V_RebreatherIA", // Rebreather [AAF]
	"V_RebreatherIR", // Rebreather [CSAT]
	"V_TacChestrig_cbr_F", // Tactical Chest Rig (Coyote)
	"V_TacChestrig_grn_F", // Tactical Chest Rig (Green)
	"V_TacChestrig_oli_F", // Tactical Chest Rig (Olive)
	"V_TacVestIR_blk", // Raven Vest
	"V_TacVest_blk", // Tactical Vest (Black)
	// "V_TacVest_blk_POLICE", // Tactical Vest (Police)
	"V_TacVest_brn", // Tactical Vest (Brown)
	"V_TacVest_camo", // Tactical Vest (Camo)
	"V_TacVest_gen_F", // Gendarmerie Vest
	"V_TacVest_khk", // Tactical Vest (Khaki)
	"V_TacVest_oli" // Tactical Vest (Olive)
];
	
_weaponAccessories =
[
	"acc_flashlight", // Flashlight
	"acc_pointer_IR" // IR Laser Pointer
];

_mines =
[
	"APERSBoundingMine_Range_Mag", // APERS Bounding Mine
	"APERSMine_Range_Mag", // APERS Mine
	"APERSTripMine_Wire_Mag", // APERS Tripwire Mine
	"ATMine_Range_Mag", // AT Mine
	"ClaymoreDirectionalMine_Remote_Mag", // Claymore Charge
	"DemoCharge_Remote_Mag", // Explosive Charge
	"IEDLandBig_Remote_Mag", // Large IED (Dug-in)
	"IEDLandSmall_Remote_Mag", // Small IED (Dug-in)
	"IEDUrbanBig_Remote_Mag", // Large IED (Urban)
	"IEDUrbanSmall_Remote_Mag", // Small IED (Urban)
	"SatchelCharge_Remote_Mag", // Explosive Satchel
	"SLAMDirectionalMine_Wire_Mag" // M6 SLAM Mine
];

_goggles =
[
	"G_B_Diving", // Diving Goggles [NATO]
	"G_Balaclava_blk", // Balaclava (Black)
	"G_Balaclava_combat", // Balaclava (Combat Goggles)
	"G_Balaclava_lowprofile", // Balaclava (Low Profile Goggles)
	"G_Balaclava_oli", // Balaclava (Olive)
	"G_Balaclava_TI_blk_F", // Stealth Balaclava (Black)
	"G_Balaclava_TI_G_blk_F", // Stealth Balaclava (Black, Goggles)
	"G_Balaclava_TI_G_tna_F", // Stealth Balaclava (Green, Goggles)
	"G_Balaclava_TI_tna_F", // Stealth Balaclava (Green)
	"G_Combat", // Combat Goggles
	"G_Combat_Goggles_tna_F", // Combat Goggles (Green)
	"G_Diving", // Diving Goggles
	"G_Lowprofile" // "Low Profile Goggles
];

_overallLoopAmount = floor (round (random 8) + 2); // minimum 2, maximum 10

_backPackAmount = floor (round (random 3) + 3); // minimum 3, maximum 6
_binocularAmount = floor (round (random 5) + 2); // minimum 3, maximum 7
_bipodAmount = floor (round (random 3) + 2); // minimum 2, maximum 5
_headGearAmount = floor (round (random 3) + 5); // minimum 5, maximum 8
_itemAmount = floor (round (random 3) + 5); // minimum 5, maximum 8
_launcherAmount = floor (round (random 3) + 2); // minimum 2, maximum 5
_magazineAmount = floor (round (random 5) + 5); // minimum 5, maximum 10
_throwableAmount = floor (round (random 3) + 3); // minimum 3, maximum 6
_muzzleAmount = floor (round (random 2) + 2); // minimum 2, maximum 4
_opticAmount = floor (round (random 4) + 5); // minimum 5, maximum 9
_primaryWeaponAmount = floor (round (random 5) + 5); // minimum 5, maximum 10
_secondaryWeaponAmount = floor (round (random 3) + 2); // minimum 2, maximum 5
_uniformAmount = floor (round (random 4) + 3); // minimum 3, maximum 7
_vestAmount = floor (round (random 4) + 3); // minimum 3, maximum 7
_weaponAccessoryAmount = floor (round (random 3) + 2); // minimum 2, maximum 5
_minesAmount = floor (round (random 2) + 2); // minimum 2, maximum 4
_goggleAmount = floor (round (random 2) + 2); // minimum 2, maximum 4

_loadCrateWithWhatArray =
[
	"_backPacks",
	"_binoculars",
	"_bipods",
	"_headGear",
	"_items",
	"_launcherWeapons",
	"_magazines",
	"_throwables",
	"_muzzles",
	"_optics",
	"_primaryWeapons",
	"_secondaryWeapons",
	"_uniforms",
	"_vests",
	"_weaponAccessories",
	"_mines",
	"_goggles"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

params ["_crate"];

_crate allowDamage false;
_crate setVariable ["A3W_inventoryLockR3F", true, true];

clearBackpackCargoGlobal _crate;
clearMagazineCargoGlobal _crate;
clearWeaponCargoGlobal _crate;
clearItemCargoGlobal _crate;

_loadCrateAmount = 0;
_loadCrateWithWhat = "";

#ifdef __DEBUG__
	diag_log "----------------------------------------------------";
#endif

for [{_i = 0},{_i < _overallLoopAmount},{_i = _i + 1}] do
{
	_loadCrateWithWhat = selectRandom _loadCrateWithWhatArray;
	
	#ifdef __DEBUG__
		diag_log format ["%1 -> %2",(_i + 1),_loadCrateWithWhat];
	#endif
	
	switch (_loadCrateWithWhat) do
	{
		case "_backPacks": {
			_loadCrateAmount = _backPackAmount;
			for [{_lootCount = 0 },{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _backPacks;
				_crate addBackpackCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_binoculars": {
			_loadCrateAmount = _binocularAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _binoculars;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_bipods": {
			_loadCrateAmount = _bipodAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _bipods;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_headGear": {
			_loadCrateAmount = _headGearAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _headGear;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif

			};
		};
		case "_items": {
			_loadCrateAmount = _itemAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _items;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif

			};
		};
		case "_launcherWeapons": {
			_loadCrateAmount = _launcherAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _launcherWeapons;
				_loadCrateLootMagazine = getArray (configFile / "CfgWeapons" / _loadCrateItem / "magazines");
				_loadCrateLootMagazineClass = selectRandom _loadCrateLootMagazine;
				_loadCrateLootMagazineNum = floor (round (random 4) + 2); // minimum 2, maximum 6
				_crate addMagazineCargoGlobal [_loadCrateLootMagazineClass, _loadCrateLootMagazineNum];
				_crate addWeaponCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2 with %3x %4 rockets",_loadCrateWithWhat,_loadCrateItem,_loadCrateLootMagazineNum,_loadCrateLootMagazineClass];
				#endif

			};
		};
		case "_magazines": {
			_loadCrateAmount = _magazineAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _magazines;
				_loadCrateLootMagazineNum = floor (round (random 4) + 2); // minimum 2, maximum 6
				_crate addMagazineCargoGlobal [_loadCrateItem, _loadCrateLootMagazineNum];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> %2x %3 magazines",_loadCrateWithWhat,_loadCrateLootMagazineNum,_loadCrateItem];
				#endif

			};
		};
		case "_throwables": {
			_loadCrateAmount = _throwableAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _throwables;
				_loadCrateLootMagazineNum = floor (round (random 8) + 2); // minimum 2, maximum 10
				_crate addMagazineCargoGlobal [_loadCrateItem, _loadCrateLootMagazineNum];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> %2x %3",_loadCrateWithWhat,_loadCrateLootMagazineNum,_loadCrateItem];
				#endif
			};
		};
		case "_muzzles": {
			_loadCrateAmount = _muzzleAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _muzzles;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_optics": {
			_loadCrateAmount = _opticAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _optics;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_primaryWeapons": {
			_loadCrateAmount = _primaryWeaponAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _primaryWeapons;
				_loadCrateLootMagazine = getArray (configFile / "CfgWeapons" / _loadCrateItem / "magazines");
				_loadCrateLootMagazineClass = selectRandom _loadCrateLootMagazine;
				_loadCrateLootMagazineNum = floor (round (random 6) + 4); // minimum 4, maximum 10
				_crate addMagazineCargoGlobal [_loadCrateLootMagazineClass, _loadCrateLootMagazineNum];
				_crate addWeaponCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2 with %3x %4 magazines",_loadCrateWithWhat,_loadCrateItem,_loadCrateLootMagazineNum,_loadCrateLootMagazineClass];
				#endif
			};
		};
		case "_secondaryWeapons": {
			_loadCrateAmount = _secondaryWeaponAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _secondaryWeapons;
				_loadCrateLootMagazine = getArray (configFile / "CfgWeapons" / _loadCrateItem / "magazines");
				_loadCrateLootMagazineClass = selectRandom _loadCrateLootMagazine;
				_loadCrateLootMagazineNum = floor (round (random 4) + 2); // minimum 2, maximum 6
				_crate addMagazineCargoGlobal [_loadCrateLootMagazineClass, _loadCrateLootMagazineNum];
				_crate addWeaponCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2 with %3x %4 magazines",_loadCrateWithWhat,_loadCrateItem,_loadCrateLootMagazineNum,_loadCrateLootMagazineClass];
				#endif
			};
		};
		case "_uniforms": {
			_loadCrateAmount = _uniformAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _uniforms;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_vests": {
			_loadCrateAmount = _vestAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _vests;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_weaponAccessories": {
			_loadCrateAmount = _weaponAccessoryAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _weaponAccessories;
				_crate addItemCargoGlobal [_loadCrateItem, 1];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> 1x %2",_loadCrateWithWhat,_loadCrateItem];
				#endif
			};
		};
		case "_mines": {
			_loadCrateAmount = _minesAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _mines;
				_loadCrateLootMagazineNum = floor (round (random 2) + 2); // minimum 2, maximum 4
				_crate addMagazineCargoGlobal [_loadCrateItem, _loadCrateLootMagazineNum];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> %2x %3",_loadCrateWithWhat,_loadCrateLootMagazineNum,_loadCrateItem];
				#endif
			};
		};
		case "_goggles": {
			_loadCrateAmount = _goggleAmount;
			for [{_lootCount = 0},{_lootCount < _loadCrateAmount},{_lootCount = _lootCount + 1}] do
			{
				_loadCrateItem = selectRandom _goggles;
				_loadCrateLootMagazineNum = floor (round (random 2) + 2); // minimum 2, maximum 4
				_crate addItemCargoGlobal [_loadCrateItem, _loadCrateLootMagazineNum];
				#ifdef __DEBUG__
					diag_log format [" + %1 added -> %2x %3",_loadCrateWithWhat,_loadCrateLootMagazineNum,_loadCrateItem];
				#endif
			};
		};
	};
};
#ifdef __DEBUG__
	diag_log "----------------------------------------------------";
#endif
