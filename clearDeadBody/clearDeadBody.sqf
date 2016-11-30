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

	Name: clearDeadBody.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:07 PM 30/11/2016
	Modification Date: 5:07 PM 30/11/2016

	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). The script adds a 'Clear Dead Body'
	action to dead bodies in order to clear/move immediate surrounding dropped items away from the
	dead body at a predefined distance (_maxObjectDistancePlace). This script makes it easier to
	access dead bodies and each dropped item. The action can only be used once per dead body.
	
	Place this file at...
	\addons\clearDeadBody\clearDeadBody.sqf
	
	Place the clearDeadBody.paa icon at...
	\addons\clearDeadBody\clearDeadBody.paa
	
	Edit file...
	\client\functions\playerActions.sqf
	
	And paste in...
	["<img image='addons\clearDeadBody\clearDeadBody.paa'/> Clear Dead Body", "addons\clearDeadBody\clearDeadBody.sqf", [], 1.1, false, false, "", "!(([allDeadMen,[],{player distance _x},'ASCEND',{((player distance _x) < 2) && !(_x getVariable ['SL_clearDeadBody',false])}] call BIS_fnc_sortBy) isEqualTo [])"],
	
	Above the line...
	[format ["<img image='client\icons\playerMenu.paa' color='%1'/>.......

	Parameter(s): NONE

	Example: NONE

	Change Log:
	1.0.0 -	original base script.

	----------------------------------------------------------------------------------------------
*/

_cleanUpObjects = [
	"Land_Suitcase_F", // Repair Kit
	"Land_BakedBeans_F", // Canned Food
	"Land_BottlePlastic_V2_F", // Water Bottle
	"Land_Sleeping_bag_folded_F", // Spawn Beacon
	"Land_CanisterFuel_F", // Jerrycan
	"Land_CanisterOil_F", // Syphon Hose
	"Land_Ground_sheet_folded_OPFOR_F", // Camo Net
	"GroundWeaponHolder", // static weapon holder, all weapons, weapon attachments, magazines, throwables, backpacks, vests, uniforms, helments, etc
	"WeaponHolderSimulated" // simulated weapon holder, all weapons, weapon attachments, magazines, throwables, backpacks, vests, uniforms, helments, etc
];

_maxObjectDistanceGather = 3; // max distance from dead body to gather and move items.
_maxObjectDistancePlace = 2; // max distance from dead body to move items to.

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

_deadBody = ([allDeadMen,[],{player distance _x},"ASCEND",{(player distance _x) < 2}] call BIS_fnc_sortBy) select 0;

if ((alive _deadBody) && !(_deadBody isKindOf "Man")) exitWith {};

_deadBodyAlreadyCleared = _deadBody getVariable ["SL_clearDeadBody",false];

if (_deadBodyAlreadyCleared) exitWith
{
	["Dead Body Was Already Cleared!", 5] call mf_notify_client;
};

_deadBodyNearItems = nearestObjects [_deadBody, _cleanUpObjects, _maxObjectDistanceGather];
{
	_deadBodyHeightATL = (getPosATL _deadBody select 2) + 0.1;
	_relPos = [_deadBody, _maxObjectDistancePlace, round(random 360)] call BIS_fnc_relPos;
	_relPos set [2,_deadBodyHeightATL];
	_x setPos _relPos;
	_x setDir round(random 360);
} forEach _deadBodyNearItems;

_deadBody setVariable ["SL_clearDeadBody",true,true];
