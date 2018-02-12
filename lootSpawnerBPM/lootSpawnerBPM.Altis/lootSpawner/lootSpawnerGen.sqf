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

	Name: lootSpawnerGen.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 12:00 PM 03/02/2018

	Description:
	this was written by me (soulkobk) whilst i was learning how to code arma 3, so the code is unoptimized.
	
	Parameter(s): none

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
_pos = (_this select 0);
_pos0 = (_pos select 0);
_pos1 = (_pos select 1);
_pos2 = (_pos select 2);
_showLoot = (_this select 1);
///////////////////////////////////////////////////////////////////////////////////////////////////
private ["_lootType","_box","_holder","_height","_boxWeapon","_boxMagazines","_lootCount","_id"];
///////////////////////////////////////////////////////////////////////////////////////////////////
#include "lootSpawnerConfig.sqf";
///////////////////////////////////////////////////////////////////////////////////////////////////
_lootType = _ls_lootTypeArr select (floor random (count _ls_lootTypeArr));
///////////////////////////////////////////////////////////////////////////////////////////////////
_height = 0;
_holder = "";
_lootCount = 0;
_markerColor = "Default";
///////////////////////////////////////////////////////////////////////////////////////////////////
_boxPos = [];
_box = createVehicle ["Land_BarrelEmpty_F",[_pos0,_pos1,(_pos2 + 0.1)], [], 0, "CAN_COLLIDE"];
_box setVelocity [0,0,0.5];
uiSleep 0.1;
_boxPos = (getPosATL _box);
deleteVehicle _box;
///////////////////////////////////////////////////////////////////////////////////////////////////
_createWeaponHolder =
{
	_boxPos = _this select 0;
	_zOffset = _this select 1;
	_holder = createVehicle ["GroundWeaponHolder",_boxPos, [], 0, "CAN_COLLIDE"];
	_holder allowDamage false;
	_holder setVectorUP (surfaceNormal [(getPosATL _holder select 0),(getPosATL _holder select 1)]);
	_holder setPosATL [(getPosATL _holder select 0),(getPosATL _holder select 1),(getPosATL _holder select 2) + _zOffset];
	_height = (round(getPosATL _holder select 2));
};
///////////////////////////////////////////////////////////////////////////////////////////////////
switch (_lootType) do
{
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "weaponHG":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_weaponHGLoopNum},{_lootCount=_lootCount+1}] do
		{
			_magazineNumClips = _ls_magazineNumClips;
			_weaponHG = _ls_weaponHGLoot select (floor random (count _ls_weaponHGLoot));
			_magazine = getArray (configFile / "CfgWeapons" / _weaponHG / "magazines");
			_magazineClass = _magazine select (floor random (count _magazine));
			_holder addMagazineCargoGlobal [_magazineClass, _magazineNumClips];
			_holder addWeaponCargoGlobal [_weaponHG, 1];
		};
		_markerColor = "ColorYellow";

	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "weaponHV":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_weaponHVLoopNum},{_lootCount=_lootCount+1}] do
		{
			_magazineNumClips = _ls_magazineNumClips;
			_weaponHV = _ls_weaponHVLoot select (floor random (count _ls_weaponHVLoot));
			_magazine = getArray (configFile / "CfgWeapons" / _weaponHV / "magazines");
			_magazineClass = _magazine select (floor random (count _magazine));
			_holder addMagazineCargoGlobal [_magazineClass, _magazineNumClips];
			_holder addWeaponCargoGlobal [_weaponHV, 1];
		};
		_markerColor = "ColorRed";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "weaponAR":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_weaponARLoopNum},{_lootCount=_lootCount+1}] do
		{
			_magazineNumClips = _ls_magazineNumClips;
			_weaponAR = _ls_weaponARLoot select (floor random (count _ls_weaponARLoot));
			_magazine = getArray (configFile / "CfgWeapons" / _weaponAR / "magazines");
			_magazineClass = _magazine select (floor random (count _magazine));
			_holder addMagazineCargoGlobal [_magazineClass, _magazineNumClips];
			_holder addWeaponCargoGlobal [_weaponAR, 1];
		};
		_markerColor = "ColorOrange";
	};

	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "magazine":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_magazineLoopNum},{_lootCount=_lootCount+1}] do
		{
			_magazineNumClips = _ls_magazineNumClips;
			_weaponHG = _ls_weaponHGLoot select (floor random (count _ls_weaponHGLoot));
			_weaponHV = _ls_weaponHVLoot select (floor random (count _ls_weaponHVLoot));
			_weaponAR = _ls_weaponARLoot select (floor random (count _ls_weaponARLoot));
			_weaponALL = [_weaponHG,_weaponHV,_weaponAR];
			_weapon = _weaponALL select (floor random (count _weaponALL));
			_magazine = getArray (configFile / "CfgWeapons" / _weapon / "magazines");
			_magazineClass = _magazine select (floor random (count _magazine));
			_holder addMagazineCargoGlobal [_magazineClass, _magazineNumClips];
		};
		_markerColor = "ColorGrey";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "surplus":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_surplusLoopNum},{_lootCount=_lootCount+1}] do
		{
			_surplus = _ls_surplusLoot select (floor random (count _ls_surplusLoot));
			_holder addItemCargoGlobal [_surplus, 1];
		};
		_markerColor = "ColorBrown";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "headgear":
	{
		[_boxPos,-0.1] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_headgearLoopNum},{_lootCount=_lootCount+1}] do
		{
			_headgear = _ls_headgearLoot select (floor random (count _ls_headgearLoot));
			_holder addItemCargoGlobal [_headgear, 1];
		};
		_markerColor = "ColorBrown";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "uniform":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_uniformLoopNum},{_lootCount=_lootCount+1}] do
		{
			_uniform = _ls_uniformLoot select (floor random (count _ls_uniformLoot));
			_holder addItemCargoGlobal [_uniform, 1];
		};
		_markerColor = "ColorKhaki";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "vest":
	{
		[_boxPos,-0.15] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_vestLoopNum},{_lootCount=_lootCount+1}] do
		{
			_vest = _ls_vestLoot select (floor random (count _ls_vestLoot));
			_holder addItemCargoGlobal [_vest, 1];
		};
		_markerColor = "ColorWhite";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "backpack":
	{
		[_boxPos,-0.2] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_backpackLoopNum},{_lootCount=_lootCount+1}] do
		{
			_backpack = _ls_backpackLoot select (floor random (count _ls_backpackLoot));
			_holder addBackpackCargoGlobal [_backpack, 1];
		};
		
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "explosive":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_explosiveLoopNum},{_lootCount=_lootCount+1}] do
		{
			_explosive = _ls_explosiveLoot select (floor random (count _ls_explosiveLoot));
			_holder addMagazineCargoGlobal [_explosive, 1];
		};
		_markerColor = "ColorBlue";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
	case "medical":
	{
		[_boxPos,0] call _createWeaponHolder;
		for [{_lootCount=0},{_lootCount<_ls_medicalLoopNum},{_lootCount=_lootCount+1}] do
		{
			_medical = _ls_medicalLoot select (floor random (count _ls_medicalLoot));
			_holder addItemCargoGlobal [_medical, 1];
		};
		_markerColor = "ColorPink";
	};
	///////////////////////////////////////////////////////////////////////////////////////////////////
};
///////////////////////////////////////////////////////////////////////////////////////////////////
// SHOW LOOT MARKERS WITH TYPE
if (_showLoot) then
{
	_posLoot = (getPosATL _holder);
	_id = format ["%1-LOOT",_posLoot];
	_mkrLoot = createMarker [_id,_posLoot];
	_mkrLoot setMarkerShape "ICON";
	_mkrLoot setMarkerType "mil_dot";
	_txt = format ["%1x %2 @ %3m ATL",_lootCount,_lootType,_height];
	_mkrLoot setMarkerText _txt;
	_mkrLoot setMarkerColor _markerColor;
	_mkrLoot setMarkerAlpha 1;
	_mkrLoot setMarkerSize [0.5,0.5];
};
///////////////////////////////////////////////////////////////////////////////////////////////////
_boxPos set [2, (_boxPos select 2) - ((getPos _holder) select 2)];
_holder setPosATL _boxPos;
///////////////////////////////////////////////////////////////////////////////////////////////////
_holder enableSimulationGlobal false;
_holder enableDynamicSimulation true;
///////////////////////////////////////////////////////////////////////////////////////////////////
