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
	
	Name: serverRestartMessages.sqf
	Version: 1.2
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/01/2016
	Modification Date: 5:09 PM 18/06/2016
	
	Description:
	This script must be used with real_date 3.0 (http://killzonekid.com/pub/real_date_v3.0.zip)
	extention to get the server time on script execution, and must also be executed server side only!
	(place the real_date.dll in the same directory where your arma3server.exe is).

	This script needs to be placed in the SERVER SIDE folder...
	'A3Wasteland_Settings\scripts\serverRestartMessages\serverRestartMessages.sqf'
	
	The following line needs to be placed in the SERVER SIDE init.sqf (found in A3Wasteland_Settings folder).
	execVM (externalConfigFolder + "\scripts\serverRestartMessages\serverRestartMessages.sqf");
	
	The following line needs to be placed in the MISSION init.sqf file (then re-pack the mission.pbo).
	"RM_DISPLAYTEXT_PUBVAR" addPublicVariableEventHandler {(_this select 1) spawn BIS_fnc_dynamicText;};

	The script is informative only and will display messages on all clients when the server is due
	to restart. Please note, this script does NOT restart the server, you will need to sync this
	script up with your own	restart times (bec client/batch file/hosted restart/script restart).
	
	Parameter(s): none

	Example: none
	
	Change Log:
	1.0	-	original base script.
	1.1	-	fixed client messages to reflect if server is locked at 5 minutes until restart or not.
	1.2	-	created new call routines for time checking and formatting output. fixed error when using
			time string 00:00:00 in _hardResetTimes, it now accepts 00:00:00 or 24:00:00 for midnight.
			script now also allows 24 hour roll-over. tidied up some code structure.
	
	----------------------------------------------------------------------------------------------
*/

_hardResetTimes = ["06:00:00","12:00:00","18:00:00","00:00:00"]; // HARD RESET TIMES IN HH:MM:SS
_lastMinuteCountDown = true; // COUNTS DOWN ON SCREEN FROM 60 SECONDS TO 0 SECONDS
_lockServerAt5Minutes = true; // LOCK THE SERVER 5 MINUTES BEFORE RESTART?

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

#define SECSPERHOUR 3600
#define SECSPERMIN 60

_doubleDigits = {
    if (_this < 10) exitWith {"0"+str _this};
    str _this
};

_isTime = false;
_checkTimeRange = {
	_nowTime = _realSecondsTime; _startTime = _hardSecondsTime - (_this * 60); _endTime = _hardSecondsTime - ((_this * 60) - 60);

	if (_startTime <= 0) then {_startTime = (86400 + _startTime);};
	if (_endTime <= 0) then {_endTime = (86400 + _endTime);};
	if ((_endTime - _startTime) < 0) then
	{
		_startTime = ((_endTime - _startTime) + (86400 - 60));
	};
	if ((_nowTime >= _startTime) && (_nowTime <= _endTime)) then {_isTime = true;} else {_isTime = false;};
	_isTime
};

_outputServerTime = "";
_checkServerTime = {
	_currServerTime = call compile ("real_date" callExtension "+"); _currServerTimeHour = _currServerTime select 3; _currServerTimeMin = _currServerTime select 4; _currServerTimeSec = _currServerTime select 5;
	if (_this == "HHMMSS") then {
		_outputServerTime = format ["%1:%2:%3", _currServerTimeHour call _doubleDigits, _currServerTimeMin call _doubleDigits, _currServerTimeSec call _doubleDigits];
	}
	else
	{
		_outputServerTime = [_currServerTimeHour, _currServerTimeMin, _currServerTimeSec];
	};
	_outputServerTime
};

diag_log format ["[SERVER RESTART] -> RESTART TIMES ARE %1 - CURRENT SERVER TIME IS %2", _hardResetTimes, 'HHMMSS' call _checkServerTime];

_realServerTime = "" call _checkServerTime; _realSecondsTime = (((_realServerTime select 0) * SECSPERHOUR) + ((_realServerTime select 1) * SECSPERMIN) + (_realServerTime select 2));
_30minCheck = false; _20minCheck = false; _10minCheck = false; _5minCheck = false; _2minCheck = false; _1minCheck = false;

checkServerTime = true;
while {checkServerTime} do
{
	_ticksLoop = round(diag_TickTime);
	{
		_hardServerTime = _x splitString ":";
		_hardServerTimeHour = parseNumber (_hardServerTime select 0);
		_hardServerTimeMin = parseNumber (_hardServerTime select 1);
		_hardServerTimeSec = parseNumber (_hardServerTime select 2);
		_hardSecondsTime = (_hardServerTimeHour * SECSPERHOUR);
		_hardSecondsTime = (_hardSecondsTime + (_hardServerTimeMin * SECSPERMIN));
		_hardSecondsTime = (_hardSecondsTime + _hardServerTimeSec);
		switch true do
		{
			case ((30 call _checkTimeRange) && !_30minCheck) :
			{
				_30minCheck = true;
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 30 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 30 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
			};
			case ((20 call _checkTimeRange) && !_20minCheck) :
			{
				_30minCheck = true; _20minCheck = true;
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 20 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 20 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
			};
			case ((10 call _checkTimeRange) && !_10minCheck) :
			{
				_30minCheck = true; _20minCheck = true; _10minCheck = true;
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 10 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 10 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
			};
			case ((5 call _checkTimeRange) && !_5minCheck) :
			{
				_30minCheck = true; _20minCheck = true; _10minCheck = true; _5minCheck = true;
				if (_lockServerAt5Minutes) then
				{
					_lockServer = "[]" serverCommand "#lock";
					RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF5500' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 5 MINUTES<br/><t color='#FF5500' size='0.65'>THE SERVER IS NOW LOCKED UNTIL RESTART",0,0.7,10,0];
					publicVariable "RM_DISPLAYTEXT_PUBVAR";
					diag_log format ["[SERVER RESTART] -> 5 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1 - SERVER LOCKED!", 'HHMMSS' call _checkServerTime];
				}
				else
				{
					RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF5500' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 5 MINUTES",0,0.7,10,0];
					publicVariable "RM_DISPLAYTEXT_PUBVAR";
					diag_log format ["[SERVER RESTART] -> 5 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
				};
			};
			case ((2 call _checkTimeRange) && !_2minCheck) :
			{
				_30minCheck = true; _20minCheck = true; _10minCheck = true; _5minCheck = true; _2minCheck = true;
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF5500' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 2 MINUTES<br/><t color='#FF5500'>LOG OUT NOW!</t>",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 2 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
			};
			case ((1 call _checkTimeRange) && !_1minCheck) :
			{
				_30minCheck = true; _20minCheck = true; _10minCheck = true; _5minCheck = true; _2minCheck = true; _1minCheck = true;
				if (_lastMinuteCountDown) then 
				{
					diag_log format ["[SERVER RESTART] -> 60 SECONDS UNTIL SERVER RESTART (COUNTING DOWN) - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
					for [{_s = (_hardSecondsTime - _realSecondsTime)},{_s > 0},{_s = _s - 1}] do
					{
						if (_s > 1) then
						{
							RM_DISPLAYTEXT_PUBVAR = [format["<t color='#FF0000' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN %1 SECONDS<br/><t color='#FF0000'>LOG OUT NOW!</t>",_s],0,0.7,1,0];
							publicVariable "RM_DISPLAYTEXT_PUBVAR";
						}
						else
						{
							RM_DISPLAYTEXT_PUBVAR = [format["<t color='#FF0000' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN %1 SECOND<br/><t color='#FF0000'>LOG OUT NOW!</t>",_s],0,0.7,1,0];
							publicVariable "RM_DISPLAYTEXT_PUBVAR";
						};
						uiSleep 1;
					};
					RM_DISPLAYTEXT_PUBVAR = ["",0,0.7,1,0];
					publicVariable "RM_DISPLAYTEXT_PUBVAR";
					diag_log format ["[SERVER RESTART] -> SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
				}
				else
				{
					RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF0000' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 60 SECONDS<br/><t color='#FF0000'>LOG OUT NOW!</t>",0,0.7,10,0];
					publicVariable "RM_DISPLAYTEXT_PUBVAR";
					diag_log format ["[SERVER RESTART] -> 60 SECONDS UNTIL SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
					uiSleep 60;
					diag_log format ["[SERVER RESTART] -> SERVER RESTART - CURRENT SERVER TIME IS %1", 'HHMMSS' call _checkServerTime];
				};
				checkServerTime = false;
			};
		};
	} forEach _hardResetTimes;
	uiSleep 1;
	_ticksEnd = round(diag_TickTime);
	_ticksEndLoop = round(_ticksEnd - _ticksLoop);
	if (_realSecondsTime >= 86400) then
	{
		_realSecondsTime = 0;
	};
	_realSecondsTime = _realSecondsTime + _ticksEndLoop;
};
