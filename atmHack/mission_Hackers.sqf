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

	Name: mission_Hackers.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com) - template by [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
	Creation Date: 4:39 PM 19/06/2018
	Modification Date: 4:39 PM 19/06/2018

	Description:
	Place this file at \server\missions\moneyMissions\mission_Hackers.sqf
	
	Edit \server\missions\setupMissionArrays.sqf and add...
	["mission_Hackers", 1]
	at the bottom of the existing 'MoneyMissions' array.
	
	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if (!isServer) exitwith {};

#include "moneyMissionDefines.sqf";

private ["_nbUnits","_outpost","_objects"];

_setupVars =
{
	_missionType = "ATM Hacker";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = selectRandom [12,16,20,24];
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	_outpost = selectRandom (call compile preprocessFileLineNumbers "server\missions\outposts\hackerOutpostsList.sqf");
	_objects = [_outpost, _missionPos, 0] call createOutpost;
	_aiGroup = createGroup CIVILIAN;
	[_aiGroup, _missionPos, _nbUnits, 50] call createCustomGroup;
	_missionHintText = format ["The enemy are attempting to <t color='%1'>hack an ATM</t> remotely, go eradicate the enemy, steal the laptop and go hack an ATM for yourself!",moneyMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	{
		deleteVehicle _x;
	} forEach _objects;
};

_successExec =
{
	{
		_x setVariable ["R3F_LOG_disabled",false,true];
		if ((typeOf _x) isEqualTo "Land_Laptop_F") then
		{
			_x setVariable ["mf_item_id","laptopkl",true]; // allow the laptopkl to be picked up.
		};
	} forEach _objects;
	[_locationsArray, _missionLocation, _objects] call setLocationObjects;
	_successHintMessage = "The enemy have been eradicated from trying to hack an ATM remotely... quick, go steal the laptop for yourself and get out of there!";
};

_this call moneyMissionProcessor;
