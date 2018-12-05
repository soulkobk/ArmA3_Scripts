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

	Name: init.sqf
	Version: 1.0.A3WL0
	Author: soulkobk (soulkobk.blogspot.com) - base script template by MercyfulFate.
	Creation Date: 9:11 PM 29/05/2018
	Modification Date: 9:11 PM 29/05/2018

	Description:
	For use with A3Wasteland 1.4x mission (A3Wasteland.com).
	
	Place this file at \client\items\laptopkl\init.sqf
	Place atm_hack.sqf file at \client\items\laptopkl\atm_hack.sqf
	
	Edit file storeConfig.sqf and paste in...
	["Laptop (Kali Linux)", "laptopkl", localize "STR_WL_ShopDescriptions_Laptopkl", "client\icons\laptop.paa", 250000, 125000, "HIDDEN"],
	...within the 'customPlayerItems = [<items>]' array (~line 1265).
	
	Edit file stringtable.xml and paste in...
	<Key ID="STR_WL_ShopDescriptions_Laptopkl">
		<English>A laptop with kali linux operating system used for hacking ATM's.</English>
	</Key>
	...within the '<Package name="ShopDescriptions">' section.
	
	Copy/paste in laptop.paa at path \client\icons\laptop.paa
	
	Edit file \client\items\init.sqf and paste in...
	[_this, "laptopkl"] call mf_init;
	...underneath '[_this, "cratemoney"] call mf_init;'
	
	Parameter(s):

	Example:

	Change Log:
	1.0.A3WL0 - new init for laptopkl for a A3Wasteland hack ATM mission.

	----------------------------------------------------------------------------------------------
*/

MF_ITEMS_LAPTOPKL = "laptopkl";

private ["_path","_icon"];
_path = _this;
_icon = "client\icons\laptop.paa";

mf_laptopkl_nearest_atm = {
	_objectArray = ["Land_ATM_01_F","Land_ATM_02_F","Land_ATM_01_malden_F","Land_ATM_02_malden_F"];
	_objects = nearestObjects [player,_objectArray,3];
	_object = objNull;
	if (count _objects > 0) then
	{
		_object = _objects select 0;
	};
	_object;
} call mf_compile;

mf_laptopkl_atm_hack = [_path, "atm_hack.sqf"] call mf_compile;
[MF_ITEMS_LAPTOPKL,"Laptop (Kali Linux)",mf_laptopkl_atm_hack,"Land_Laptop_F",_icon,1] call mf_inventory_create;

private ["_condition","_action"];
_condition = "(!isNull ([] call mf_laptopkl_nearest_atm)) && (MF_ITEMS_LAPTOPKL call mf_inventory_count > 0)";
_action = [format ["<img image='%1'/> Hack ATM",_icon],mf_laptopkl_atm_hack,nil,2,true,false,"",_condition];
["laptopkl-hacking",_action] call mf_player_actions_set;
