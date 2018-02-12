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

	Name: getPositions.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 6:00 PM 02/02/2018

	Description:

	Parameter(s): none

	Example: none

	Change Log:
	1.0.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

#include "..\buildingPosManual.sqf"

currBuilding = nearestObjects [player, ["House","Ruins"], 50];
currBuilding = currBuilding select 0;

{ deleteVehicle _x; } forEach nearestObjects [player,["Sign_Arrow_Green_F"],2000];
{ deleteVehicle _x; } forEach nearestObjects [player,["Sign_Arrow_Yellow_F"],2000];
{ deleteVehicle _x; } forEach nearestObjects [player,["Sign_Arrow_F"],2000];
{ deleteVehicle _x; } forEach nearestObjects [player,["Sign_Arrow_Cyan_F"],2000];
{ deleteVehicle _x; } forEach nearestObjects [player,["Sign_Arrow_Blue_F"],2000];

if (!isNil "currBuildingMkrID") then
{
	deleteMarker currBuildingMkrID;
};

if (!isNil "currBuildingLblID") then
{
	deleteMarker currBuildingLblID;
};

removeAllMissionEventHandlers "draw3D";
[currBuilding] execVM "functions\drawBoundingBox.sqf";

bldPosArr = [];

_string = format ["_buildingPos_%1 = [];",(typeOf currBuilding)];
copyToClipboard _string;

if !(isNil format ["_buildingPos_%1",(typeOf currBuilding)]) then
{
	currBuildingColor = "colorGreen";
	_numPositions = 0;
	private "_buildingPosManual";
	call compile format ["_buildingPosManual = _buildingPos_%1",(typeOf currBuilding)];
	for [{_a = 0},{_a < (count _buildingPosManual)},{_a = _a + 1}] do
	{
		_bldPos = getPos currBuilding;
		_buildingPosCurrent = _buildingPosManual select _a;
		_buildingPos = currBuilding modelToWorld _buildingPosCurrent;
		_object = createVehicle ["Sign_Arrow_F",_buildingPos, [], 0, "CAN_COLLIDE"];
		_object disableCollisionWith player;
		_numPositions = _numPositions + 1;
	};
	_noMoreBuildingPositions = false;
	_i = 0;
	while {!_noMoreBuildingPositions} do
	{
		_currPosition = currBuilding buildingPos _i;
		if !(str _currPosition == "[0,0,0]") then
		{
			_object = createVehicle ["Sign_Arrow_Green_F",_currPosition, [], 0, "CAN_COLLIDE"];
			_object disableCollisionWith player;
			_i = _i + 1;
			_numPositions = _numPositions + 1;
		}
		else
		{
			_noMoreBuildingPositions = true;
		};
	};
	_allBuildings = nearestObjects [getPos currBuilding,[(typeOf currBuilding)], 2000];
	{
		_bbr = boundingBoxReal _x;
		_bbr = _bbr select 0;
		_mkrMapID = format ["%1_%2",_x,(getPos _x)];
		_mkrMap = createMarker [_mkrMapID,(getPos _x)];
		_mkrMap setMarkerColor currBuildingColor;
		_mkrMap setMarkerShape "RECTANGLE";
		_mkrMap setMarkerAlpha 1;
		_mkrMap setMarkerBrush "SOLIDFULL";
		_mkrMap setMarkerSize [(_bbr select 0),(_bbr select 1)];
		_mkrMap setMarkerDir (getDir _x);
	} forEach _allBuildings;
	hint parseText format ["<t color='#00ff00' align='center'>REGISTERED BUILDING CLASS<br/><br/></t>'%1'<br/><br/><t color='#00ff00' align='center'>BUILDING POS MANUAL ALREADY EXISTS</t><br/>CONTAINING<br/>%2 BUILDING POSITIONS<br/><t color='#ff0000' align='center'>WHICH ARE MARKED AS RED ARROWS</t>",(typeOf currBuilding),_numPositions];
}
else
{
	currBuildingColor = "colorRed";
	_numPositions = 0;
	_noMoreBuildingPositions = false;
	_i = 0;
	while {!_noMoreBuildingPositions} do
	{
		_currPosition = currBuilding buildingPos _i;
		if !(str _currPosition == "[0,0,0]") then
		{
			_object = createVehicle ["Sign_Arrow_Green_F",_currPosition, [], 0, "CAN_COLLIDE"];
			_object disableCollisionWith player;
			_i = _i + 1;
			_numPositions = _numPositions + 1;
		}
		else
		{
			_noMoreBuildingPositions = true;
		};
	};
	hint parseText format ["<t color='#00ff00' align='center'>REGISTERED BUILDING CLASS<br/><br/></t>'%1'<br/><br/><t color='#ff0000' align='center'>BUILDING POS MANUAL MISSING</t><br/>PLACED GREEN ARROW ON %2 EXISTING VANILLA BUILDING POSITIONS<br/><t color='#ffff00' align='center'>PRESS 'F' TO ADD POSITIONS</t>",(typeOf currBuilding),_numPositions];
};

// current marker (for inArea check)
// currBuildingColor = "colorYellow";
currBuildingBBR = boundingBoxReal currBuilding;
currBuildingBBR = currBuildingBBR select 0;

currBuildingMkrID = format ["currBuildingMkr_%1_%2",currBuilding,(getPos currBuilding)];
currBuildingMkr = createMarker [currBuildingMkrID,(getPos currBuilding)];
currBuildingMkr setMarkerColor currBuildingColor;
currBuildingMkr setMarkerShape "RECTANGLE";
currBuildingMkr setMarkerAlpha 1;
currBuildingMkr setMarkerBrush "SOLIDFULL";
currBuildingMkr setMarkerSize [(currBuildingBBR select 0),(currBuildingBBR select 1)];
currBuildingMkr setMarkerDir (getDir currBuilding);

currBuildingLblID = format ["currBuildingLbl_%1_%2",currBuilding,(getPos currBuilding)];
currBuildingLbl = createMarker [currBuildingLblID,(getPos currBuilding)];
currBuildingLbl setMarkerColor currBuildingColor;
currBuildingLbl setMarkerShape "ICON";
currBuildingLbl setMarkerAlpha 1;
currBuildingLbl setMarkerText (typeOf currBuilding);
currBuildingLbl setMarkerType "mil_dot";
