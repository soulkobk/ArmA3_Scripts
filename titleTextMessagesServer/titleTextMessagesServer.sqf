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
	
	Name: titleTextMessagesServer.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:59 PM 11/10/2016
	Modification Date: 4:57 PM 19/10/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script MUST be paired up with
	thetitleTextMessagesServerText.sqf
	
	This script will display title text messages on each client (players) screen whilst in-game, as
	per the text contained within thetitleTextMessagesServerText.sqf file.

	Place this file SERVER SIDE at \A3Wasteland_settings\titleTextMessagesServer.sqf
	
	Edit your SERVER SIDE FILE...
	\init.sqf 
	
	Paste in...
	execVM (externalConfigFolder + "\titleTextMessagesServer.sqf");
	
	Edit your MISSION FILE (mission.pbo)...
	\init.sqf
	
	Paste in...
	"TTM_TITLETEXT_PUBVAR" addPublicVariableEventHandler
	{
		private ["_ttMessage","_ttDuration"];
		_ttMessage = _this select 1 select 0;
		_ttDuration = _this select 1 select 1;
		_ttMessageTitleText = format ["%1",_ttMessage];
		titleText [_ttMessageTitleText,"PLAIN DOWN",_ttDuration];
	};
	
	Directly underneath the line...
	[] execVM "briefing.sqf";
	
	*Be sure to use the -filePatching switch when launching the ArmA 3 A3Wasteland server.

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

if !(isServer) exitWith {}; // DO NOT DELETE THIS LINE!

_loopSleep = 30*60; // 30 minutes aka 1800 seconds.
_externalDirectory = "\A3Wasteland_settings"; // server side (external) directory path.

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/
	
_ttMessages = [];

if (loadFile (_externalDirectory + "\titleTextMessagesServerText.sqf") != "") then
{
	_ttMessages = call compile preprocessFileLineNumbers (_externalDirectory + "\titleTextMessagesServerText.sqf");
	diag_log format ["[TITLE TEXT MESSAGES] -> LOADED FILE WITH %1 LINES OF TEXT",(count _ttMessages)];
};

if ((count _ttMessages) >= 1) then
{
	if (_loopSleep < 600) then
	{
		_loopSleep = 600;
	};
	while {true} do
	{
		uiSleep 60;
		{
			_currentMessage = _x select 0;
			_currentFade = _x select 1;
			_currentSleep = _x select 2;
			TTM_TITLETEXT_PUBVAR = [format ["%1",_currentMessage],_currentFade];
			publicVariable "TTM_TITLETEXT_PUBVAR";
			uiSleep _currentSleep;
		} forEach _ttMessages;
		uiSleep _loopSleep - 60;
	};
};
