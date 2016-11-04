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
	
	Name: afkTimer.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:05 PM 04/11/2016
	Modification Date: 7:05 PM 04/11/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script is a player AFK timer.
	
	The script checks for player velocity and the direction the player is looking, if both are
	idle for greater than a second it will trigger the AFK timer. If the player moves or looks
	around with the camera, the AFK timer resets. If the player is idle for too long (default 10
	minutes), it will result in a notice on screen and the player kicked back to the lobby.
	
	*Use this script in conjuction with BEC to also kick idle players from the lobby.
	
	Place this file at...
	\client\functions\afkTimer.sqf
	
	Edit file...
	\client\init.sqf
	
	And paste in at the end of the file...
	[] execVM "client\functions\afkTimer.sqf";
	
	Parameter(s):

	Example:
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

_afkTimeMax = 10*60; // maximum 10 minutes AFK time (default).

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

waitUntil {alive player};

afkTimerCheck = true;

_timerAFK = nil;
_playerVelocity = vectorMagnitude velocity player * 3.6;
_playerlastViewDirection = round((((screenToWorld [0.5,0.5] select 0) - (position player select 0)) atan2 ((screenToWorld [0.5,0.5] select 1) - (position player select 1))) + 360) % 360;

while {afkTimerCheck} do
{
	_playerCurrViewDirection = round((((screenToWorld [0.5,0.5] select 0) - (position player select 0)) atan2 ((screenToWorld [0.5,0.5] select 1) - (position player select 1))) + 360) % 360;
	uiSleep 0.5;
	if (_playerVelocity isEqualTo 0) then
	{
		if (_playerCurrViewDirection isEqualTo _playerLastViewDirection) then
		{
			if (isNil "_timerAFK") then
			{
				_timerAFK = (diag_tickTime + _afkTimeMax);
			};
		}
		else
		{
			_timerAFK = nil;
		};
	}
	else
	{
		_timerAFK = nil;
	};
	_playerVelocity = vectorMagnitude velocity player * 3.6;
	_playerLastViewDirection = round((((screenToWorld [0.5,0.5] select 0) - (position player select 0)) atan2 ((screenToWorld [0.5,0.5] select 1) - (position player select 1))) + 360) % 360;
	if (!isNil "_timerAFK") then
	{
		if (diag_tickTime >= _timerAFK) then
		{
			afkTimerCheck = false;
			9999 cutText ["", "BLACK", 0.01];
			0 fadeSound 0;
			uiNamespace setVariable ["BIS_fnc_guiMessage_status", false];
			_afkMessage = ["You Were Kicked For Being AFK For Too Long!","AFK KICK",true,false] spawn BIS_fnc_guiMessage;
			_afkMessageWait = diag_tickTime + 30;
			waitUntil {scriptDone _afkMessage || diag_tickTime >= _afkMessageWait};
			endMission "LOSER";
			waitUntil {uiNamespace setVariable ["BIS_fnc_guiMessage_status", false]; closeDialog 0; false};
		};
	};
	uiSleep 0.5;
};
