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
	
	Name: purchaseFuelInit.sqf
	Version: 1.0.5
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:59 PM 11/10/2016
	Modification Date: 7:01 PM 19/10/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script MUST be paired up with
	'purchaseFuel.sqf'.
	
	This script will disable 'free' fuel at ALL fuel stations and attach an action to 'Purchase Fuel'
	at a cost set within the 'purchaseFuel.sqf' script, which is needed for this init script to
	function. Tested and functioning on all Air and Land Vehicles, including UAV's (you must be the
	driver/operator).

	Place this script in directory...
	\addons\purchaseFuel\purchaseFuelInit.sqf
	
	Edit the file...
	\server\init.sqf
	
	And at the bottom of the script, paste in...
	[] execVM "addons\purchaseFuel\purchaseFuelInit.sqf";

	Edit the file...
	\client\init.sqf
	
	And at the bottom of the script, paste in...
	[] execVM "addons\purchaseFuel\purchaseFuelInit.sqf";

	COPY/MOVE the 'purchaseFuel.paa' (icon) into the directory...
	\addons\purchaseFuel\purchaseFuel.paa
	
	*Please note that with the use of this script, that 'Jerry Cans' will still be able to filled
	for FREE.
	
	Parameter(s): none

	Example: none
	
	Change Log:
	1.0.0 -	original base script.
	1.0.1 -	updated purchase fuel action with custom icon. (made by soulkobk to match other
			A3Wasteland icons).
	1.0.2 - redid forEach loop due to addAction only working client side! purchaseFuelInit.sqf
			must be executed client AND server side. moved directories to \addons\purchaseFuel.
	1.0.3 -	purchaseFuel.sqf changes.
	1.0.4 -	updated setFuelCargo for hasInterFace check due to allowing free fuel still. SMH.
	1.0.5 -	purchaseFuel.sqf changes.
	
	----------------------------------------------------------------------------------------------
*/

_fuelFeedArray =
[
	"Land_fs_feed_F",
	"Land_FuelStation_Feed_F",
	"Land_FuelStation_01_pump_F",
	"Land_FuelStation_02_pump_F"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/
	
_mapSizeSquare = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
_mapSizeEllipse = sqrt ((_mapSizeSquare * _mapSizeSquare) + (_mapSizeSquare * _mapSizeSquare));

_fuelFeeds = nearestObjects [[(_mapSizeSquare / 2),(_mapSizeSquare / 2),0], _fuelFeedArray, _mapSizeEllipse];

{
	if (isServer || isDedicated) then
	{
		_x setFuelCargo 0;
	};
	if (hasInterFace) then
	{
		_x setFuelCargo 0;
		_x addAction ["<img image='addons\purchaseFuel\purchaseFuel.paa'/> Purchase Fuel", "addons\purchaseFuel\purchaseFuel.sqf", player, 1.5, true, true, "(driver (vehicle player))", "((UAVControl (getConnectedUAV player) select 1) == 'DRIVER') || (vehicle player) isKindOf 'Air' || (vehicle player) isKindOf 'LandVehicle' && !((vehicle player) isKindOf 'ParachuteBase');", 10, false];
	};
} forEach _fuelFeeds;

if (isServer || isDedicated) then
{
	diag_log format ["[PURCHASE FUEL] -> ENABLED FUEL PURCHASING AT %1 FUEL PUMPS, NO MORE FREE FUEL!", (count _fuelFeeds)];
};
