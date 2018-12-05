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

	Name: atm_hack.sqf
	Version: 1.0.A3WL0
	Author: soulkobk (soulkobk.blogspot.com) - base script template by MercyfulFate.
	Creation Date: 9:11 PM 29/05/2018
	Modification Date: 9:11 PM 29/05/2018

	Description:
	For use with A3Wasteland 1.4x mission (A3Wasteland.com).

	Parameter(s):

	Example:

	Change Log:
	1.0.A3WL0 - new atm hack routine for laptopkl for a A3Wasteland hack ATM mission.

	----------------------------------------------------------------------------------------------
*/

#define HACK_DURATION 120
#define HACK_ANIMATION "Acts_Briefing_SA_Loop"
#define HACK_STARTMONEY 125000

#define ERR_IN_VEHICLE "HACKING ATM CANCELLED! You can't do that whilst in a vehicle."
#define ERR_DESTROYED "HACKING ATM CANCELLED! The ATM has been destroyed."
#define ERR_TOO_FAR_AWAY "HACKING ATM CANCELLED! You moved too far away from the ATM."
#define ERR_CANCELLED "HACKING ATM CANCELLED! What'd you do that for? Get hacking!"
#define ERR_INTERRUPTED "HACKING ATM CANCELLED! The hacking connection was interrupted, try again!"
#define ERR_NO_ATM "HACKING ATM CANCELLED! You are not close enough to an ATM."
#define ERR_NO_LAPTOP "HACKING ATM CANCELLED! You don't have a laptop!"
#define ITEM_COUNT(ITEMID) ITEMID call mf_inventory_count

private ["_checks","_accounts","_success","_hackedTotalMoney","_hackedTotalNumber","_atm","_error"];

_atm = call mf_laptopkl_nearest_atm;

_error = "";
switch (true) do
{
	case (isNull _atm): {_error = ERR_NO_ATM};
	case (vehicle player != player):{_error = ERR_IN_VEHICLE};
	case (player distance _atm > (sizeOf typeOf _atm / 3) max 2): {_error = ERR_NO_ATM};
	case (ITEM_COUNT(MF_ITEMS_LAPTOPKL) <= 0): {_error = ERR_NO_LAPTOP};
};

if (_error != "") exitWith
{
	[format ["%1",_error], 5] call mf_notify_client;
	_success = false;
	_success
};

_progressPercentStr = "000";
_checks =
{
	private ["_progress","_failed","_text"];
	_progress = _this select 0;
	_atm = call mf_laptopkl_nearest_atm;
	_text = "";
	_failed = true;
	_progressPercent = (round(100 * _progress));
	if (_progressPercent < 9) then
	{
		_progressPercentStr = format ["00%1",_progressPercent];
	}
	else
	{
		if (_progressPercent < 100) then
		{
			_progressPercentStr = format ["0%1",_progressPercent];
		}
		else
		{
			_progressPercentStr = format ["%1",_progressPercent];
		};
	};
	switch (true) do
	{
		case (!alive player): {}; // player is dead, no need for a notification.
		case (vehicle player != player): {_text = ERR_IN_VEHICLE}; // player is in a vehicle.
		case (_atm isEqualTo objNull): {_text = ERR_TOO_FAR_AWAY}; // nearest ATM is not found.
		case (player distance _atm > (sizeOf typeOf _atm / 3) max 2): {_text = ERR_TOO_FAR_AWAY}; // ATM is too far away.
		case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false}; // player pressed cancel button.
		default {
			switch (selectRandomWeighted [0,0.9,1,0.1,2,0.25,3,0.25]) do
			{
				case 0: {_text = format["Hacking ATM %1%2 Complete",_progressPercentStr,"%"]};
				case 1: {_text = ""};
				case 2: {_text = format["Hakcnig aTm 010%2 Cometepl",_progressPercentStr,"%"]};
				case 3: {_text = format["Hkacgin AMt 099%2 Cleometp",_progressPercentStr,"%"]};
			};
			_failed = false;
		};
	};
	if (round(random 1000) < 1) then // simulated connection interruption.
	{
		_text = ERR_INTERRUPTED;
		_failed = true;
	};
	[_failed, _text];
};

_accounts =
{
	_hackedTotalMoney = HACK_STARTMONEY;
	_hackedTotalNumber = 0;
	{
		_hacked = _x;
		_hackingUID = getPlayerUID _hacked;
		_hackingAccountsCheck = [];
		if (isPlayer _hacked) then
		{
			_hackingBMoney = _hacked getVariable ["bmoney",0];
			if (_hackingBMoney > 0) then
			{
				_hackingPercentage = 0.05; // default of 0.05% (being an INDY/GUER is harder to obtain money via capture zones).
				switch (true) do
				{
					case (side _hacked isEqualTo BLUFOR): {_hackingPercentage = 0.1}; // 1% (increase percentage based upon faction). less armour on uniforms.
					case (side _hacked isEqualTo OPFOR): {_hackingPercentage = 0.15}; // 1.5% (increase percentage based upon faction). more armour on uniforms.
				};
				_hackingAmount = round(_hackingPercentage * _hackingBMoney);
				_hackingBalanceUpdate = (_hackingBMoney - _hackingAmount);
				_hacked setVariable ["bmoney",_hackingBalanceUpdate,true];
				if (["A3W_playerSaving"] call isConfigOn) then
				{
					[_hackingUID, [["BankMoney",_hackingBalanceUpdate]],[]] call fn_saveAccount; // force saves the player account.
				};
				_hackedTotalMoney = _hackedTotalMoney + _hackingAmount;
				_hackedTotalNumber = _hackedTotalNumber + 1;
			};
		};
	} forEach (playableUnits - [player]);
};

_success = [HACK_DURATION,HACK_ANIMATION,_checks,[_atm]] call a3w_actions_start;

if (_success) then
{
	_hackedAccounts = call _accounts;
	player setVariable ["cmoney",(player getVariable ["cmoney", 0]) + _hackedTotalMoney,true];
	[format ["You Have Successfully Hacked The ATM And Stole $%1 From %2 Players Bank Accounts!",[_hackedTotalMoney] call fn_numbersText,_hackedTotalNumber],5] call mf_notify_client;
	[MF_ITEMS_LAPTOPKL,1] call mf_inventory_remove;
};

_success;
