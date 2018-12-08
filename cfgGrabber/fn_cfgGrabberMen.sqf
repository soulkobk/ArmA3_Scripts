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
	
	Name: fn_cfgGrabberMen.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 00:00 PM 28/06/2017
	Modification Date: 00:00 PM 28/06/2017
	
	Description:
	Run this script to gather all men to clipboard. Use this list in your scripts
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

_str = "";
_str = "/*" + _br + _tab + "fn_cfgGrabberMen by soulkobk (soulkobk.blogspot.com)." + _br;
_str = _str + _tab + format ["array list: objectClass %1 objectDisplayName - objectLabel - objectDLC/objectExpansion","//"] + _br;
_str = _str + _tab + "regex: remove all double quotes, replace single quotes with double quotes" + _br;
_str = _str + "*/" + _br + _br;

_cfgSoldier = configFile >> "CfgVehicles";
for "_i" from 0 to (count _cfgSoldier)-1 do
{
	_curSoldier = _cfgSoldier select _i;
	
	if (isClass _curSoldier) then
	{
		_className = configName _curSoldier;
		_displayName = getText(_curSoldier >> "displayName"); if (_displayName == "") then { _displayName = "NODESCRIPTION"};
		_dlc = getText(_curSoldier >> "DLC"); if (_dlc == "") then { _dlc = "VANILLA"};
		_typeSoldier = ["Men", getText(_curSoldier >> "vehicleClass")] call BIS_fnc_inString;
		_scope = getNumber(_curSoldier >> "scope");
		if (_scope >= 2 && (_typeSoldier isEqualTo true)) then
		{
			_label = getText(_curSoldier >> "vehicleClass");
			_line = "'" + format ["%1",_className] + "'" + format [" // %1 - %2 - %3",_displayName,(toUpper _label),(toUpper _dlc)];
			_str = _str + _tab + (str _line) + _br;
		};
	};
};

copyToClipboard _str;
