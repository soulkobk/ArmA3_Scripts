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
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 6:00 PM 02/02/2018

	Description:
	
	press 'g' for get positions (will mark building with arrows for vanilla building positions).
	press 'f' to add a position (where the player is exactly standing, will mark with an arrow).
	press 'h' to hide the closest object the player is near.
	press 't' to destroy the closest object the player is near.
	
	the lootSpawner is included, check the \lootSpawner directory (read the headers of the files).

	Parameter(s): none

	Example: none

	Change Log:
	1.0.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

BPM_fnc_keyDown = {
	switch (_this) do {
                // key g
		case 34: {
			_script = [] execVM "functions\getPositions.sqf";
		};
                // key f
		case 33: {
			_script = [] execVM "functions\addPosition.sqf";
		};      // key h
		case 35: {
			_script = [] execVM "functions\hideObject.sqf";
		};
				//key t
		case 20: {
			_script = [] execVM "functions\destroyBuilding.sqf";
		};
	};
};

waitUntil {!isNull (findDisplay 46)};
(findDisplay 46) displayAddEventHandler ["KeyDown","_this select 1 call BPM_fnc_keyDown;false;"];

// remove all items
removeHeadgear player;
removeGoggles player;
removeVest player;
removeBackpack player;
removeAllWeapons player;
removeAllAssignedItems player;
// god mode
player enableFatigue false;
player setFatigue 0;
player allowDamage false;
player setDamage 0;
player enableStamina false;
// add items
player addWeapon "ItemGPS"; // GPS
player addWeapon "ItemCompass"; // COMPASS
player addWeapon "ItemMap"; // MAP
