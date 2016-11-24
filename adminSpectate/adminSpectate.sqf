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

	Name: adminSpectate.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:02 PM 17/11/2016
	Modification Date: 7:02 PM 17/11/2016

	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script will enable the built-in
	ArmA 3 spectate system for use within A3Wasteland, which is a much nicer and easier spectate
	system to use and control. It will also allow AI spectating as well as player spectating via
	a configuration entry/toggle.
	
	When in spectate mode, your in-game character is hidden/invisible, unable to take damage or be
	interacted with. When cancelling spectate mode, your in-game character will reappear at the
	same position as previous and will function as normal. It will also re-enable your previous player
	view (3rd person/1st person) and ear plug state (muted/unmuted).
	
	Place this script at...
	\client\systems\adminPanel\adminSpectate.sqf
	
	Edit...
	\client\systems\adminPanel\optionSelect.sqf
	
	And paste in...
	case <number>: // admin spectate (soulkobk)
	{
		closeDialog 0;
		execVM "client\systems\adminPanel\adminSpectate.sqf";
	};
	
	Within the existing switch code...
	switch (lbCurSel _adminSelect) do { <here> };

	Be sure to change <number> to a consecutive number within the 'case #:' structure. eg 'case 9:'.
	
	Edit...
	\client\systems\adminPanel\loadServerAdministratorMenu.sqf
	
	Paste in...
	"Spectate"
	
	Into the existing variable array at the bottom of the list...
	_panelOptions = [ <here> ];
	
	Change the _enableAISpectating variable below...
	enable PLAYER and AI spectating = true
	enable PLAYER ONLY spectating = false
	
	Access to spectate is via the 'U' key to activate/deactivate (toggle) spectate mode (admins only).
	
	Parameter(s): NONE

	Example: NONE

	Change Log:
	1.0.0 -	original base script.

	----------------------------------------------------------------------------------------------
*/

_enableAISpectating = true; // default true. allowed values, true or false.

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

addLocations = {
	_townMarkerArray = [];
	{
		if (["Town_", _x] call fn_startsWith) then
		{
			_townMarkerArray pushBack _x;
		};
	} forEach allMapMarkers;
	_townDetails = compileFinal preprocessFileLineNumbers "mapConfig\towns.sqf";
	{
		_townMarkerCurr = _x;
		{
			_townMarkerName = _x select 0;
			_townMarkerRadius = _x select 1;
			_townMarkerCityName = _x select 2;
			_townMarkerPos = getMarkerPos _townMarkerName;
			_townMarkerPos set [2,20];
			_townIcon = "\A3\3den\Data\Displays\Display3DEN\PanelLeft\locationList_ca.paa";
			if (_townMarkerCurr isEqualTo _townMarkerName) then
			{
				["AddLocation", [_townMarkerName,_townMarkerCityName,"",_townIcon,[_townMarkerPos,[0,0,0],[0,0,0]],[0, false]]] call BIS_fnc_EGSpectator;
			};
		} forEach (call _townDetails);
	} forEach _townMarkerArray;
};

if (isNil "isAdminSpectating") then
{
	isAdminSpectating = true;
}
else
{
	isAdminSpectating = false;
};

if (isAdminSpectating) then
{
	hint "Spectate ON";
	playerSoundVolume = soundVolume;
	playerCameraView = cameraView;
	0.2 fadeSound 1;
	["Initialize", [player, [], _enableAISpectating]] call BIS_fnc_EGSpectator;
	[] spawn {call addLocations};
	[player, true] call fn_hideObjectGlobal;
	pvar_enableSimulationGlobal = [player,false];
	publicVariableServer "pvar_enableSimulationGlobal";
	player allowDamage false;
	closeDialog 0;
}
else
{
	hint "Spectate OFF";
	0.2 fadeSound playerSoundVolume;
	["Terminate"] call BIS_fnc_EGSpectator;
	[player, false] call fn_hideObjectGlobal;
	pvar_enableSimulationGlobal = [player,true];
	publicVariableServer "pvar_enableSimulationGlobal";
	player allowDamage true;
	player switchCamera playerCameraView;
	isAdminSpectating = nil;
	closeDialog 0;
};

waitUntil {!isNull findDisplay 60492};
_spectatePress = (findDisplay 60492) displayAddEventHandler ["KeyDown", onKeyPress];
_spectateRelease = (findDisplay 60492) displayAddEventHandler ["KeyUp", onKeyRelease];
