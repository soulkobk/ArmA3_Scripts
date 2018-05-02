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

	Name: fullScreenNightVision.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:54 PM 2/05/2018
	Modification Date: 12:54 PM 2/05/2018

	Description:
	This script will allow night vision mode in FULL SCREEN, no black borders! No mod needed!
	How? Unequip the Night Vision Goggles altogether (hmd slot), and equip Combat Goggles (Green)
	(goggles slot) to replace the night vision optics (NVG head gear will function as normal if
	they are equipped to the hmd slot).
	
	* Unequipped NVGoggles and equipped Combat Goggles (Green) = FULL SCREEN NIGHT VISION.
	* Equipped NVGoggles and equipped Combat Goggles (Green) = black border night vision.
	* Unequipped Combat Goggles (Green) and equipped NVGoggles = black border night vision.
	
	Enjoy a simple mod-free version of full screen night vision without any use of custom ppEffects.
	
	Place the following code within your init.sqf file...
	[] execVM "<your path here>\fullScreenNightVision.sqf";

	Parameter(s): none

	Example: none

	Change Log:
	1.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if (!hasInterface) exitWith {}; // DO NOT DELETE THIS!

SL_var_fullScreenNightVision =
[
	"G_Combat_Goggles_tna_F"
];

/*	------------------------------------------------------------------------------------------
		DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

SL_fn_fullScreenNightVision = {
	params ["_displayCode","_keyCode","_isShift","_isCtrl","_isAlt"];
	_handled = false;
	if (_keyCode in actionKeys "NightVision") then
	{
		switch SL_var_fullScreenNightVisionMode do
		{
			case 0: {
				if (cameraView != "GUNNER") then
				{
					if (goggles player in SL_var_fullScreenNightVision) then
					{
						player action ["nvGoggles", player];
						SL_var_fullScreenNightVisionMode = currentVisionMode player;
						_handled = true;
					};
				};
			};
			case 1: {
				if (cameraView != "GUNNER") then
				{
					player action ["nvGogglesOff", player];
					SL_var_fullScreenNightVisionMode = currentVisionMode player;
					_handled = true;
				};
			};
		};
	};
	_handled
};

player addEventHandler ["GetOutMan", {
	params ["_player", "_role", "_vehicle", "_turret"];
	switch SL_var_fullScreenNightVisionMode do
	{
		case 1: {
			if (cameraView != "GUNNER") then
			{
				if (goggles _player in SL_var_fullScreenNightVision) then
				{
					_player action ["nvGoggles", _player];
					SL_var_fullScreenNightVisionMode = currentVisionMode _player;
				};
			};
		};
		case 0: {
			if (cameraView != "GUNNER") then
			{
				_player action ["nvGogglesOff", _player];
				SL_var_fullScreenNightVisionMode = currentVisionMode _player;
			};
		};
	};
}];

SL_var_fullScreenNightVisionMode = currentVisionMode player;

waitUntil {!(isNull (findDisplay 46))};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call SL_fn_fullScreenNightVision;"];
