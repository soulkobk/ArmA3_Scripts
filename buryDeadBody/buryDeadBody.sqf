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

	Name: buryDeadBody.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com) (base script authors MercyfulFate, AgentRev, Gigatek)
	Creation Date: 12:47 PM 29/10/2016
	Modification Date: 12:47 PM 29/10/2016

	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). The script adds a 'Bury Dead Body'
	action to dead bodies for a COST set in the header of this script (default $5000 of CARRIED
	money). The action will remove dead bodies and immediate surrounding (< 2 meters) dropped items.
	
	Place this file at...
	\addons\buryDeadBody\buryDeadBody.sqf
	
	Place the buryDeadBody.paa icon at...
	\addons\buryDeadBody\buryDeadBody.paa
	
	Edit file...
	\client\functions\playerActions.sqf
	
	And paste in...
	["<img image='addons\buryDeadBody\buryDeadBody.paa'/> Bury Dead Body", "addons\buryDeadBody\buryDeadBody.sqf", [], 1.1, false, false, "", "!isNull cursorObject && !alive cursorObject && {cursorObject isKindOf 'Man' && player distance cursorObject <= 2}"],
	
	Above the line...
	[format ["<img image='client\icons\playerMenu.paa' color='%1'/>.......

	Parameter(s): NONE

	Example: NONE

	Change Log:
	1.0.0 -	original base script. all credit to original authors of base script.

	----------------------------------------------------------------------------------------------
*/

_price = 5000;
_duration = (round (random 30)) + 30;
_animation = "AinvPknlMstpSlayWrflDnon_medic";

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

#define FORMAT1(STR1,STR2) format ["%1 %2", STR1, STR2]
#define ERR_FAILED "Burying Dead Body Failed!"
#define ERR_IN_VEHICLE "You Can't Bury A Dead Body Whilst In A Vehicle."
#define ERR_ALIVE "This Is No Dead Body!"
#define ERR_CANCELLED "Burying Dead Body Cancelled!"

private _deadBody = cursorObject;

if ((alive _deadBody) && !(_deadBody isKindOf "Man")) exitWith {};

if ((typeName _price != "SCALAR") || (typeName _duration != "SCALAR")) exitWith {};

_deadBodyBuried = (_deadBody getVariable ["buryDeadBodyBurried",nil]);
if (!isNil "_deadBodyBuried") exitWith
{
	["Dead Body Is Already Successfully Burried!", 5] call mf_notify_client;
};

_durationStatic = (_deadBody getVariable ["buryDeadBodyDuration",nil]);
if (!isNil "_durationStatic") then
{
	_duration = _durationStatic;
}
else
{
	_deadBody setVariable ["buryDeadBodyDuration",_duration];
};

_playerCMoney = player getVariable ["cmoney",0];
uiSleep 0.1;

if (_playerCMoney < _price) exitWith
{
	_text = format ["Burying A Dead Body Costs $%1, You Do Not Have Enough Carried Money!",_price];
	[_text, 5] call mf_notify_client;
};

_text = format ["\n\n\nBurying A Dead Body Will Cost You $%1, You Can Cancel At Anytime Before It Reaches 100%2 Complete!",_price,"%"];
[_text, _duration] call mf_notify_client;

private _checks =
{
	params ["_progress", "_vehicle"];
	private _failed = true;
	private _text = "";
	switch (true) do
	{
		case (!alive player): {};
		case (vehicle player != player): { _text = FORMAT1(ERR_FAILED, ERR_IN_VEHICLE); };
		case (alive _deadBody): { _text = FORMAT1(ERR_FAILED, ERR_ALIVE); };
		case (doCancelAction): { _text = ERR_CANCELLED; doCancelAction = false; };
		default
		{
			_text = format ["Burying Dead Body... %1%2 Complete",round(100 * _progress),"%"];
			_failed = false;
		};
	};
	[_failed, _text]
};

private _outcome = [_duration, _animation, _checks, [_deadBody]] call a3w_actions_start;

if (_outcome) then
{
	["Burying Of Dead Body Successful!", 5] call mf_notify_client;
	_deadBody setVariable ["buryDeadBodyBurried",true];
	player setVariable ["cmoney",(_playerCMoney - _price),true];
	_deadBodyObjects = nearestObjects [_deadBody, ["GroundWeaponHolder","WeaponHolderSimulated"], 2];
	{
		deleteVehicle _x;
	} forEach _deadBodyObjects;
	_deadBody enableSimulationGlobal false;
	_deadBodyPos = getPosATL _deadBody;
	_deadBodyLoop = 0;
	while {(!isNull _deadBody) || (_deadBodyLoop < 50)} do
	{
		for "_i" from (_deadBodyPos select 2) to ((_deadBodyPos select 2) - 0.5) step -0.01 do
		{
			_deadBodyPos set [2,_i];
			_deadBody setPosATL _deadBodyPos;
			uiSleep 0.1;
		};
		deleteVehicle _deadBody;
		_deadBodyLoop = _deadBodyLoop + 1;
		uiSleep 0.5;
	};
	if (!isNull _deadBody) then
	{
		["Someone Dug Up The Dead Body, You Get A Refund!", 5] call mf_notify_client;
		_deadBody enableSimulationGlobal true;
		player setVariable ["cmoney",(_playerCMoney + _price),true];
	};
};

_outcome
