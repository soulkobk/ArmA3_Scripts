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

	Name: hackerOutpost_SL2.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:39 PM 19/06/2018
	Modification Date: 4:39 PM 19/06/2018

	Description:
	Place this file at \server\missions\outposts\hackerOutpost_SL2.sqf
	
	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base outpost.

	----------------------------------------------------------------------------------------------
*/

[
	["Land_Cargo_Patrol_V1_F",[0,0,4.76837e-007],0],
	["Land_CampingTable_F",[1.25,3.375,-0.00259161],360],
	["Land_CampingTable_small_F",[1.75,0.999999,0.00260496],270.001],
	["Land_HBarrier_Big_F",[6.875,6,2.125],90],
	["Land_HBarrier_Big_F",[-0.124998,-8.00002,0],180],
	["Land_HBarrier_Big_F",[-9.07316,-0.971575,0],305.001],
	["Land_HBarrier_Big_F",[-6.875,-6,2.125],270],
	["Land_HBarrier_Big_F",[6.875,6,0],90],
	["Land_HBarrier_Big_F",[9.0732,0.971581,0],125.001],
	["Land_HBarrier_Big_F",[-6.87502,-6.00002,0],270],
	["Land_HBarrier_Big_F",[0.125,8,0],0],
	["Land_HBarrier_3_F",[8.625,-7.125,0],315],
	["Land_HBarrier_3_F",[-1.875,3,1.25],0],
	["Land_HBarrier_3_F",[-8.62502,7.12501,0],135.001],
	["Land_HBarrier_3_F",[-1.875,3,0],0],
	["Land_HBarrier_3_F",[1.875,-3,1.25],0],
	["Land_HBarrier_3_F",[1.875,-3,0],0],
	["Land_LampShabby_F",[3.125,-7.625,0],0],
	["Land_LampShabby_F",[-3.125,7.75,0],180],
	["Land_DragonsTeeth_01_1x1_old_F",[8.625,-8.875,0],0],
	["Land_DragonsTeeth_01_1x1_old_F",[-7.87503,6.37502,0],144.001],
	["Land_DragonsTeeth_01_1x1_old_F",[-8.62502,8.87502,0],180],
	["Land_DragonsTeeth_01_1x1_old_F",[-10,7.25002,0],180],
	["Land_DragonsTeeth_01_1x1_old_F",[10,-7.25,0],0],
	["Land_DragonsTeeth_01_1x1_old_F",[7.875,-6.375,0],324],
	["Land_DragonsTeeth_01_4x2_old_F",[-6.87502,-6.00002,0],270],
	["Land_DragonsTeeth_01_4x2_old_F",[0.125,8,0],0],
	["Land_DragonsTeeth_01_4x2_old_F",[-9.07316,-0.971575,0],305.001],
	["Land_DragonsTeeth_01_4x2_old_F",[6.875,6,0],90],
	["Land_DragonsTeeth_01_4x2_old_F",[9.0732,0.971581,0],125.001],
	["Land_DragonsTeeth_01_4x2_old_F",[-0.124998,-8.00002,0],180],
	["Land_CzechHedgehog_01_new_F",[-3.5,5.25,4.76837e-007],340],
	["Land_CzechHedgehog_01_new_F",[5,-3,4.76837e-007],31],
	["Land_CzechHedgehog_01_new_F",[5.75,-8.25,4.76837e-007],323],
	["Land_CzechHedgehog_01_new_F",[-6.125,10.875,9.53674e-007],22],
	["Land_CzechHedgehog_01_new_F",[10.125,7.75,2.38419e-006],59],
	["Land_CzechHedgehog_01_new_F",[-1.23668,5.28382,9.53674e-007],137.49],
	["Land_SatelliteAntenna_01_F",[6.82879,2.55422,4.32248],43.132],
	["Land_SatelliteAntenna_01_F",[-7.0611,-2.7815,4.30574],44.9729],
	["Land_SatellitePhone_F",[0.87501,3.37502,0.81101],203.002],
	["Land_PCSet_01_screen_F",[1.7498,1.00004,0.813663],277.002],
	["Land_Laptop_F",[1.75001,3.50001,0.811003],222.001], // this is the laptopkl item for use with hacking ATM's
	["O_supplyCrate_F",[0.250095,-1.24976,4.34305],359.997,{_this call randomCrateLoadOut; _this setVariable ["R3F_LOG_disabled",true,true];}]
]
