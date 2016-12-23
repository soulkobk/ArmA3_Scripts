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

	Name: deadBodyFlies.sqf
	Version: 1.0.1
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 8:34 PM 16/12/2016
	Modification Date: 7:38 PM 23/12/2016

	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). The script spawns flies with sound
	effects to dead bodies after a certain duration has passed (1/4 of the total corpseRemovalMinTime)

	The flies and sound effects will be present until the corpse has been removed (despawned by the
	ArmA 3 engine). The sound effects are audible up until 50 from the dead body... the close you
	get, the louder the sound effect.
	
	This script was made to introduce more immersion in to the game, as naturally dead bodies will
	decompose, which would attract flies (and other insects)... this script mimics that.

	Place this file at...
	\server\functions\deadBodyFlies.sqf

	Place the deadBodyFlies.ogg sound effect file at...
	\server\sounds\deadBodyFlies.ogg

	Edit the file...
	\globalCompile.sqf

	And paste in...
	deadBodyFlies = [_serverFunc, "deadBodyFlies.sqf"] call mf_compile; // deadBodyFlies by soulkobk

	Below the line...
	vehicleHitTracking = [_serverFunc, "vehicleHitTracking.sqf"] call mf_compile;
	
	Edit the file...
	\server\functions\serverPlayerDied.sqf
	
	And paste in...
	[_unit] call deadBodyFlies; // deadBodyFlies by soulkobk
	
	Below the line...
	_unit setVariable ["processedDeath", diag_tickTime];

	Parameter(s): NONE

	Example: NONE

	Change Log:
	1.0.0 -	original base script.
	1.0.1 -	added check for water surface and depth (exit if on/under water, as dead bodies will
			sink to the bottom... there are no flies under water!). reduced flies particle loop.

	----------------------------------------------------------------------------------------------
*/

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

_deadUnit = _this select 0;

if ((surfaceIsWater (getPosASL _deadUnit)) && (((getPosASL _deadUnit) select 2) < 0)) exitWith {};

[_deadUnit] spawn
{
	params ["_deadUnit"];
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundFlies = _soundPath + "server\sounds\deadBodyFlies.ogg";
	_corpseTime = getNumber (missionconfigfile >> "corpseRemovalMinTime");
	uiSleep (_corpseTime / 4);
	_deadUnitPosFlies = getPosATL _deadUnit;
	_fliesArr = [];
	for "_fly" from 0 to 1 do
	{
		_flies = [_deadUnitPosFlies, 0.05, 1.5] call BIS_fnc_flies;
		_fliesArr pushBackUnique _flies;
	};
	_deadUnitPosSound = getPosASL _deadUnit;
	while {(_deadUnit in allDeadMen)} do
	{
		_pitch = selectRandom [0.8,0.9,1.0,1.1,1.2];
		_sound = playSound3D [_soundFlies, _deadUnit, false, _deadUnitPosSound, 1, _pitch, 50];
		uiSleep 8.5;
	};
	{
		_flies = _x;
		{
			deleteVehicle _x;
		} forEach _flies;
	} forEach _fliesArr;
};
