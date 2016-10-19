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

	Name: cleanupMissionObjects.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 6:59 PM 06/06/2016
	Modification Date: 10:47 PM 13/06/2016

	Description:
	Coded for use with A3Wasteland 1.Xx mission, to clean up mission objects after a successful
	mission, and after a certain time period (currently set at 10 minutes after mission complete).
	It will cycle through all objects found at the location given and delete objects in the
	_missionObjectsToDelete array if no 'man' are close by or object has been locked (change
	of ownership) within the radius set in this script.

	Place this script in directory...
	\server\missions\factoryMethods\cleanupMissionObjects.sqf

	Edit...
	\server\functions\serverCompile.sqf

	And paste in...
	cleanupMissionObjects = [_path, "cleanupMissionObjects.sqf"] call mf_compile;

	Underneath the line...
	//Factory Compiles

	Edit...
	\server\missions\missionProcessor.sqf

	And paste in...
	[markerPos _missionLocation] spawn cleanupMissionObjects;

	Directly after the line...
	diag_log format ["WASTELAND SERVER - %1 Mission%2 complete: %3", MISSION_PROC_TYPE_NAME, _controllerSuffix, _missionType];

	Parameter(s): position array ([x,y,z])

	Example: [markerPos _missionLocation] spawn cleanupMissionObjects;

	Change Log:
	1.0.0 -	original base script for object delete.

	----------------------------------------------------------------------------------------------
*/

_missionRadius = 25; // 25 = 25 meters radius around mission spawn.

_missionTimeWait = 10*60; // 10*60 = 10 minutes, aka 600 seconds.

_missionObjectsToDelete = [
	"B_CargoNet_01_ammo_F",
	"CamoNet_BLUFOR_open_F",
	"CargoNet_01_barrels_F",
	"I_HMG_01_high_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Tower_F",
	"Land_BagFence_Corner_F",
	"Land_BagFence_End_F",
	"Land_BagFence_Long_F",
	"Land_BagFence_Round_F",
	"Land_BagFence_Short_F",
	"Land_BarGate_F",
	"Land_BarrelSand_F",
	"Land_Cargo20_military_green_F",
	"Land_Cargo_House_V3_F",
	"Land_Cargo_HQ_V3_F",
	"Land_Cargo_Patrol_V1_F",
	"Land_Cargo_Patrol_V2_F",
	"Land_Cargo_Patrol_V3_F",
	"Land_Cargo_Tower_V1_F",
	"Land_CncBarrierMedium4_F",
	"Land_CncWall4_F",
	"Land_CratesWooden_F",
	"Land_HBarrierBig_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_Big_F",
	"Land_LampHalogen_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WallBig_Corner_F",
	"Land_Pillow_camouflage_F",
	"Land_PowerGenerator_F",
	"Land_Sleeping_bag_F",
	"Land_SolarPanel_1_F",
	"Land_TTowerSmall_1_F"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

_missionPosition = param [0, [0,0,0], [],3];

if (_missionPosition isEqualTo [0,0,0]) exitWith {};

uiSleep _missionTimeWait;

_anyPlayersAround = nearestObjects [_missionPosition, ["MAN"], _missionRadius];
while {((count _anyPlayersAround) > 0)} do
{
	_anyPlayersAround = nearestObjects [_missionPosition, ["MAN"], _missionRadius];
	uiSleep (_missionTimeWait / 2);
};

_anyObjectsAround = nearestObjects [_missionPosition, ["ALL"], _missionRadius];
_anyObjectsAroundCount = (count _anyObjectsAround);
_anyObjectsAroundDeleted = 0;
{
	if (_x getVariable ["ownerUID", ""] == "") then
	{
		_typeOfObject = typeOf _x;
		if (_typeOfObject in _missionObjectsToDelete) then
		{
			deleteVehicle _x;
			_anyObjectsAroundDeleted = _anyObjectsAroundDeleted + 1;
		};
	};
} forEach _anyObjectsAround;

diag_log format ["[CLEANUP MISSION OBJECTS] - CLEANED UP %1 OBJECT(S) OF %2 FOUND WITHIN %3 METERS RADIUS OF POSITION %4", _anyObjectsAroundDeleted, _anyObjectsAroundCount, _missionRadius, _missionPosition];
