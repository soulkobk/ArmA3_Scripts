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
	
	Name: purchaseFuel.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:59 PM 11/10/2016
	Modification Date: 4:59 PM 11/10/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script MUST be paired up with
	'purchaseFuelInit.sqf'.
	
	This script is the action/functioning to refuel vehicles (air and land) at a cost per vehicle.
	
	Edit the cost price per tank of fuel with the variable _fuelPricePerTank below. For example
	if the price is set at 2500, then $2500 is the cost of a FULL tank of fuel. The script also
	deducts	cost if you are in the middle of a refuelling, but abort. You can't glitch fill your
	vehicle	for free!
	
	Place this script in directory...
	\server\functions\purchaseFuel.sqf
	
	*Please note that with the use of this script, that 'Jerry Cans' will still be able to filled
	for FREE.
	
	Parameter(s): none

	Example: none
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

_fuelPricePerTank = 2500; // this is wasteland after all... fuel is scarce, and pricey ;P

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/
	
if (mutexScriptInProgress) exitWith
{
	["You are already performing another action.", 5] call mf_notify_client;
};

mutexScriptInProgress = true;
	
_source = _this select 0;
_unit = _this select 1;
_vehicle = vehicle _unit;
_player = _this select 3;

_vehicleFuel = fuel _vehicle / 2;

_fuelPrice = ceil (_fuelPricePerTank * (1 - (_vehicleFuel * 2)));
	
_vehicleName = getText (configFile >> "CfgVehicles" >> (typeOf _vehicle) >> "displayName");

if (driver _vehicle != _unit) exitWith
{
	_text = format ["You must be the driver to refuel the vehicle %1.\nREFUELLING ABORTED!",_vehicleName];
	[_text, 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

if ((_vehicleFuel * 2) >= 0.95) exitWith
{
	_text = format ["Your vehicle %1 is already full of fuel.\nREFUELLING ABORTED!",_vehicleName];
	[_text, 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

_unitCMoney = _player getVariable "cmoney";

if (_unitCMoney < _fuelPrice) exitWith
{
	_text = format ["You need $%1 of carried money to refuel the vehicle %2, you have $%3 on you.\nREFUELLING ABORTED!",_fuelPrice,_vehicleName,_unitCMoney];
	[_text, 5] call mf_notify_client;
	mutexScriptInProgress = false;
};

_text = format ["You have 5 seconds to stop the engine in order to refuel the vehicle for $%1.\nYou can abort the fuelling process by removing yourself from driver position or by starting the engine.", _fuelPrice];
[_text, 5] call mf_notify_client;

uiSleep 5;

refuellingVehicle = true;

[_vehicle,_unit] spawn {
	params ["_vehicle","_unit"];
	while {refuellingVehicle} do
	{
		if (!(driver _vehicle == _unit) || (isEngineOn _vehicle)) then
		{
			refuellingVehicle = false;
			mutexScriptInProgress = false;
		};
		uiSleep 0.1;
	};
};

uiSleep 0.5;

if !(refuellingVehicle) exitWith
{
	_text = format ["Refulling of vehicle %1 interrupted.\nREFUELLING ABORTED!",_vehicleName];
	[_text, 5] call mf_notify_client;
};

_text = format ["Refuelling vehicle %1, please wait.",_vehicleName];
[_text, 5] call mf_notify_client;

uiSleep 0.5;

for "_i" from _vehicleFuel to 1 step 0.01 do
{
	_fuelLevel = _vehicleFuel + _i;
	_vehicle setFuel _fuelLevel;
	uiSleep 0.5;
	if !(refuellingVehicle) exitWith {};
};

if (refuellingVehicle) then
{
	_vehicle setFuel 1;
	_text = format ["Refulling of vehicle %1 complete, which cost $%2.\nREFUELLING COMPLETE!",_vehicleName,_fuelPrice];
	[_text, 5] call mf_notify_client;
	_player setVariable ["cmoney",(_unitCMoney - _fuelPrice)];
}
else
{
	_beforeVehicleFuel = _vehicleFuel;
	_afterVehicleFuel = fuel _vehicle / 2;
	_differenceVehicleFuel = _afterVehicleFuel - _beforeVehicleFuel;
	_partialFuelPrice = ceil (_fuelPricePerTank * (_differenceVehicleFuel * 2));
	if (_partialFuelPrice <= 0) then
	{
		_text = format ["Refulling of vehicle %1 interrupted.\nREFUELLING ABORTED!",_vehicleName];
		[_text, 5] call mf_notify_client;
	}
	else
	{
		_text = format ["Refulling of vehicle %1 interrupted, which cost $%2.\nREFUELLING ABORTED!",_vehicleName,_partialFuelPrice];
		[_text, 5] call mf_notify_client;
		_player setVariable ["cmoney",(_unitCMoney - _partialFuelPrice)];
	};
};

mutexScriptInProgress = false;
refuellingVehicle = false;
