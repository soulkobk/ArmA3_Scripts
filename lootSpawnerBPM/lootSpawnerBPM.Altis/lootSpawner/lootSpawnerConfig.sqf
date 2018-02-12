/*
	----------------------------------------------------------------------------------------------

	Copyright © 2018 soulkobk (soulkobk.blogspot.com)

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

	Name: lootSpawnerConfig.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 12:00 PM 03/02/2018

	Description:
	this was written by me (soulkobk) whilst i was learning how to code arma 3, so the code is unoptimized.
	the below compiled loot/class lists are OLD, so i would suggest you update to suit your needs.

	Parameter(s): none

	Example: none

	Change Log:
	1.0.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// use this if the current map has no marked buildings, overrides building debug markers!
_showMapBuildings = false;
// show markers on buildings found? (for debug purposes)
_showBuildings = false;
// show labels on buildings found? (for debug purposes)
_showBuildingsLabel = false;
// show labels on building positions found? (for debug purposes)
_showBuildingsPositions = false;
// show labels on loot spawned? (for debug purposes)
_showLoot = false;
// show hints? (for debug purposes)
_showHints = false;
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_buildingDamage = true; // true/false
_ls_buildingDamageProbability = 50; // percentage chance per position
_ls_openDoors = true; // true/false
_ls_openDoorsProbability = 50; // percentage chance per position
_ls_lootSpawn = true; // true/false
_ls_lootSpawnProbability = 25; // percentage chance per position
_ls_zeroBuildingPosLoops = 3; // number of automatic positions outside per building
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_buildingDamageExclusion =
[
	"Land_Offices_01_V1_F",
	"Land_MilOffices_V1_F"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_buildingExclusion =
[
	"",
	"AnchorX",
	"BuoyBig",
	"BuoySmall",
	"B_Soldier_F",
	"CubeHelper",
	"CustomWindAnomaly",
	"FxWindGrass1",
	"FxWindGrass2",
	"FxWindLeaf1",
	"FxWindLeaf2",
	"FxWindLeaf3",
	"FxWindPaper1",
	"FxWindPlastic1",
	"FxWindPollen1",
	"FxWindPollen2",
	"FxWindRock1",
	"HumpsDirt",
	"Land_BellTower_01_V1_F",
	"Land_Cargo40_military_green_F",
	"Land_Communication_anchor_F",
	"Land_Communication_F",
	"Land_CncBarrierMedium4_F",
	"Land_Flush_Light_green_F",
	"Land_Flush_Light_red_F",
	"Land_Flush_Light_yellow_F",
	"Land_FuelStation_Feed_F",
	"Land_HBarrierBig_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_2_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_4_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_Big_F",
	"Land_HelipadCircle_F",
	"Land_HelipadEmpty_F",
	"Land_HelipadSquare_F",
	"Land_HighVoltageColumn_F",
	"Land_HighVoltageColumnWire_F",
	"Land_LampAirport_F",
	"Land_LampDecor_F",
	"Land_LampHalogen_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_LampStreet_F",
	"Land_LampStreet_small_F",
	"Land_Lighthouse_small_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WiredFence_F",
	"Land_NavigLight",
	"Land_NavigLight_3_F",
	"Land_nav_pier_m_F",
	"Land_Net_Fence_Gate_F",
	"Land_New_WiredFence_10m_Dam_F",
	"Land_New_WiredFence_10m_F",
	"Land_New_WiredFence_5m_Dam_F",
	"Land_New_WiredFence_5m_F",
	"Land_Obsticle_Climb_F",
	"Land_Pier_Box_F",
	"Land_PierLadder_F",
	"Land_Pier_addon",
	"Land_Pier_F",
	"Land_Pier_small_F",
	"Land_PowerPoleWooden_F",
	"Land_PowerPoleWooden_L_F",
	"Land_Radar_Small_F",
	"Land_Razorwire_F",
	"Land_runway_edgelight",
	"Land_runway_edgelight_blue_F",
	"Land_Runway_PAPI",
	"Land_Runway_PAPI_2",
	"Land_Runway_PAPI_3",
	"Land_Runway_PAPI_4",
	"Land_Sea_Wall_F",
	"Land_Slums02_4m",
	"Land_spp_Mirror_F",
	"Land_spp_Mirror_ruins_F",
	"Land_spp_Transformer_F",
	"Land_Stone_Gate_F",
	"Land_TBox_F",
	"Land_TTowerBig_1_F",
	"Land_Wall_IndCnc_4_D_F",
	"Land_Wall_IndCnc_4_F",
	"Land_Wall_IndCnc_End_2_F",
	"Library_WeaponHolder",
	"Logic",
	"Obstacle_Cylinder1",
	"Obstacle_Jump1",
	"Obstacle_saddle",
	"Platform",
	"Rabbit_F",
	"RampConcrete",
	"RoadBarrier_light",
	"RoadCone",
	"ropeX",
	"Snake_random_F",
	"Man",
	"thingX"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_weaponHGLoot =
[
	"hgun_ACPC2_F", // ACP-C2 .45 ACP
	// "hgun_ACPC2_snds_F", // ACP-C2 .45 ACP
	"hgun_P07_F", // P07 9 mm
	// "hgun_P07_khk_F", // P07 9 mm (Khaki)
	// "hgun_P07_snds_F", // P07 9 mm
	"hgun_Pistol_01_F", // PM 9 mm
	"hgun_Pistol_heavy_01_F", // 4-five .45 ACP
	// "hgun_Pistol_heavy_01_MRD_F", // 4-five .45 ACP
	// "hgun_Pistol_heavy_01_snds_F", // 4-five .45 ACP
	"hgun_Pistol_heavy_02_F", // Zubr .45 ACP
	// "hgun_Pistol_heavy_02_Yorris_F", // Zubr .45 ACP
	// "hgun_Pistol_Signal_F", // Starter Pistol
	"hgun_Rook40_F", // Rook-40 9 mm
	"hgun_Rook40_snds_F" // Rook-40 9 mm
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_weaponHVLoot =
[
	// "srifle_DMR_01_ACO_F", // Rahim 7.62 mm
	// "srifle_DMR_01_ARCO_F", // Rahim 7.62 mm
	// "srifle_DMR_01_DMS_BI_F", // Rahim 7.62 mm
	// "srifle_DMR_01_DMS_F", // Rahim 7.62 mm
	// "srifle_DMR_01_DMS_snds_BI_F", // Rahim 7.62 mm
	// "srifle_DMR_01_DMS_snds_F", // Rahim 7.62 mm
	"srifle_DMR_01_F", // Rahim 7.62 mm
	// "srifle_DMR_01_MRCO_F", // Rahim 7.62 mm
	// "srifle_DMR_01_SOS_F", // Rahim 7.62 mm
	// "srifle_DMR_02_ACO_F", // MAR-10 .338 (Black)
	// "srifle_DMR_02_ARCO_F", // MAR-10 .338 (Black)
	// "srifle_DMR_02_camo_AMS_LP_F", // MAR-10 .338 (Camo)
	// "srifle_DMR_02_camo_F", // MAR-10 .338 (Camo)
	// "srifle_DMR_02_DMS_F", // MAR-10 .338 (Black)
	"srifle_DMR_02_F", // MAR-10 .338 (Black)
	// "srifle_DMR_02_MRCO_F", // MAR-10 .338 (Black)
	// "srifle_DMR_02_sniper_AMS_LP_S_F", // MAR-10 .338 (Sand)
	// "srifle_DMR_02_sniper_F", // MAR-10 .338 (Sand)
	// "srifle_DMR_02_SOS_F", // MAR-10 .338 (Black)
	// "srifle_DMR_03_ACO_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_AMS_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_ARCO_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_DMS_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_DMS_snds_F", // Mk-I EMR 7.62 mm (Black)
	"srifle_DMR_03_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_khaki_F", // Mk-I EMR 7.62 mm (Khaki)
	// "srifle_DMR_03_MRCO_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_multicam_F", // Mk-I EMR 7.62 mm (Camo)
	// "srifle_DMR_03_SOS_F", // Mk-I EMR 7.62 mm (Black)
	// "srifle_DMR_03_tan_AMS_LP_F", // Mk-I EMR 7.62 mm (Sand)
	// "srifle_DMR_03_tan_F", // Mk-I EMR 7.62 mm (Sand)
	// "srifle_DMR_03_woodland_F", // Mk-I EMR 7.62 mm (Woodland)
	// "srifle_DMR_04_ACO_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_ARCO_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_DMS_F", // ASP-1 Kir 12.7 mm (Black)
	"srifle_DMR_04_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_MRCO_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_NS_LP_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_SOS_F", // ASP-1 Kir 12.7 mm (Black)
	// "srifle_DMR_04_Tan_F", // ASP-1 Kir 12.7 mm (Tan)
	// "srifle_DMR_05_ACO_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_ARCO_F", // Cyrus 9.3 mm (Black)
	"srifle_DMR_05_blk_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_DMS_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_DMS_snds_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_hex_F", // Cyrus 9.3 mm (Hex)
	// "srifle_DMR_05_KHS_LP_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_MRCO_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_SOS_F", // Cyrus 9.3 mm (Black)
	// "srifle_DMR_05_tan_f", // Cyrus 9.3 mm (Tan)
	// "srifle_DMR_06_camo_F", // Mk14 7.62 mm (Camo)
	// "srifle_DMR_06_camo_khs_F", // Mk14 7.62 mm (Camo)
	"srifle_DMR_06_olive_F", // Mk14 7.62 mm (Olive)
	// "srifle_DMR_07_blk_DMS_F", // CMR-76 6.5 mm (Black)
	// "srifle_DMR_07_blk_DMS_Snds_F", // CMR-76 6.5 mm (Black)
	"srifle_DMR_07_blk_F", // CMR-76 6.5 mm (Black)
	// "srifle_DMR_07_ghex_F", // CMR-76 6.5 mm (Green Hex)
	// "srifle_DMR_07_hex_F", // CMR-76 6.5 mm (Hex)
	// "srifle_EBR_ACO_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_ARCO_pointer_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_ARCO_pointer_snds_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_DMS_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_DMS_pointer_snds_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_Hamr_pointer_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_MRCO_LP_BI_F", // Mk18 ABR 7.62 mm
	// "srifle_EBR_MRCO_pointer_F", // Mk18 ABR 7.62 mm
	"srifle_EBR_SOS_F" // Mk18 ABR 7.62 mm
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_weaponARLoot =
[
	"arifle_AK12_F", // AK-12 7.62 mm
	"arifle_AK12_GL_F", // AK-12 GL 7.62 mm
	"arifle_AKM_F", // AKM 7.62 mm
	"arifle_AKS_F", // AKS-74U 5.45 mm
	"arifle_ARX_blk_F", // Type 115 6.5 mm (Black)
	// "arifle_ARX_ghex_F", // Type 115 6.5 mm (Green Hex)
	// "arifle_ARX_hex_F", // Type 115 6.5 mm (Hex)
	"arifle_CTARS_blk_F", // CAR-95-1 5.8mm (Black)
	// "arifle_CTARS_blk_Pointer_F", // CAR-95-1 5.8mm (Black)
	"arifle_CTARS_ghex_F", // CAR-95-1 5.8mm (Green Hex)
	"arifle_CTARS_hex_F", // CAR-95-1 5.8mm (Hex)
	// "arifle_CTAR_blk_ACO_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_ACO_Pointer_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_ACO_Pointer_Snds_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_ARCO_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_ARCO_Pointer_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_ARCO_Pointer_Snds_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_blk_F", // CAR-95 5.8 mm (Black)
	// "arifle_CTAR_blk_Pointer_F", // CAR-95 5.8 mm (Black)
	"arifle_CTAR_ghex_F", // CAR-95 5.8 mm (Green Hex)
	// "arifle_CTAR_GL_blk_ACO_F", // CAR-95 GL 5.8 mm (Black)
	// "arifle_CTAR_GL_blk_ACO_Pointer_Snds_F", // CAR-95 GL 5.8 mm (Black)
	"arifle_CTAR_GL_blk_F", // CAR-95 GL 5.8 mm (Black)
	// "arifle_CTAR_GL_ghex_F", // CAR-95 GL 5.8 mm (Green Hex)
	// "arifle_CTAR_GL_hex_F", // CAR-95 GL 5.8 mm (Hex)
	// "arifle_CTAR_hex_F", // CAR-95 5.8 mm (Hex)
	// "arifle_Katiba_ACO_F", // Katiba 6.5 mm
	// "arifle_Katiba_ACO_pointer_F", // Katiba 6.5 mm
	// "arifle_Katiba_ACO_pointer_snds_F", // Katiba 6.5 mm
	// "arifle_Katiba_ARCO_F", // Katiba 6.5 mm
	// "arifle_Katiba_ARCO_pointer_F", // Katiba 6.5 mm
	// "arifle_Katiba_ARCO_pointer_snds_F", // Katiba 6.5 mm
	// "arifle_Katiba_C_ACO_F", // Katiba Carbine 6.5 mm
	// "arifle_Katiba_C_ACO_pointer_F", // Katiba Carbine 6.5 mm
	// "arifle_Katiba_C_ACO_pointer_snds_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_C_F", // Katiba Carbine 6.5 mm
	"arifle_Katiba_F", // Katiba 6.5 mm
	// "arifle_Katiba_GL_ACO_F", // Katiba GL 6.5 mm
	// "arifle_Katiba_GL_ACO_pointer_F", // Katiba GL 6.5 mm
	// "arifle_Katiba_GL_ACO_pointer_snds_F", // Katiba GL 6.5 mm
	// "arifle_Katiba_GL_ARCO_pointer_F", // Katiba GL 6.5 mm
	"arifle_Katiba_GL_F", // Katiba GL 6.5 mm
	// "arifle_Katiba_GL_Nstalker_pointer_F", // Katiba GL 6.5 mm
	// "arifle_Katiba_pointer_F", // Katiba 6.5 mm
	// "arifle_Mk20C_ACO_F", // Mk20C 5.56 mm (Camo)
	// "arifle_Mk20C_ACO_pointer_F", // Mk20C 5.56 mm (Camo)
	"arifle_Mk20C_F", // Mk20C 5.56 mm (Camo)
	"arifle_Mk20C_plain_F", // Mk20C 5.56 mm
	// "arifle_Mk20_ACO_F", // Mk20 5.56 mm (Camo)
	// "arifle_Mk20_ACO_pointer_F", // Mk20 5.56 mm (Camo)
	// "arifle_Mk20_F", // Mk20 5.56 mm (Camo)
	// "arifle_Mk20_GL_ACO_F", // Mk20 EGLM 5.56 mm (Camo)
	// "arifle_Mk20_GL_F", // Mk20 EGLM 5.56 mm (Camo)
	// "arifle_Mk20_GL_MRCO_pointer_F", // Mk20 EGLM 5.56 mm (Camo)
	"arifle_Mk20_GL_plain_F", // Mk20 EGLM 5.56 mm
	// "arifle_Mk20_Holo_F", // Mk20 5.56 mm (Camo)
	// "arifle_Mk20_MRCO_F", // Mk20 5.56 mm (Camo)
	// "arifle_Mk20_MRCO_plain_F", // Mk20 5.56 mm
	// "arifle_Mk20_MRCO_pointer_F", // Mk20 5.56 mm (Camo)
	"arifle_Mk20_plain_F", // Mk20 5.56 mm
	// "arifle_Mk20_pointer_F", // Mk20 5.56 mm (Camo)
	// "arifle_MXC_ACO_F", // MXC 6.5 mm
	// "arifle_MXC_ACO_pointer_F", // MXC 6.5 mm
	// "arifle_MXC_ACO_pointer_snds_F", // MXC 6.5 mm
	"arifle_MXC_Black_F", // MXC 6.5 mm (Black)
	// "arifle_MXC_F", // MXC 6.5 mm
	// "arifle_MXC_Holo_F", // MXC 6.5 mm
	// "arifle_MXC_Holo_pointer_F", // MXC 6.5 mm
	// "arifle_MXC_Holo_pointer_snds_F", // MXC 6.5 mm
	// "arifle_MXC_khk_ACO_F", // MXC 6.5 mm (Khaki)
	// "arifle_MXC_khk_ACO_Pointer_Snds_F", // MXC 6.5 mm (Khaki)
	// "arifle_MXC_khk_F", // MXC 6.5 mm (Khaki)
	// "arifle_MXC_khk_Holo_Pointer_F", // MXC 6.5 mm (Khaki)
	// "arifle_MXC_SOS_point_snds_F", // MXC 6.5 mm
	"arifle_MXM_Black_F", // MXM 6.5 mm (Black)
	// "arifle_MXM_DMS_F", // MXM 6.5 mm
	// "arifle_MXM_DMS_LP_BI_snds_F", // MXM 6.5 mm
	// "arifle_MXM_F", // MXM 6.5 mm
	// "arifle_MXM_Hamr_LP_BI_F", // MXM 6.5 mm
	// "arifle_MXM_Hamr_pointer_F", // MXM 6.5 mm
	// "arifle_MXM_khk_F", // MXM 6.5 mm (Khaki)
	// "arifle_MXM_khk_MOS_Pointer_Bipod_F", // MXM 6.5 mm (Khaki)
	// "arifle_MXM_RCO_pointer_snds_F", // MXM 6.5 mm
	// "arifle_MXM_SOS_pointer_F", // MXM 6.5 mm
	// "arifle_MX_ACO_F", // MX 6.5 mm
	// "arifle_MX_ACO_pointer_F", // MX 6.5 mm
	// "arifle_MX_ACO_pointer_snds_F", // MX 6.5 mm
	"arifle_MX_Black_F", // MX 6.5 mm (Black)
	// "arifle_MX_Black_Hamr_pointer_F", // MX 6.5 mm (Black)
	"arifle_MX_F", // MX 6.5 mm
	// "arifle_MX_GL_ACO_F", // MX 3GL 6.5 mm
	// "arifle_MX_GL_ACO_pointer_F", // MX 3GL 6.5 mm
	"arifle_MX_GL_Black_F", // MX 3GL 6.5 mm (Black)
	// "arifle_MX_GL_Black_Hamr_pointer_F", // MX 3GL 6.5 mm (Black)
	"arifle_MX_GL_F", // MX 3GL 6.5 mm
	// "arifle_MX_GL_Hamr_pointer_F", // MX 3GL 6.5 mm
	// "arifle_MX_GL_Holo_pointer_snds_F", // MX 3GL 6.5 mm
	// "arifle_MX_GL_khk_ACO_F", // MX 3GL 6.5 mm (Khaki)
	// "arifle_MX_GL_khk_F", // MX 3GL 6.5 mm (Khaki)
	// "arifle_MX_GL_khk_Hamr_Pointer_F", // MX 3GL 6.5 mm (Khaki)
	// "arifle_MX_GL_khk_Holo_Pointer_Snds_F", // MX 3GL 6.5 mm (Khaki)
	// "arifle_MX_Hamr_pointer_F", // MX 6.5 mm
	// "arifle_MX_Holo_pointer_F", // MX 6.5 mm
	// "arifle_MX_khk_ACO_Pointer_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_ACO_Pointer_Snds_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_Hamr_Pointer_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_Hamr_Pointer_Snds_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_Holo_Pointer_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_khk_Pointer_F", // MX 6.5 mm (Khaki)
	// "arifle_MX_pointer_F", // MX 6.5 mm
	// "arifle_MX_RCO_pointer_snds_F", // MX 6.5 mm
	"arifle_MX_SW_Black_F", // MX SW 6.5 mm (Black)
	// "arifle_MX_SW_Black_Hamr_pointer_F", // MX SW 6.5 mm (Black)
	// "arifle_MX_SW_F", // MX SW 6.5 mm
	// "arifle_MX_SW_Hamr_pointer_F", // MX SW 6.5 mm
	// "arifle_MX_SW_khk_F", // MX SW 6.5 mm (Khaki)
	// "arifle_MX_SW_khk_Pointer_F", // MX SW 6.5 mm (Khaki)
	// "arifle_MX_SW_pointer_F", // MX SW 6.5 mm
	"arifle_SDAR_F", // SDAR 5.56 mm
	"arifle_SPAR_01_blk_F", // SPAR-16 5.56 mm (Black)
	"arifle_SPAR_01_GL_blk_F", // SPAR-16 GL 5.56 mm (Black)
	// "arifle_SPAR_01_GL_khk_F", // SPAR-16 GL 5.56 mm (Khaki)
	// "arifle_SPAR_01_GL_snd_F", // SPAR-16 GL 5.56 mm (Sand)
	// "arifle_SPAR_01_khk_F", // SPAR-16 5.56 mm (Khaki)
	// "arifle_SPAR_01_snd_F", // SPAR-16 5.56 mm (Sand)
	"arifle_SPAR_02_blk_F", // SPAR-16S 5.56 mm (Black)
	// "arifle_SPAR_02_khk_F", // SPAR-16S 5.56 mm (Khaki)
	// "arifle_SPAR_02_snd_F", // SPAR-16S 5.56 mm (Sand)
	"arifle_SPAR_03_blk_F", // SPAR-17 7.62 mm (Black)
	// "arifle_SPAR_03_khk_F", // SPAR-17 7.62 mm (Khaki)
	// "arifle_SPAR_03_snd_F", // SPAR-17 7.62 mm (Sand)
	// "arifle_TRG20_ACO_F", // TRG-20 5.56 mm
	// "arifle_TRG20_ACO_Flash_F", // TRG-20 5.56 mm
	// "arifle_TRG20_ACO_pointer_F", // TRG-20 5.56 mm
	"arifle_TRG20_F", // TRG-20 5.56 mm
	// "arifle_TRG20_Holo_F", // TRG-20 5.56 mm
	// "arifle_TRG21_ACO_pointer_F", // TRG-21 5.56 mm
	// "arifle_TRG21_ARCO_pointer_F", // TRG-21 5.56 mm
	"arifle_TRG21_F", // TRG-21 5.56 mm
	// "arifle_TRG21_GL_ACO_pointer_F", // TRG-21 EGLM 5.56 mm
	"arifle_TRG21_GL_F", // TRG-21 EGLM 5.56 mm
	// "arifle_TRG21_GL_MRCO_F", // TRG-21 EGLM 5.56 mm
	// "arifle_TRG21_MRCO_F", // TRG-21 5.56 mm
	// "hgun_PDW2000_F", // PDW2000 9 mm
	// "hgun_PDW2000_Holo_F", // PDW2000 9 mm
	// "hgun_PDW2000_Holo_snds_F", // PDW2000 9 mm
	// "hgun_PDW2000_snds_F", // PDW2000 9 mm
	"LMG_03_F", // LIM-85 5.56 mm
	// "LMG_Mk200_BI_F", // Mk200 6.5 mm
	"LMG_Mk200_F", // Mk200 6.5 mm
	// "LMG_Mk200_LP_BI_F", // Mk200 6.5 mm
	// "LMG_Mk200_MRCO_F", // Mk200 6.5 mm
	// "LMG_Mk200_pointer_F", // Mk200 6.5 mm
	// "LMG_Zafir_ARCO_F", // Zafir 7.62 mm
	"LMG_Zafir_F" // Zafir 7.62 mm
	// "LMG_Zafir_pointer_F", // Zafir 7.62 mm
	// "MMG_01_hex_ARCO_LP_F", // Navid 9.3 mm (Hex)
	// "MMG_01_hex_F", // Navid 9.3 mm (Hex)
	// "MMG_01_tan_F", // Navid 9.3 mm (Tan)
	// "MMG_02_black_F", // SPMG .338 (Black)
	// "MMG_02_black_RCO_BI_F", // SPMG .338 (Black)
	// "MMG_02_camo_F", // SPMG .338 (MTP)
	// "MMG_02_sand_F", // SPMG .338 (Sand)
	// "MMG_02_sand_RCO_LP_F", // SPMG .338 (Sand)
	// "SMG_01_ACO_F", // Vermin SMG .45 ACP
	// "SMG_01_F", // Vermin SMG .45 ACP
	// "SMG_01_Holo_F", // Vermin SMG .45 ACP
	// "SMG_01_Holo_pointer_snds_F", // Vermin SMG .45 ACP
	// "SMG_02_ACO_F", // Sting 9 mm
	// "SMG_02_ARCO_pointg_F", // Sting 9 mm
	// "SMG_02_F", // Sting 9 mm
	// "SMG_05_F", // Protector 9 mm
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_surplusLoot =
[
	"HandGrenade", // RGO Grenade MAGAZINE"
	"MiniGrenade", // RGN Grenade MAGAZINE"
	"HandGrenade", // RGO Grenade MAGAZINE"
	"MiniGrenade", // RGN Grenade MAGAZINE"
	"NVGoggles", // NV Goggles (Brown) BINOCULAR"
	"NVGogglesB_blk_F", // ENVG-II (Black) BINOCULAR"
	"NVGogglesB_grn_F", // ENVG-II (Green) BINOCULAR"
	"NVGogglesB_gry_F", // ENVG-II (Grey) BINOCULAR"
	"NVGoggles_INDEP", // NV Goggles (Green) BINOCULAR"
	"NVGoggles_OPFOR", // NV Goggles (Black) BINOCULAR"
	"NVGoggles_tna_F", // NV Goggles (Tropic) BINOCULAR"
	"O_NVGoggles_ghex_F", // Compact NVG (Green Hex) BINOCULAR"
	"O_NVGoggles_hex_F", // Compact NVG (Hex) BINOCULAR"
	"O_NVGoggles_urb_F", // Compact NVG (Urban) BINOCULAR"
	"Rangefinder", // Rangefinder BINOCULAR"
	// "muzzle_snds_338_black", // Sound Suppressor (.338, Black) MUZZLE"
	// "muzzle_snds_338_green", // Sound Suppressor (.338, Green) MUZZLE"
	// "muzzle_snds_338_sand", // Sound Suppressor (.338, Sand) MUZZLE"
	"muzzle_snds_58_blk_F", // Stealth Sound Suppressor (5.8 mm, Black) MUZZLE"
	"muzzle_snds_58_ghex_F", // Stealth Sound Suppressor (5.8 mm, Green Hex) MUZZLE"
	"muzzle_snds_58_hex_F", // Sound Suppressor (5.8 mm, Hex) MUZZLE"
	"muzzle_snds_65_TI_blk_F", // Stealth Sound Suppressor (6.5 mm, Black) MUZZLE"
	"muzzle_snds_65_TI_ghex_F", // Stealth Sound Suppressor (6.5 mm, Green Hex) MUZZLE"
	"muzzle_snds_65_TI_hex_F", // Stealth Sound Suppressor (6.5 mm, Hex) MUZZLE"
	// "muzzle_snds_93mmg", // Sound Suppressor (9.3mm, Black) MUZZLE"
	// "muzzle_snds_93mmg_tan", // Sound Suppressor (9.3mm, Tan) MUZZLE"
	"muzzle_snds_acp", // Sound Suppressor (.45 ACP) MUZZLE"
	"muzzle_snds_B", // Sound Suppressor (7.62 mm) MUZZLE"
	"muzzle_snds_B_khk_F", // Sound Suppressor (7.62 mm, Khaki) MUZZLE"
	"muzzle_snds_B_snd_F", // Sound Suppressor (7.62 mm, Sand) MUZZLE"
	"muzzle_snds_H", // Sound Suppressor (6.5 mm) MUZZLE"
	"muzzle_snds_H_khk_F", // Sound Suppressor (6.5 mm, Khaki) MUZZLE"
	"muzzle_snds_H_snd_F", // Sound Suppressor (6.5 mm, Sand) MUZZLE"
	"muzzle_snds_L", // Sound Suppressor (9 mm) MUZZLE"
	"muzzle_snds_M", // Sound Suppressor (5.56 mm) MUZZLE"
	"muzzle_snds_m_khk_F", // Sound Suppressor (5.56 mm, Khaki) MUZZLE"
	"muzzle_snds_m_snd_F", // Sound Suppressor (5.56 mm, Sand) MUZZLE"
	"optic_Aco", // ACO (Red) OPTIC"
	"optic_ACO_grn", // ACO (Green) OPTIC"
	"optic_ACO_grn_smg", // ACO SMG (Green) OPTIC"
	"optic_Aco_smg", // ACO SMG (Red) OPTIC"
	"optic_AMS", // AMS (Black) OPTIC"
	"optic_AMS_khk", // AMS (Khaki) OPTIC"
	"optic_AMS_snd", // AMS (Sand) OPTIC"
	"optic_Arco", // ARCO OPTIC"
	"optic_Arco_blk_F", // ARCO (Black) OPTIC"
	"optic_Arco_ghex_F", // ARCO (Green Hex) OPTIC"
	"optic_DMS", // DMS OPTIC"
	"optic_DMS_ghex_F", // DMS (Green Hex) OPTIC"
	"optic_ERCO_blk_F", // ERCO (Black) OPTIC"
	"optic_ERCO_khk_F", // ERCO (Khaki) OPTIC"
	"optic_ERCO_snd_F", // ERCO (Sand) OPTIC"
	"optic_Hamr", // RCO OPTIC"
	"optic_Hamr_khk_F", // RCO (Khaki) OPTIC"
	"optic_Holosight", // Mk17 Holosight OPTIC"
	"optic_Holosight_blk_F", // Mk17 Holosight (Black) OPTIC"
	"optic_Holosight_khk_F", // Mk17 Holosight (Khaki) OPTIC"
	"optic_Holosight_smg", // Mk17 Holosight SMG OPTIC"
	"optic_Holosight_smg_blk_F", // Mk17 Holosight SMG (Black) OPTIC"
	// "optic_KHS_blk", // Kahlia (Black) OPTIC"
	// "optic_KHS_hex", // Kahlia (Hex) OPTIC"
	// "optic_KHS_old", // Kahlia (Old) OPTIC"
	// "optic_KHS_tan", // Kahlia (Tan) OPTIC"
	// "optic_LRPS", // LRPS OPTIC"
	// "optic_LRPS_ghex_F", // LRPS (Green Hex) OPTIC"
	// "optic_LRPS_tna_F", // LRPS (Tropic) OPTIC"
	"optic_MRCO", // MRCO OPTIC"
	"optic_MRD", // MRD OPTIC"
	// "optic_Nightstalker", // Nightstalker OPTIC"
	// "optic_NVS", // NVS OPTIC"
	// "optic_SOS", // MOS OPTIC"
	// "optic_SOS_khk_F", // MOS (Khaki) OPTIC"
	// "optic_tws", // TWS OPTIC"
	// "optic_tws_mg", // TWS MG OPTIC"
	"optic_Yorris" // Yorris J2 OPTIC"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_medicalLoot =
[
	"FirstAidKit",
	"FirstAidKit",
	"FirstAidKit",
	"FirstAidKit",
	"Medikit",
	"FirstAidKit",
	"FirstAidKit",
	"FirstAidKit",
	"FirstAidKit",
	"FirstAidKit"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_headgearLoot =
[
	// "H_Bandanna_blu", // Bandana (Blue) HEADGEAR"
	// "H_Bandanna_camo", // Bandana (Woodland) HEADGEAR"
	// "H_Bandanna_cbr", // Bandana (Coyote) HEADGEAR"
	// "H_Bandanna_gry", // Bandana (Black) HEADGEAR"
	// "H_Bandanna_khk", // Bandana (Khaki) HEADGEAR"
	// "H_Bandanna_khk_hs", // Bandana (Headset) HEADGEAR"
	// "H_Bandanna_mcamo", // Bandana (MTP) HEADGEAR"
	// "H_Bandanna_sand", // Bandana (Sand) HEADGEAR"
	// "H_Bandanna_sgg", // Bandana (Sage) HEADGEAR"
	// "H_Bandanna_surfer", // Bandana (Surfer) HEADGEAR"
	// "H_Bandanna_surfer_blk", // Bandana (Surfer, Black) HEADGEAR"
	// "H_Bandanna_surfer_grn", // Bandana (Surfer, Green) HEADGEAR"
	// "H_Beret_02", // Beret [NATO] HEADGEAR"
	// "H_Beret_blk", // Beret (Black) HEADGEAR"
	// "H_Beret_Colonel", // Beret [NATO] (Colonel) HEADGEAR"
	// "H_Beret_gen_F", // Beret (Gendarmerie) HEADGEAR"
	// "H_Booniehat_dgtl", // Booniehat [AAF] HEADGEAR"
	// "H_Booniehat_khk", // Booniehat (Khaki) HEADGEAR"
	// "H_Booniehat_khk_hs", // Booniehat (Headset) HEADGEAR"
	// "H_Booniehat_mcamo", // Booniehat (MTP) HEADGEAR"
	// "H_Booniehat_oli", // Booniehat (Olive) HEADGEAR"
	// "H_Booniehat_tan", // Booniehat (Sand) HEADGEAR"
	// "H_Booniehat_tna_F", // Booniehat (Tropic) HEADGEAR"
	// "H_Cap_blk", // Cap (Black) HEADGEAR"
	// "H_Cap_blk_CMMG", // Cap (CMMG) HEADGEAR"
	// "H_Cap_blk_ION", // Cap (ION) HEADGEAR"
	// "H_Cap_blk_Raven", // Cap [AAF] HEADGEAR"
	// "H_Cap_blu", // Cap (Blue) HEADGEAR"
	// "H_Cap_brn_SPECOPS", // Cap [OPFOR] HEADGEAR"
	// "H_Cap_grn", // Cap (Green) HEADGEAR"
	// "H_Cap_grn_BI", // Cap (BI) HEADGEAR"
	// "H_Cap_headphones", // Rangemaster Cap HEADGEAR"
	// "H_Cap_khaki_specops_UK", // Cap (UK) HEADGEAR"
	// "H_Cap_marshal", // Marshal Cap HEADGEAR"
	// "H_Cap_oli", // Cap (Olive) HEADGEAR"
	// "H_Cap_oli_hs", // Cap (Olive, Headset) HEADGEAR"
	// "H_Cap_police", // Cap (Police) HEADGEAR"
	// "H_Cap_press", // Cap (Press) HEADGEAR"
	// "H_Cap_red", // Cap (Red) HEADGEAR"
	// "H_Cap_surfer", // Cap (Surfer) HEADGEAR"
	// "H_Cap_tan", // Cap (Tan) HEADGEAR"
	// "H_Cap_tan_specops_US", // Cap (US MTP) HEADGEAR"
	// "H_Cap_usblack", // Cap (US Black) HEADGEAR"
	// "H_CrewHelmetHeli_B", // Heli Crew Helmet [NATO] HEADGEAR"
	// "H_CrewHelmetHeli_I", // Heli Crew Helmet [AAF] HEADGEAR"
	// "H_CrewHelmetHeli_O", // Heli Crew Helmet [CSAT] HEADGEAR"
	// "H_Hat_blue", // Hat (Blue) HEADGEAR"
	// "H_Hat_brown", // Hat (Brown) HEADGEAR"
	// "H_Hat_camo", // Hat (Camo) HEADGEAR"
	// "H_Hat_checker", // Hat (Checker) HEADGEAR"
	// "H_Hat_grey", // Hat (Grey) HEADGEAR"
	// "H_Hat_tan", // Hat (Tan) HEADGEAR"
	"H_HelmetB", // Combat Helmet HEADGEAR"
	"H_HelmetB_black", // Combat Helmet (Black) HEADGEAR"
	"H_HelmetB_camo", // Combat Helmet (Camo) HEADGEAR"
	"H_HelmetB_desert", // Combat Helmet (Desert) HEADGEAR"
	"H_HelmetB_Enh_tna_F", // Enhanced Combat Helmet (Tropic) HEADGEAR"
	"H_HelmetB_grass", // Combat Helmet (Grass) HEADGEAR"
	"H_HelmetB_light", // Light Combat Helmet HEADGEAR"
	"H_HelmetB_light_black", // Light Combat Helmet (Black) HEADGEAR"
	"H_HelmetB_light_desert", // Light Combat Helmet (Desert) HEADGEAR"
	"H_HelmetB_light_grass", // Light Combat Helmet (Grass) HEADGEAR"
	"H_HelmetB_light_sand", // Light Combat Helmet (Sand) HEADGEAR"
	"H_HelmetB_light_snakeskin", // Light Combat Helmet (Snakeskin) HEADGEAR"
	"H_HelmetB_Light_tna_F", // Light Combat Helmet (Tropic) HEADGEAR"
	"H_HelmetB_sand", // Combat Helmet (Sand) HEADGEAR"
	"H_HelmetB_snakeskin", // Combat Helmet (Snakeskin) HEADGEAR"
	"H_HelmetB_TI_tna_F", // Stealth Combat Helmet HEADGEAR"
	"H_HelmetB_tna_F", // Combat Helmet (Tropic) HEADGEAR"
	"H_HelmetCrew_B", // Crew Helmet [NATO] HEADGEAR"
	"H_HelmetCrew_I", // Crew Helmet [AAF] HEADGEAR"
	"H_HelmetCrew_O", // Crew Helmet [CSAT] HEADGEAR"
	"H_HelmetCrew_O_ghex_F", // Crew Helmet (Green Hex) [CSAT] HEADGEAR"
	"H_HelmetIA", // Modular Helmet HEADGEAR"
	"H_HelmetLeaderO_ghex_F", // Defender Helmet (Green Hex) HEADGEAR"
	"H_HelmetLeaderO_ocamo", // Defender Helmet (Hex) HEADGEAR"
	"H_HelmetLeaderO_oucamo", // Defender Helmet (Urban) HEADGEAR"
	"H_HelmetO_ghex_F", // Protector Helmet (Green Hex) HEADGEAR"
	"H_HelmetO_ocamo", // Protector Helmet (Hex) HEADGEAR"
	"H_HelmetO_oucamo", // Protector Helmet (Urban) HEADGEAR"
	// "H_HelmetO_ViperSP_ghex_F", // Special Purpose Helmet (Green Hex) HEADGEAR"
	// "H_HelmetO_ViperSP_hex_F", // Special Purpose Helmet (Hex) HEADGEAR"
	"H_HelmetSpecB", // Enhanced Combat Helmet HEADGEAR"
	"H_HelmetSpecB_blk", // Enhanced Combat Helmet (Black) HEADGEAR"
	"H_HelmetSpecB_paint1", // Enhanced Combat Helmet (Grass) HEADGEAR"
	"H_HelmetSpecB_paint2", // Enhanced Combat Helmet (Desert) HEADGEAR"
	"H_HelmetSpecB_sand", // Enhanced Combat Helmet (Sand) HEADGEAR"
	"H_HelmetSpecB_snakeskin", // Enhanced Combat Helmet (Snakeskin) HEADGEAR"
	"H_HelmetSpecO_blk", // Assassin Helmet (Black) HEADGEAR"
	"H_HelmetSpecO_ghex_F", // Assassin Helmet (Green Hex) HEADGEAR"
	"H_HelmetSpecO_ocamo" // Assassin Helmet (Hex) HEADGEAR"
	// "H_Helmet_Skate", // Skate Helmet HEADGEAR"
	// "H_MilCap_blue", // Military Cap (Blue) HEADGEAR"
	// "H_MilCap_dgtl", // Military Cap [AAF] HEADGEAR"
	// "H_MilCap_gen_F", // Military Cap (Gendarmerie) HEADGEAR"
	// "H_MilCap_ghex_F", // Military Cap (Green Hex) HEADGEAR"
	// "H_MilCap_gry", // Military Cap (Grey) HEADGEAR"
	// "H_MilCap_mcamo", // Military Cap (MTP) HEADGEAR"
	// "H_MilCap_ocamo", // Military Cap (Hex) HEADGEAR"
	// "H_MilCap_tna_F", // Military Cap (Tropic) HEADGEAR"
	// "H_PilotHelmetFighter_B", // Pilot Helmet [NATO] HEADGEAR"
	// "H_PilotHelmetFighter_I", // Pilot Helmet [AAF] HEADGEAR"
	// "H_PilotHelmetFighter_O", // Pilot Helmet [CSAT] HEADGEAR"
	// "H_PilotHelmetHeli_B", // Heli Pilot Helmet [NATO] HEADGEAR"
	// "H_PilotHelmetHeli_I", // Heli Pilot Helmet [AAF] HEADGEAR"
	// "H_PilotHelmetHeli_O", // Heli Pilot Helmet [CSAT] HEADGEAR"
	// "H_RacingHelmet_1_black_F", // Racing Helmet (Black) HEADGEAR"
	// "H_RacingHelmet_1_blue_F", // Racing Helmet (Blue) HEADGEAR"
	// "H_RacingHelmet_1_F", // Racing Helmet (Fuel) HEADGEAR"
	// "H_RacingHelmet_1_green_F", // Racing Helmet (Green) HEADGEAR"
	// "H_RacingHelmet_1_orange_F", // Racing Helmet (Orange) HEADGEAR"
	// "H_RacingHelmet_1_red_F", // Racing Helmet (Red) HEADGEAR"
	// "H_RacingHelmet_1_white_F", // Racing Helmet (White) HEADGEAR"
	// "H_RacingHelmet_1_yellow_F", // Racing Helmet (Yellow) HEADGEAR"
	// "H_RacingHelmet_2_F", // Racing Helmet (Bluking) HEADGEAR"
	// "H_RacingHelmet_3_F", // Racing Helmet (Redstone) HEADGEAR"
	// "H_RacingHelmet_4_F", // Racing Helmet (Vrana) HEADGEAR"
	// "H_ShemagOpen_khk", // Shemag (White) HEADGEAR"
	// "H_ShemagOpen_tan", // Shemag (Tan) HEADGEAR"
	// "H_Shemag_olive", // Shemag (Olive) HEADGEAR"
	// "H_Shemag_olive_hs", // Shemag (Olive, Headset) HEADGEAR"
	// "H_StrawHat", // Straw Hat HEADGEAR"
	// "H_StrawHat_dark", // Straw Hat (Dark) HEADGEAR"
	// "H_Watchcap_blk", // Beanie HEADGEAR"
	// "H_Watchcap_camo", // Beanie (Green) HEADGEAR"
	// "H_Watchcap_cbr", // Beanie (Coyote) HEADGEAR"
	// "H_Watchcap_khk", // Beanie (Khaki) HEADGEAR"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_uniformLoot =
[
	// "U_BG_Guerilla1_1", // Guerilla Garment UNIFORM"
	// "U_BG_Guerilla2_1", // Guerilla Outfit (Plain, Dark) UNIFORM"
	// "U_BG_Guerilla2_2", // Guerilla Outfit (Pattern) UNIFORM"
	// "U_BG_Guerilla2_3", // Guerilla Outfit (Plain, Light) UNIFORM"
	// "U_BG_Guerilla3_1", // Guerilla Smocks UNIFORM"
	// "U_BG_Guerrilla_6_1", // Guerilla Apparel UNIFORM"
	// "U_BG_leader", // Guerilla Uniform UNIFORM"
	"U_B_CombatUniform_mcam", // Combat Fatigues (MTP) UNIFORM"
	"U_B_CombatUniform_mcam_tshirt", // Combat Fatigues (MTP) (Tee) UNIFORM"
	"U_B_CombatUniform_mcam_vest", // Recon Fatigues (MTP) UNIFORM"
	"U_B_CombatUniform_mcam_worn", // Worn Combat Fatigues (MTP) UNIFORM"
	"U_B_CTRG_1", // CTRG Combat Uniform UNIFORM"
	"U_B_CTRG_2", // CTRG Combat Uniform (Tee) UNIFORM"
	"U_B_CTRG_3", // CTRG Combat Uniform (Rolled-up) UNIFORM"
	"U_B_CTRG_Soldier_2_F", // CTRG Stealth Uniform (Tee) UNIFORM"
	"U_B_CTRG_Soldier_3_F", // CTRG Stealth Uniform (Rolled-up) UNIFORM"
	"U_B_CTRG_Soldier_F", // CTRG Stealth Uniform UNIFORM"
	"U_B_CTRG_Soldier_urb_1_F", // CTRG Urban Uniform UNIFORM"
	"U_B_CTRG_Soldier_urb_2_F", // CTRG Urban Uniform (Tee) UNIFORM"
	"U_B_CTRG_Soldier_urb_3_F", // CTRG Urban Uniform (Rolled-up) UNIFORM"
	// "U_B_FullGhillie_ard", // Full Ghillie (Arid) [NATO] UNIFORM"
	// "U_B_FullGhillie_lsh", // Full Ghillie (Lush) [NATO] UNIFORM"
	// "U_B_FullGhillie_sard", // Full Ghillie (Semi-Arid) [NATO] UNIFORM"
	"U_B_GEN_Commander_F", // Gendarmerie Commander Uniform UNIFORM"
	"U_B_GEN_Soldier_F", // Gendarmerie Uniform UNIFORM"
	"U_B_GhillieSuit", // Ghillie Suit [NATO] UNIFORM"
	"U_B_HeliPilotCoveralls", // Heli Pilot Coveralls [NATO] UNIFORM"
	"U_B_PilotCoveralls", // Pilot Coveralls [NATO] UNIFORM"
	// "U_B_Protagonist_VR", // VR Suit [NATO] UNIFORM"
	// "U_B_survival_uniform", // Survival Fatigues UNIFORM"
	// "U_B_T_FullGhillie_tna_F", // Full Ghillie (Jungle) [NATO] UNIFORM"
	// "U_B_T_Sniper_F", // Ghillie Suit (Tropic) [NATO] UNIFORM"
	"U_B_T_Soldier_AR_F", // Combat Fatigues (Tropic, Tee) UNIFORM"
	"U_B_T_Soldier_F", // Combat Fatigues (Tropic) UNIFORM"
	"U_B_T_Soldier_SL_F", // Recon Fatigues (Tropic) UNIFORM"
	"U_B_Wetsuit", // Wetsuit [NATO] UNIFORM"
	// "U_Competitor", // Competitor Suit UNIFORM"
	// "U_C_Driver_1", // Driver Coverall (Fuel) UNIFORM"
	// "U_C_Driver_1_black", // Driver Coverall (Black) UNIFORM"
	// "U_C_Driver_1_blue", // Driver Coverall (Blue) UNIFORM"
	// "U_C_Driver_1_green", // Driver Coverall (Green) UNIFORM"
	// "U_C_Driver_1_orange", // Driver Coverall (Orange) UNIFORM"
	// "U_C_Driver_1_red", // Driver Coverall (Red) UNIFORM"
	// "U_C_Driver_1_white", // Driver Coverall (White) UNIFORM"
	// "U_C_Driver_1_yellow", // Driver Coverall (Yellow) UNIFORM"
	// "U_C_Driver_2", // Driver Coverall (Bluking) UNIFORM"
	// "U_C_Driver_3", // Driver Coverall (Redstone) UNIFORM"
	// "U_C_Driver_4", // Driver Coverall (Vrana) UNIFORM"
	// "U_C_HunterBody_grn", // Hunting Clothes UNIFORM"
	// "U_C_Journalist", // Journalist Clothes UNIFORM"
	// "U_C_Man_casual_1_F", // Casual Clothes (Navy) UNIFORM"
	// "U_C_Man_casual_2_F", // Casual Clothes (Blue) UNIFORM"
	// "U_C_Man_casual_3_F", // Casual Clothes (Green) UNIFORM"
	// "U_C_Man_casual_4_F", // Summer Clothes (Sky) UNIFORM"
	// "U_C_Man_casual_5_F", // Summer Clothes (Yellow) UNIFORM"
	// "U_C_Man_casual_6_F", // Summer Clothes (Red) UNIFORM"
	// "U_C_man_sport_1_F", // Sport Clothes (Beach) UNIFORM"
	// "U_C_man_sport_2_F", // Sport Clothes (Orange) UNIFORM"
	// "U_C_man_sport_3_F", // Sport Clothes (Blue) UNIFORM"
	// "U_C_Poloshirt_blue", // Commoner Clothes (Blue) UNIFORM"
	// "U_C_Poloshirt_burgundy", // Commoner Clothes (Burgundy) UNIFORM"
	// "U_C_Poloshirt_redwhite", // Commoner Clothes (Red-White) UNIFORM"
	// "U_C_Poloshirt_salmon", // Commoner Clothes (Salmon) UNIFORM"
	// "U_C_Poloshirt_stripped", // Commoner Clothes (Striped) UNIFORM"
	// "U_C_Poloshirt_tricolour", // Commoner Clothes (Tricolor) UNIFORM"
	// "U_C_Poor_1", // Worn Clothes UNIFORM"
	// "U_C_Scientist", // Scientist Clothes UNIFORM"
	// "U_C_WorkerCoveralls", // Worker Coveralls UNIFORM"
	"U_I_CombatUniform", // Combat Fatigues [AAF] UNIFORM"
	"U_I_CombatUniform_shortsleeve", // Combat Fatigues [AAF] (Rolled-up) UNIFORM"
	// "U_I_C_Soldier_Bandit_1_F", // Bandit Clothes (Polo Shirt) UNIFORM"
	// "U_I_C_Soldier_Bandit_2_F", // Bandit Clothes (Skull) UNIFORM"
	// "U_I_C_Soldier_Bandit_3_F", // Bandit Clothes (Tee) UNIFORM"
	// "U_I_C_Soldier_Bandit_4_F", // Bandit Clothes (Checkered) UNIFORM"
	// "U_I_C_Soldier_Bandit_5_F", // Bandit Clothes (Tank Top) UNIFORM"
	// "U_I_C_Soldier_Camo_F", // Syndikat Uniform UNIFORM"
	"U_I_C_Soldier_Para_1_F", // Paramilitary Garb (Tee) UNIFORM"
	"U_I_C_Soldier_Para_2_F", // Paramilitary Garb (Jacket) UNIFORM"
	"U_I_C_Soldier_Para_3_F", // Paramilitary Garb (Shirt) UNIFORM"
	"U_I_C_Soldier_Para_4_F", // Paramilitary Garb (Tank Top) UNIFORM"
	"U_I_C_Soldier_Para_5_F", // Paramilitary Garb (Shorts) UNIFORM"
	// "U_I_FullGhillie_ard", // Full Ghillie (Arid) [AAF] UNIFORM"
	// "U_I_FullGhillie_lsh", // Full Ghillie (Lush) [AAF] UNIFORM"
	// "U_I_FullGhillie_sard", // Full Ghillie (Semi-Arid) [AAF] UNIFORM"
	"U_I_GhillieSuit", // Ghillie Suit [AAF] UNIFORM"
	"U_I_G_resistanceLeader_F", // Combat Fatigues (Stavrou) UNIFORM"
	// "U_I_G_Story_Protagonist_F", // Worn Combat Fatigues (Kerry) UNIFORM"
	"U_I_HeliPilotCoveralls", // Heli Pilot Coveralls [AAF] UNIFORM"
	"U_I_OfficerUniform", // Combat Fatigues [AAF] (Officer) UNIFORM"
	"U_I_pilotCoveralls", // Pilot Coveralls [AAF] UNIFORM"
	// "U_I_Protagonist_VR", // VR Suit [AAF] UNIFORM"
	"U_I_Wetsuit", // Wetsuit [AAF] UNIFORM"
	// "U_Marshal", // Marshal Clothes UNIFORM"
	// "U_OrestesBody", // Jacket and Shorts UNIFORM"
	"U_O_CombatUniform_ocamo", // Fatigues (Hex) [CSAT] UNIFORM"
	"U_O_CombatUniform_oucamo", // Fatigues (Urban) [CSAT] UNIFORM"
	// "U_O_FullGhillie_ard", // Full Ghillie (Arid) [CSAT] UNIFORM"
	// "U_O_FullGhillie_lsh", // Full Ghillie (Lush) [CSAT] UNIFORM"
	// "U_O_FullGhillie_sard", // Full Ghillie (Semi-Arid) [CSAT] UNIFORM"
	"U_O_GhillieSuit", // Ghillie Suit [CSAT] UNIFORM"
	"U_O_OfficerUniform_ocamo", // Officer Fatigues (Hex) UNIFORM"
	"U_O_PilotCoveralls", // Pilot Coveralls [CSAT] UNIFORM"
	// "U_O_Protagonist_VR", // VR Suit [CSAT] UNIFORM"
	"U_O_SpecopsUniform_ocamo", // Recon Fatigues (Hex) UNIFORM"
	// "U_O_T_FullGhillie_tna_F", // Full Ghillie (Jungle) [CSAT] UNIFORM"
	"U_O_T_Officer_F", // Officer Fatigues (Green Hex) [CSAT] UNIFORM"
	// "U_O_T_Sniper_F", // Ghillie Suit (Green Hex) [CSAT] UNIFORM"
	"U_O_T_Soldier_F", // Fatigues (Green Hex) [CSAT] UNIFORM"
	"U_O_V_Soldier_Viper_F", // Special Purpose Suit (Green Hex) UNIFORM"
	"U_O_V_Soldier_Viper_hex_F", // Special Purpose Suit (Hex) UNIFORM"
	"U_O_Wetsuit", // Wetsuit [CSAT] UNIFORM"
	"U_Rangemaster" // Rangemaster Suit UNIFORM"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_vestLoot =
[
	"V_BandollierB_blk", // Slash Bandolier (Black) VEST"
	// "V_BandollierB_cbr", // Slash Bandolier (Coyote) VEST"
	// "V_BandollierB_ghex_F", // Slash Bandolier (Green Hex) VEST"
	"V_BandollierB_khk", // Slash Bandolier (Khaki) VEST"
	"V_BandollierB_oli", // Slash Bandolier (Olive) VEST"
	"V_BandollierB_rgr", // Slash Bandolier (Green) VEST"
	"V_Chestrig_blk", // Chest Rig (Black) VEST"
	"V_Chestrig_khk", // Chest Rig (Khaki) VEST"
	"V_Chestrig_oli", // Chest Rig (Olive) VEST"
	"V_Chestrig_rgr", // Chest Rig (Green) VEST"
	"V_HarnessOGL_brn", // LBV Grenadier Harness VEST"
	// "V_HarnessOGL_ghex_F", // LBV Grenadier Harness (Green Hex) VEST"
	// "V_HarnessOGL_gry", // LBV Grenadier Harness (Grey) VEST"
	"V_HarnessO_brn", // LBV Harness VEST"
	"V_HarnessO_ghex_F", // LBV Harness (Green Hex) VEST"
	"V_HarnessO_gry", // LBV Harness (Grey) VEST"
	// "V_I_G_resistanceLeader_F", // Tactical Vest (Stavrou) VEST"
	"V_PlateCarrier1_blk", // Carrier Lite (Black) VEST"
	"V_PlateCarrier1_rgr", // Carrier Lite (Green) VEST"
	"V_PlateCarrier1_rgr_noflag_F", // Carrier Lite (Green, No Flag) VEST"
	// "V_PlateCarrier1_tna_F", // Carrier Lite (Tropic) VEST"
	"V_PlateCarrier2_blk", // Carrier Rig (Black) VEST"
	"V_PlateCarrier2_rgr", // Carrier Rig (Green) VEST"
	"V_PlateCarrier2_rgr_noflag_F", // Carrier Rig (Green, No Flag) VEST"
	"V_PlateCarrier2_tna_F", // Carrier Rig (Tropic) VEST"
	"V_PlateCarrierGL_blk", // Carrier GL Rig (Black) VEST"
	"V_PlateCarrierGL_mtp", // Carrier GL Rig (MTP) VEST"
	"V_PlateCarrierGL_rgr", // Carrier GL Rig (Green) VEST"
	"V_PlateCarrierGL_tna_F", // Carrier GL Rig (Tropic) VEST"
	"V_PlateCarrierH_CTRG", // CTRG Plate Carrier Rig Mk.2 (Heavy) VEST"
	"V_PlateCarrierIA1_dgtl", // GA Carrier Lite (Digi) VEST"
	"V_PlateCarrierIA2_dgtl", // GA Carrier Rig (Digi) VEST"
	"V_PlateCarrierIAGL_dgtl", // GA Carrier GL Rig (Digi) VEST"
	"V_PlateCarrierIAGL_oli", // GA Carrier GL Rig (Olive) VEST"
	"V_PlateCarrierL_CTRG", // CTRG Plate Carrier Rig Mk.1 (Light) VEST"
	"V_PlateCarrierSpec_blk", // Carrier Special Rig (Black) VEST"
	"V_PlateCarrierSpec_mtp", // Carrier Special Rig (MTP) VEST"
	"V_PlateCarrierSpec_rgr", // Carrier Special Rig (Green) VEST"
	"V_PlateCarrierSpec_tna_F", // Carrier Special Rig (Tropic) VEST"
	"V_PlateCarrier_Kerry", // US Plate Carrier Rig (Kerry) VEST"
	// "V_Press_F", // Vest (Press) VEST"
	"V_Rangemaster_belt", // Rangemaster Belt VEST"
	"V_RebreatherB", // Rebreather [NATO] VEST"
	"V_RebreatherIA", // Rebreather [AAF] VEST"
	"V_RebreatherIR", // Rebreather [CSAT] VEST"
	"V_TacChestrig_cbr_F", // Tactical Chest Rig (Coyote) VEST"
	"V_TacChestrig_grn_F", // Tactical Chest Rig (Green) VEST"
	"V_TacChestrig_oli_F", // Tactical Chest Rig (Olive) VEST"
	"V_TacVestIR_blk", // Raven Vest VEST"
	"V_TacVest_blk", // Tactical Vest (Black) VEST"
	// "V_TacVest_blk_POLICE", // Tactical Vest (Police) VEST"
	"V_TacVest_brn", // Tactical Vest (Brown) VEST"
	"V_TacVest_camo", // Tactical Vest (Camo) VEST"
	"V_TacVest_gen_F", // Gendarmerie Vest VEST"
	"V_TacVest_khk", // Tactical Vest (Khaki) VEST"
	"V_TacVest_oli" // Tactical Vest (Olive) VEST"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_backpackLoot =
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
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_explosiveLoot =
[
	"APERSBoundingMine_Range_Mag", // APERS Bounding Mine MAGAZINE"
	"APERSMine_Range_Mag", // APERS Mine MAGAZINE"
	"APERSTripMine_Wire_Mag", // APERS Tripwire Mine MAGAZINE"
	"ATMine_Range_Mag", // AT Mine MAGAZINE"
	"ClaymoreDirectionalMine_Remote_Mag", // Claymore Charge MAGAZINE"
	"DemoCharge_Remote_Mag", // Explosive Charge MAGAZINE"
	"IEDLandBig_Remote_Mag", // Large IED (Dug-in) MAGAZINE"
	"IEDLandSmall_Remote_Mag", // Small IED (Dug-in) MAGAZINE"
	"IEDUrbanBig_Remote_Mag", // Large IED (Urban) MAGAZINE"
	"IEDUrbanSmall_Remote_Mag", // Small IED (Urban) MAGAZINE"
	"SatchelCharge_Remote_Mag", // Explosive Satchel MAGAZINE"
	"SLAMDirectionalMine_Wire_Mag" // M6 SLAM Mine MAGAZINE"
];
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_backpackLoopNum = (floor(random 2) + 1); // BACKPACKS
_ls_explosiveLoopNum = 1; // EXPLOSIVES
_ls_headgearLoopNum = (floor(random 2) + 1); // HEAD GEAR
_ls_surplusLoopNum  = (floor(random 2) + 1); // SURPLUS ITEMS
_ls_uniformLoopNum  = (floor(random 2) + 1); // UNIFORMS
_ls_vestLoopNum     = (floor(random 2) + 1); // VESTS
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_weaponARLoopNum = 1; // ASSAULT RIFLES
_ls_weaponHGLoopNum = 1; // HAND GUNS
_ls_weaponHVLoopNum = 1; // HIGH VELOCITY
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_magazineNumClips = (floor(random 2) + 1); // MAGAZINES PER WEAPON, AT LEAST 1, MAX 3
_ls_magazineLoopNum = (floor(random 2) + 1); // MAGAZINES PER TYPE
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_medicalLoopNum = (floor(random 2) + 1); // MEDICAL
///////////////////////////////////////////////////////////////////////////////////////////////////
_ls_lootTypeArr =
[
	"backpack",
	"backpack",
	"explosive",
	"headgear",
	"headgear",
	"magazine",
	"magazine",
	"surplus",
	"surplus",
	"medical",
	"medical",
	"uniform",
	"uniform",
	"vest",
	"vest",
	"weaponAR",
	"weaponAR",
	"weaponHG",
	"weaponHG",
	"weaponHV"
];
