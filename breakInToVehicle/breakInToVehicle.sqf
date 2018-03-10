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
	
	Name: breakInToVehicle.sqf - credits to MercyfulFate, AgentRev, Gigatek for original base code
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:12 PM 29/09/2016
	Modification Date: 12:12 PM 29/09/2016
	
	Description:
	Break in to vehicle replacement script with custom sound effects and loop. Player must have a
	toolkit in order to be able to break in to vehicles.
	
	Place this script at...
	\addons\breakInToVehicle\breakInToVehicle.sqf
	
	Place the sounds at...
	\addons\breakInToVehicle\sounds\*
	
	Edit...
	\client\functions\playerActions.sqf
	Add in the code...
	if (["A3W_vehicleLocking"] call isConfigOn) then
	{
		[player, ["<img image='client\icons\r3f_unlock.paa'/> Break In To Vehicle", "addons\breakInToVehicle\breakInToVehicle.sqf", [cursorTarget], 1, false, false, "", "alive cursorTarget && !isNull cursorTarget && isNull objectParent player && {{ cursorTarget isKindOf _x } count ['LandVehicle', 'Ship', 'Air'] > 0 ;} && cursorTarget getVariable ['ownerUID',''] != getPlayerUID player && locked cursorTarget >= 2 && cursorTarget distance player < 4 && ('ToolKit' in (items player))"]] call fn_addManagedAction;
	};

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.
	
	----------------------------------------------------------------------------------------------
*/

#define DURATION (round (random 30)) + 30
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"

#define FORMAT2(STR1,STR2) format ["%1 %2", STR1, STR2]
#define ERR_FAILED "Breaking In To Vehicle Failed!"
#define ERR_IN_VEHICLE "You Can't Do That Whilst In A Vehicle."
#define ERR_DISTANCE "You Are Too Far Away From The Vehicle."
#define ERR_MOVED "Somebody Moved The Vehicle."
#define ERR_TOWED "Somebody Towed Or Lifted The Vehicle."
#define ERR_UNLOCKED "The Vehicle Is Unlocked."
#define ERR_CREW "Somebody Is Inside The Vehicle."
#define ERR_DESTROYED "The Vehicle Is Destroyed."
#define ERR_CANCELLED "Breaking In To Vehicle Cancelled!"

private _vehicle = ["LandVehicle", "Air", "Ship"] call mf_nearest_vehicle;

if (_vehicle getVariable ["breakInToVehicleAlarmOn", false]) exitWith {};

private _checks =
{
	params ["_progress", "_vehicle"];
	private _failed = true;
	private _text = "";

	switch (true) do
	{
		case (!alive player): { _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; }; // player is dead, no need for a notification
		case (vehicle player != player): { _text = FORMAT2(ERR_FAILED, ERR_IN_VEHICLE); _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; };
		case (!alive _vehicle): { _text = FORMAT2(ERR_FAILED, ERR_DESTROYED); _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; };
		case (locked _vehicle < 2): { _text = FORMAT2(ERR_FAILED, ERR_UNLOCKED); _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; };
		case ({alive _x} count crew _vehicle > 0): { _text = FORMAT2(ERR_FAILED, ERR_CREW); _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; };
		case (doCancelAction): { _text = ERR_CANCELLED; doCancelAction = false; _vehicle setVariable ["breakInToVehicleAlarmOn", false, true]; };
		default
		{
			_text = format ["Breaking In To Vehicle... %1%2 Complete", round(100 * _progress), "%"];
			_failed = false;
		};
	};
	[_failed, _text]
};

_soundThread = [_vehicle] spawn {
	params ["_vehicle"];
	_soundFiles = ["vehicleAlarm-01-001.ogg","vehicleAlarm-01-002.ogg","vehicleAlarm-01-003.ogg","vehicleAlarm-01-004.ogg","vehicleAlarm-01-005.ogg","vehicleAlarm-01-006.ogg"];
	_s = 0;	_sound = 0; _vehicle setVariable ["breakInToVehicleAlarmOn", true];
	while {(_vehicle getVariable ["breakInToVehicleAlarmOn", false])} do
	{
		_soundFile = (_soundFiles select _sound);
		_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
		_soundToPlay = _soundPath + "addons\breakInToVehicle\sounds\" + _soundFile;
		playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 2, 1, 300];
		uiSleep 1;
		_s = _s + (1 / 4);
		if (_s >= (count _soundFiles)) then {_s = 0};
		_sound = (floor _s);
	};
};

private _outcome = [DURATION, ANIMATION, _checks, [_vehicle]] call a3w_actions_start;

if (_outcome) then
{
	_vehicle call fn_forceSaveVehicle;
	["Break In To Vehicle Successful!", 5] call mf_notify_client;
	terminate _soundThread;
	uiSleep 1;
	[_vehicle, 1] call A3W_fnc_setLockState; // Unlock
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "addons\breakInToVehicle\sounds\vehicleAlarm-01-007.ogg";
	_sound = playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 2, 1, 150];
	_soundToPlay = _soundPath + "addons\breakInToVehicle\sounds\vehicleAlarm-01-008.ogg";
	_sound = playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 1, 1, 150];
};

if !(_outcome) then
{
	terminate _soundThread;
	uiSleep 1;
	_soundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
	_soundToPlay = _soundPath + "addons\breakInToVehicle\sounds\vehicleAlarm-01-000.ogg";
	_sound = playSound3D [_soundToPlay, _vehicle, false, getPosASL _vehicle, 2, 1, 150];
};

uiSleep 1;
_vehicle setVariable ["breakInToVehicleAlarmOn", false, true];

_outcome
