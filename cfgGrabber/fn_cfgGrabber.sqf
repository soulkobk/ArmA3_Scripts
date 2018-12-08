/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2017 soulkobk (soulkobk.blogspot.com)

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
	
	Name: fn_cfgGrabber.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 00:00 PM 28/06/2017
	Modification Date: 00:00 PM 28/06/2017
	
	Description:
	Run this script to gather all weapons, items, etc to clipboard. Use this list in your scripts
	for items arrays.

	Parameter(s):

	Example:
	
	Change Log:
	1.0.0 -	original base script.

	----------------------------------------------------------------------------------------------
*/
///////////////////////////////////////////////////////////////////////////////////////////////////
_br = toString [13, 10];
_tab = toString [9];
///////////////////////////////////////////////////////////////////////////////////////////////////	
_str = "";
_str = "/*" + _br + _tab + "fn_cfgGrabber by soulkobk (soulkobk.blogspot.com)." + _br;
_str = _str + _tab + format ["array list: objectClass %1 objectDisplayName - objectLabel - objectDLC/objectExpansion","//"] + _br;
_str = _str + _tab + "regex: remove all double quotes, replace single quotes with double quotes" + _br;
_str = _str + "*/" + _br + _br;
///////////////////////////////////////////////////////////////////////////////////////////////////	
_cfgWeapons = configFile >> "CfgWeapons";
_weapons = [];
_label = "";
for "_i" from 0 to (count _cfgWeapons)-1 do
{
	_curWeapon = _cfgWeapons select _i;
	
	if (isClass _curWeapon) then
	{
		_className = configName _curWeapon;
		_displayName = getText(_curWeapon >> "displayName"); if (_displayName == "") then { _displayName = "NODESCRIPTION"};
		_dlc = getText(_curWeapon >> "DLC"); if (_dlc == "") then { _dlc = "VANILLA"};
		_weaponType = getNumber(_curWeapon >> "type");
		_scope = getNumber(_curWeapon >> "scope");
		_picture = getText(_curWeapon >> "picture"); if (_picture == "") exitWith { _picture = "NONE"};

		if (_scope >= 2 && _weaponType in [1,2,4] && _picture != "" && !(_className in _weapons) && _className != "NVGoggles") then
		{
			switch (_weaponType) do
			{
				case 1: { _label = "PRIMARYWEAPON"};
				case 2: { _label = "SECONDARYWEAPON"};
				case 4: { _label = "LAUNCHERWEAPON"};
				case 4096: { _label = "BINOCULAR"};
			};
			
			_line = "'" + format ["%1",_className] + "'" + format [" // %1 - %2 - %3",_displayName,_label,(toUpper _dlc)];
			_str = _str + _tab + (str _line) + _br;
			_weapons set[count _weapons, _className];
		};
	};
};
///////////////////////////////////////////////////////////////////////////////////////////////////	
_cfgWeapons = configFile >> "CfgMagazines";
_magazines = [];
for "_i" from 0 to (count _cfgWeapons)-1 do
{
	_curWeapon = _cfgWeapons select _i;
	
	if (isClass _curWeapon) then
	{
		_className = configName _curWeapon;
		_displayName = getText(_curWeapon >> "displayName"); if (_displayName == "") then { _displayName = "NODESCRIPTION"};
		_dlc = getText(_curWeapon >> "DLC"); if (_dlc == "") then { _dlc = "VANILLA"};
		_weaponType = getNumber(_curWeapon >> "type");
		_scope = getNumber(_curWeapon >> "scope");
		_picture = getText(_curWeapon >> "picture"); if (_picture == "") exitWith { _picture = "NONE"};
		if (_scope >= 2 && _picture != "" && !(_className in _magazines)) then
		{
			_label = "MAGAZINE";
			_line = "'" + format ["%1",_className] + "'" + format [" // %1 - %2 - %3",_displayName,_label,(toUpper _dlc)];
			_str = _str + _tab + (str _line) + _br;
			_magazines set[count _magazines, _className];
		};
	};
};
///////////////////////////////////////////////////////////////////////////////////////////////////	
_cfgWeapons = configFile >> "CfgWeapons";
_items = [];
for "_i" from 0 to (count _cfgWeapons)-1 do
{
	_curWeapon = _cfgWeapons select _i;
	
	if (isClass _curWeapon) then
	{
		_className = configName _curWeapon;
		_displayName = getText(_curWeapon >> "displayName"); if (_displayName == "") then { _displayName = "NODESCRIPTION"};
		_dlc = getText(_curWeapon >> "DLC"); if (_dlc == "") then { _dlc = "VANILLA"};
		_weaponType = getNumber(_curWeapon >> "type");
		_scope = getNumber(_curWeapon >> "scope");
		_picture = getText(_curWeapon >> "picture"); if (_picture == "") exitWith { _picture = "NONE"};
		if (_scope >= 2 && _weaponType in [131072,4096] && _picture != "" && !(_className in _items) && _className != "Binocular") then
		{
			switch (_weaponType) do
			{
				case 4096: { _label = "BINOCULAR"};
				case 131072: { _label = "ITEM"};
			};
			
			if (_label == "ITEM") then
			{
				if ("V" in (_className splitString "_")) then { _label = "VEST"};
				if ("U" in (_className splitString "_")) then { _label = "UNIFORM"};
				if ("H" in (_className splitString "_")) then { _label = "HEADGEAR"};
				if ("muzzle" in (_className splitString "_")) then { _label = "MUZZLE"};
				if ("bipod" in (_className splitString "_")) then { _label = "BIPOD"};
				if ("optic" in (_className splitString "_")) then { _label = "OPTIC"};
				if ("acc" in (_className splitString "_")) then { _label = "WEAPONLIGHT"};
			};
			_line = "'" + format ["%1",_className] + "'" + format [" // %1 - %2 - %3",_displayName,_label,(toUpper _dlc)];
			_str = _str + _tab + (str _line) + _br;
			_items set[count _items, _className];
		};
	};
};
///////////////////////////////////////////////////////////////////////////////////////////////////	
_cfgWeapons = configFile >> "CfgVehicles";
_backpacks = [];
for "_i" from 0 to (count _cfgWeapons)-1 do
{
	_curWeapon = _cfgWeapons select _i;
	
	if (isClass _curWeapon) then
	{
		_className = configName _curWeapon;
		_displayName = getText(_curWeapon >> "displayName"); if (_displayName == "") then { _displayName = "NODESCRIPTION"};
		_dlc = getText(_curWeapon >> "DLC"); if (_dlc == "") then { _dlc = "VANILLA"};
		_weaponType = getText(_curWeapon >> "vehicleClass");
		_scope = getNumber(_curWeapon >> "scope");
		_picture = getText(_curWeapon >> "picture"); if (_picture == "") exitWith { _picture = "NONE"};
		if (_scope >= 2 && _weaponType == "Backpacks" && _picture != "" && !(_className in _backpacks)) then
		{
			_label = "BACKPACK";
			_line = "'" + format ["%1",_className] + "'" + format [" // %1 - %2 - %3",_displayName,_label,(toUpper _dlc)];
			_str = _str + _tab + (str _line) + _br;
			_backpacks set[count _backpacks, _className];
		};
	};
};
///////////////////////////////////////////////////////////////////////////////////////////////////	
copyToClipboard _str;
