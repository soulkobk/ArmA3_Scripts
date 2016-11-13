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
	
	Name: playerJump.sqf
	Version: 1.0.1
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 11/05/2016
	Modification Date: 7:52 PM 13/11/2016
	
	Description:
	This jump script is to replace any/all glitchy/buggy jump scripts. This script will NOT visually
	glitch your screen when jumping. This script can be used in a single and multi player environment.
	
	In order to use it, place the following line in your init.sqf...
	[] execVM "addons\playerJump\playerJump.sqf"; // (adjust mission directory pathing as needed).
	
	Players jump key will be a combination of SHIFT and 'STEP OVER' (default 'v' key), so a more
	plug-n-play solution is met (no custom key bindings).
	
	*Please note that the ONLY animation available for jump within ArmA 3 currently is when a player
	has a primary weapon in their hands. The jump animation does not show proper with no weapon in
	the hands of the player... ArmA 3 bug.
	
	Parameter(s): none

	Example: none
	
	Change Log:
	1.0.0 -	original base script.
	1.0.1 -	changed displaySetEventHandler to displayAddEventHandler. changed key bindings to use
			run/sprint (SHIFT) and 'GET OVER' (default 'v' key) for jumping. slight changes to
			SL_fn_jumpOver routine and displayAddEventHandler string. player can now also jump
			whilst crouch running.
	
	----------------------------------------------------------------------------------------------
*/

if (!hasInterface) exitWith {};

SL_jumpBaseHeight = 1.80;
SL_jumpMaxHeight = 3.50;
SL_jumpBaseSpeed = 0.40;
SL_jumpAnimation = "AovrPercMrunSrasWrflDf";

"SL_fn_jumpOverAnim" addPublicVariableEventHandler {
	(_this select 1) spawn SL_fn_doAnim;
};

SL_fn_doAnim =
{    
    params ["_unit","_velocity","_direction","_speed","_height","_anim"];
	_unit setVelocity [(_velocity select 0) + (sin _direction * _speed), (_velocity select 1) + (cos _direction * _speed), ((_velocity select 2) * _speed) + _height];
	_unit switchMove _anim;
};

SL_fn_jumpOver = {
	params ["_displayCode","_keyCode","_isShift","_isCtrl","_isAlt"];
	_handled = false;
	if ((_keyCode in actionKeys "GetOver" && _isShift) && (animationState player != SL_jumpAnimation)) then {
		private ["_height","_velocity","_direction","_speed"];
		if ((player == vehicle player) && (isTouchingGround player) && ((stance player == "STAND") || (stance player == "CROUCH"))) exitWith
		{
			_height = (SL_jumpBaseHeight - (load player)) max SL_jumpMaxHeight;
			_velocity = velocity player;
			_direction = direction player;
			_speed = SL_jumpBaseSpeed;
			player setVelocity [(_velocity select 0) + (sin _direction * _speed), (_velocity select 1) + (cos _direction * _speed), ((_velocity select 2) * _speed) + _height];
			SL_fn_jumpOverAnim = [player,_velocity,_direction,_speed,_height,SL_jumpAnimation];
			publicVariable "SL_fn_jumpOverAnim";
			if (currentWeapon player == "") then // half working buggy 'fix' for having no weapon in hands (no animation available for it... BIS!!)
			{
				player switchMove SL_jumpAnimation;
				player playMoveNow SL_jumpAnimation;
			}
			else
			{
				player switchMove SL_jumpAnimation;
			};
			_handled = true;
		};
	};
	_handled
};

waituntil {!(isNull (findDisplay 46))};
(findDisplay 46) displayAddEventHandler ["KeyDown", "_this call SL_fn_jumpOver;"];
