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

	Name: lootSpawner.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 12:00 PM 03/02/2018

	Description:
	this was written by me (soulkobk) whilst i was learning how to code arma 3, so the code is unoptimized.

	this script comes as a part of the lootSpawnerBPM script package, and is the actual loot spawner
	that is used with the manual building positions. see lootSpawnerConfig for everything able to
	be changed to suit your own needs.

	Parameter(s):
	[position,radius] execVM "lootSpawner\lootSpawner.sqf";

	example...
	[position player,250] execVM "lootSpawner\lootSpawner.sqf";
	
	0 = [] spawn
	{
		{
			if !((_x find "lootSpawner") isEqualTo -1) then
			{
				_markerPos = getMarkerPos _x;
				_markerSize = selectMax getMarkerSize _x;
				_x setMarkerColor "colorOrange";
				_lootSpawnerThread = [_markerPos,_markerSize] execVM "lootSpawner\lootSpawner.sqf";
				waitUntil {scriptDone _lootSpawnerThread};
				_x setMarkerColor "colorGreen";
			};
		} forEach allMapMarkers;
	};

	Example: none

	Change Log:
	1.0.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

///////////////////////////////////////////////////////////////////////////////////////////////////
// DO NOT EDIT ANYTHING BELOW HERE
///////////////////////////////////////////////////////////////////////////////////////////////////
if (!isServer) exitWith {};
///////////////////////////////////////////////////////////////////////////////////////////////////
#include "lootSpawnerConfig.sqf";
///////////////////////////////////////////////////////////////////////////////////////////////////
params ["_centerPos","_centerRadius"];
if ((isNil "_centerPos") || (isNil "_centerRadius")) exitWith
{
	if (_showHints) then
	{
		hint "[LS] - LOOT SPAWNER -> EXITED! CENTERPOS OR CENTERRADIUS WAS NOT PARSED.";
	};
	diag_log "[LS] - LOOT SPAWNER -> EXITED! CENTERPOS OR CENTERRADIUS WAS NOT PARSED.";
};
///////////////////////////////////////////////////////////////////////////////////////////////////
#include "..\buildingPosManual.sqf";
///////////////////////////////////////////////////////////////////////////////////////////////////
_start = diag_tickTime;
///////////////////////////////////////////////////////////////////////////////////////////////////
diag_log format ["[LS] - LOOT SPAWNER BEGIN -> BUILDING DAMAGE %1, OPEN DOORS %2, LOOT SPAWNER %3 AT %4%5",_ls_buildingDamage,_ls_openDoors,_ls_lootSpawn,_ls_lootSpawnProbability,"%"];
///////////////////////////////////////////////////////////////////////////////////////////////////
if (_ls_buildingDamage) then
{
	_buildingsToDamage = nearestObjects [_centerPos,["House","HouseBase","Ruins","House_F","Ruins_F"],_centerRadius];
	_bldDamageNum = 0;
	for [{_i = 0},{_i < (count _buildingsToDamage)},{_i =_i + 1}] do
	{
		_bld = _buildingsToDamage select _i;
		if (_bld isKindOf "Man") exitWith {};
		if (_bld isKindOf "Car") exitWith {};
		if (_bld isKindOf "Boat") exitWith {};
		if (getDammage _bld == 1) exitWith {};
		_bldType = typeOf _bld;
		_bldIsRuin = _bldType find "ruin";
		if (_bldIsRuin == -1) then
		{		
			if !(_bldType in _ls_buildingExclusion) then
			{
				if (_ls_buildingDamageProbability > random 100) then
				{
					_bld setDamage [1,false];
					_bldDamageNum = _bldDamageNum + 1;
				};
			};
		};
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	diag_log format ["[LS] - LOOT SPAWNER -> %1 OF %2 BUILDINGS DAMAGED",_bldDamageNum,(count _buildingsToDamage)];
	///////////////////////////////////////////////////////////////////////////////////////////////////
	if (_showHints) then
	{
		hint format ["DAMAGED\n%1 OF %2\nBUILDING(S)",_bldDamageNum,(count _buildingsToDamage)];
		uiSleep 5;
	};
};
/////////////////////////////////////////////////////////////////////////////////////////////////
_building = nearestObjects [_centerPos,["House","HouseBase","Ruins","House_F","Ruins_F"],_centerRadius];
_bldTypeArr = [];
_bldPosArr = [];
_bldPosLast = [];
_lootPositions = 0;
_numPositions = 0;
_mkrDBUG = "";
/////////////////////////////////////////////////////////////////////////////////////////////////
diag_log format ["[LS] - LOOT SPAWNER -> GATHERING BUILDING POSITIONS FOR %1 BUILDINGS",(count _building)];
///////////////////////////////////////////////////////////////////////////////////////////////////
for [{_i = 0},{_i < (count _building)},{_i =_i + 1}] do
{
	_bld = _building select _i;
	_bldType = typeOf _bld;
	_bldDamage = (damage _bld);
	
	if (_bld isKindOf "Man") then {_bldDamage = 1};
	if (_bld isKindOf "Car") then {_bldDamage = 1};
	if (_bld isKindOf "Boat") then {_bldDamage = 1};
	if (_bldDamage != 1) then
	{
		if (!(_bldType in _ls_buildingExclusion)) then
		{
			_bldPos = _bld buildingPos 0;
			_bldDir = getDir _bld;
			_bldIsRuin = _bldType find "ruin";
			_bldPosNo = false;
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if (_ls_openDoors) then
			{
				_numDoors = getNumber (configFile / "CfgVehicles" / _bldType / "numberOfDoors");
				if (_numDoors > 0) then
				{
					if (_bldIsRuin == -1) then
					{
						for [{_door = 0},{_door < _numDoors},{_door = _door + 1}] do
						{
							if (_ls_openDoorsProbability > random 100) then
							{
								_bld animate ["door_" + str _door + "_rot",1];
							};
						};
					};
				};
			};
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if (str _bldPos == "[0,0,0]") then
			{
				_bldPosNo = true;
				_bldPos = getPosATL _bld;
			};
			if (str _bldPos == str _bldPosLast) exitWith {};
			if (str _bldPos == "[0,0,0]") exitWith {};
			if (str _bldPos == "[]") exitWith {};
			_bldPosLast = _bldPos;
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if (_showHints) then
			{
				_mkrDBUGID = format ["hints-%1",_bldPos];
				_mkrDBUG = createMarker [_mkrDBUGID,_bldPos];
				_mkrDBUG setMarkerColor "ColorOrange";
				_mkrDBUG setMarkerShape "ICON";
				_mkrDBUG setMarkerType "mil_box";
				_mkrDBUG setMarkerAlpha 1;
				_mkrDBUG setMarkerSize [0.7,0.7];
				hint format["PROCESSING OBJECT\n%1\nAT POSITION\n%2",_bldType,_bldPos];
			};
			if (_showMapBuildings) then
			{
				_showBuildings = false;
				_bbr = boundingBoxReal _bld;
				_p1 = _bbr select 0;
				_p2 = _bbr select 1;
				_maxWidth = round (abs ((_p2 select 0) - (_p1 select 0)));
				_maxLength = round (abs ((_p2 select 1) - (_p1 select 1)));
				_maxHeight = round (abs ((_p2 select 2) - (_p1 select 2)));
				_mkrMapID = format ["mapBuildings-%1",_bldPos];
				_mkrMap = createMarker [_mkrMapID,getPos _bld];
				_mkrMap setMarkerColor "ColorBLUFOR";
				_mkrMap setMarkerShape "RECTANGLE";
				_mkrMap setMarkerAlpha 1;
				_mkrMap setMarkerBrush "SOLIDFULL";
				_mkrMap setMarkerSize [(_p1 select 0),(_p1 select 1)];
				_mkrMap setMarkerDir _bldDir;
			};
			if (_showBuildings) then
			{
				_bbr = boundingBoxReal _bld;
				_p1 = _bbr select 0;
				_p2 = _bbr select 1;
				_maxWidth = round (abs ((_p2 select 0) - (_p1 select 0)));
				_maxLength = round (abs ((_p2 select 1) - (_p1 select 1)));
				_maxHeight = round (abs ((_p2 select 2) - (_p1 select 2)));
				_mkrBoxID = format ["buildings-%1",_bldPos];
				_mkrBox = createMarker [_mkrBoxID,getPos _bld];
				if (_bldPosNo) then
				{
					if (_bldIsRuin == -1) then
					{
						_mkrBox setMarkerColor "ColorRed";
					} else {
						_mkrBox setMarkerColor "ColorBlack";
					};
				} else {
					if (_bldIsRuin == -1) then
					{
						_mkrBox setMarkerColor "ColorGreen";
					} else {
						_mkrBox setMarkerColor "ColorKhaki";
					};
				};
				_mkrBox setMarkerShape "RECTANGLE";
				_mkrBox setMarkerAlpha 0.5;
				_mkrBox setMarkerBrush "SOLIDBORDER";
				_mkrBox setMarkerSize [(_p1 select 0),(_p1 select 1)];
				_mkrBox setMarkerDir _bldDir;
				if (_showBuildingsLabel) then
				{
					_mkrDotID = format ["buildingLabel-%1",_bldPos];
					_mkrDot = createMarker [_mkrDotID,getPos _bld];
					_mkrDotTxt = format ["%1 (FACING %2 DEGREES)",_bldType,_bldDir];
					_mkrDot setMarkerText _mkrDotTxt;
					if (_bldPosNo) then
					{
						_mkrDot setMarkerColor "ColorBlack";
					} else {
						_mkrDot setMarkerColor "ColorBlack";
					};
					_mkrDot setMarkerShape "ICON";
					_mkrDot setMarkerType "hd_dot";
					_mkrDot setMarkerAlpha 1;
					_mkrDot setMarkerDir _bldDir;
				};
			};
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if !(_bldType in _bldTypeArr) then
			{
				_bldTypeArr pushBack _bldType;
			};
			///////////////////////////////////////////////////////////////////////////////////////////////////
			for [{_o = 0},{_o < 100},{_o = _o + 1}] do
			{
				_buildingPos = _bld buildingPos _o;
				///////////////////////////////////////////////////////////////////////////////////////////////////
				if (str _buildingPos == "[0,0,0]") exitWith 
				{
					for [{_p = 0},{_p < _ls_zeroBuildingPosLoops},{_p = _p + 1}] do
					{
						_buildingPosCount = 1;
						_buildingPosOK = false;
						while {!_buildingPosOK} do
						{
							_buildingPos = getPos _bld findEmptyPosition [0,_buildingPosCount,"Land_BarrelEmpty_F"];
							if (!(str _buildingPos == "[]")) then
							{
								_buildingPosOK = true;
								_buildingPlacedObject = createVehicle ["Land_BarrelEmpty_F",[(_buildingPos select 0),(_buildingPos select 1),((_buildingPos select 2) + 0.1)], [], 0, "CAN_COLLIDE"];
								_buildingPlacedObject setVelocity [0,0,0.5];
								uiSleep 0.01;
							};
							_buildingPosCount = _buildingPosCount + 1;
						};
						if !(_buildingPos in _bldPosArr) then
						{
							_bldPosArr pushBack _buildingPos;
						};
						///////////////////////////////////////////////////////////////////////////////////////////////
						if (_showBuildingsPositions) then
						{
							_mkrBPOID = format ["%1-BPO",_buildingPos];
							_mkrBPO = createMarker [_mkrBPOID,_buildingPos];
							_mkrBPO setMarkerColor "ColorRed";
							_mkrBPO setMarkerShape "ICON";
							_mkrBPO setMarkerType "mil_circle";
							_mkrBPO setMarkerAlpha 1;
							_mkrBPO setMarkerSize [0.5,0.5]; 
						};
						///////////////////////////////////////////////////////////////////////////////////////////////
					};
					{ deleteVehicle _x; } forEach nearestObjects [_bld,["Land_BarrelEmpty_F"],100];
				};
				///////////////////////////////////////////////////////////////////////////////////////////////////
				if !(_buildingPos in _bldPosArr) then
				{
					_bldPosArr pushBack _buildingPos;
				};
				///////////////////////////////////////////////////////////////////////////////////////////////////
				if (_showBuildingsPositions) then
				{
					_mkrBPID = format ["%1-BP",_buildingPos];
					_mkrBP = createMarker [_mkrBPID,_buildingPos];
					_mkrBP setMarkerColor "ColorGreen";
					_mkrBP setMarkerShape "ICON";
					_mkrBP setMarkerType "mil_circle";
					_mkrBP setMarkerAlpha 1;
					_mkrBP setMarkerSize [0.5,0.5];
				};
			};
			///////////////////////////////////////////////////////////////////////////////////////////////////
			if !(isNil format ["_buildingPos_%1",_bldType]) then
			{
				private "_buildingPosManual";
				call compile format ["_buildingPosManual = _buildingPos_%1",_bldType];
				if (typeName _buildingPosManual == "ARRAY") then
				{
					for [{_a = 0},{_a < (count _buildingPosManual)},{_a = _a + 1}] do
					{
						_bldPos = getPos _bld;
						_buildingPosCurrent = _buildingPosManual select _a;
						_buildingPos = _bld modelToWorld _buildingPosCurrent;
						if !(_buildingPos in _bldPosArr) then
						{
							_bldPosArr pushBack _buildingPos;
						};
						if (_showBuildingsPositions) then
						{
							_mkrBPID = format ["%1-BP",_buildingPos];
							_mkrBP = createMarker [_mkrBPID,_buildingPos];
							_mkrBP setMarkerColor "ColorYellow";
							_mkrBP setMarkerShape "ICON";
							_mkrBP setMarkerType "mil_circle";
							_mkrBP setMarkerAlpha 1;
							_mkrBP setMarkerSize [0.5,0.5];
						};
					};
				};
			};
			///////////////////////////////////////////////////////////////////////////////////////////////////
			deleteMarker format ["%1",_mkrDBUG];
		};
	};
};
/////////////////////////////////////////////////////////////////////////////////////////////////
diag_log format ["[LS] - LOOT SPAWNER -> SPAWNING LOOT WITH A PROBABILITY OF %1%2",_ls_lootSpawnProbability,"%"];
///////////////////////////////////////////////////////////////////////////////////////////////////
if (_ls_lootSpawn) then
{
	if (_showHints) then
	{
		hint format ["SPAWNING LOOT\nWITH A PROBABILITY OF\n%1 PERCENT",_ls_lootSpawnProbability];
	};
	_lootPositions = 0;
	for [{_i = 0},{_i < (count _bldPosArr)},{_i = _i + 1}] do
	{
		_buildingPos = (_bldPosArr select _i);
		if ((_ls_lootSpawnProbability == 100) || (_ls_lootSpawnProbability > random 100)) then
		{
			null = [_buildingPos,_showLoot] execVM "lootSpawner\lootSpawnerGen.sqf";
			_lootPositions = _lootPositions + 1;
		};
	};
	if (_showHints) then
	{
		hint format ["BUILDING POSITIONS\nAND\nLOOT SPAWNER TOOK\n%1 MINUTE(S)\nTO COMPLETE",((diag_tickTime - _start) / 60)];
	};
} else {
	if (_showHints) then
	{
		hint format ["COMPILING OF\nBUILDING POSITIONS TOOK\n%1 MINUTE(S)\nTO COMPLETE",((diag_tickTime - _start) / 60)];
	};
};
///////////////////////////////////////////////////////////////////////////////////////////////////
diag_log format ["[LS] - LOOT SPAWNER -> COMPLETE, SPAWNED LOOT AT %1 OUT OF %2 POSSIBLE POSITIONS [%3 SECONDS ELAPSED]",_lootPositions,(count _bldPosArr),(diag_tickTime - _start)];
///////////////////////////////////////////////////////////////////////////////////////////////////
