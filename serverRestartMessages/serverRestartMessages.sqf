/*
	----------------------------------------------------------------------------------------------
	
	Copyright © 2016 soulkobk (soulkobk.blogspot.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.

	----------------------------------------------------------------------------------------------
	
	Name: serverRestartMessages.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 01/01/2016
	Modification Date: 12:00 PM 01/01/2016
	
	Description:
	This script must be used with real_date (http://killzonekid.com/arma-extension-real_date-dll/)
	extention to get the server time on script execution, and must also be executed server side only!
	
	The following line needs to be placed in the client init.sqf file (client side).
	"RM_DISPLAYTEXT_PUBVAR" addPublicVariableEventHandler {(_this select 1) spawn BIS_fnc_dynamicText;};

	The following line needs to be placed in the server init.sqf (server side).
	[] execVM "server\scripts\serverRestartMessages\serverRestartMessages.sqf";
	
	The script is informative only and will display messages on all clients when the server is due
	to restart. Please note, this script does NOT restart the server, you will need to sync this
	script up with your own	restart times (bec client/batch file/hosted restart/script restart).

	Parameter(s): none

	Example: none
	
	----------------------------------------------------------------------------------------------
*/

_hardResetTimes = ["04:00:00","10:00:00","16:00:00","22:00:00"]; // HARD RESET TIMES IN HH:MM:SS
_lastMinuteCountDown = true; // COUNTS DOWN ON SCREEN FROM 60 SECONDS TO 0 SECONDS
_lockServerAt5Minutes = true; // LOCK THE SERVER 5 MINUTES BEFORE RESTART?

/*	------------------------------------------------------------------------------------------
										DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

#define SECSPERHOUR 3600
#define SECSPERMIN 60

checkServerTime = true;

_30minCheck = false; _20minCheck = false; _10minCheck = false; _5minCheck = false; _2minCheck = false; _1minCheck = false;
_realServerTime = call compile ("real_date" callExtension "+"); _realServerTimeHour = _realserverTime select 3; _realServerTimeMin = _realserverTime select 4; _realServerTimeSec = _realserverTime select 5;
_realSecondsTime = (_realServerTimeHour * SECSPERHOUR); _realSecondsTime = (_realSecondsTime + (_realServerTimeMin * SECSPERMIN)); _realSecondsTime = (_realSecondsTime + _realServerTimeSec);

diag_log format ["[SERVER RESTART] -> RESTART TIMES ARE %1 - CURRENT SERVER TIME IS [%2:%3:%4]",_hardResetTimes,_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];

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
			case ((_realSecondsTime >= (_hardSecondsTime - (30 * 60))) && (_realSecondsTime <= (_hardSecondsTime - (30 * 60) + 60)) && !_30minCheck) :
			{
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 30 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 30 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];
				_30minCheck = true;
			};
			case ((_realSecondsTime >= (_hardSecondsTime - (20 * 60))) && (_realSecondsTime <= (_hardSecondsTime - (20 * 60) + 60)) && !_20minCheck) :
			{
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 20 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 20 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];
				_30minCheck = true;
				_20minCheck = true;
			};
			case ((_realSecondsTime >= (_hardSecondsTime - (10 * 60))) && (_realSecondsTime <= (_hardSecondsTime - (10 * 60) + 60)) && !_10minCheck) :
			{
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FFFF00' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 10 MINUTES",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 10 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];	
				_30minCheck = true;
				_20minCheck = true;
				_10minCheck = true;
			};
			case ((_realSecondsTime >= (_hardSecondsTime - (5 * 60))) && (_realSecondsTime <= (_hardSecondsTime - (5 * 60) + 60)) && !_5minCheck) :
			{
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF5500' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 5 MINUTES<br/><t color='#FF5500' size='0.65'>THE SERVER IS NOW LOCKED UNTIL RESTART",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 5 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];
				_30minCheck = true;
				_20minCheck = true;
				_10minCheck = true;
				_5minCheck = true;
				if (_lockServerAt5Minutes) then
				{
					_lockServer = "[]" serverCommand "#lock";
				};
			};
			case ((_realSecondsTime >= (_hardSecondsTime - (2 * 60))) && (_realSecondsTime <= (_hardSecondsTime - (2 * 60) + 60)) && !_2minCheck) :
			{
				RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF5500' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 2 MINUTES<br/><t color='#FF5500'>LOG OUT NOW!</t>",0,0.7,10,0];
				publicVariable "RM_DISPLAYTEXT_PUBVAR";
				diag_log format ["[SERVER RESTART] -> 2 MINUTES UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];
				_30minCheck = true;
				_20minCheck = true;
				_10minCheck = true;
				_5minCheck = true;
				_2minCheck = true;
			};
			case ((_realSecondsTime >= (_hardSecondsTime - 60)) && (_realSecondsTime <= _hardSecondsTime) && !_1minCheck) :
			{
				diag_log format ["[SERVER RESTART] -> 60 SECONDS UNTIL SERVER RESTART - CURRENT SERVER TIME IS [%1:%2:%3]",_realServerTimeHour,_realServerTimeMin,_realServerTimeSec];
				_30minCheck = true;
				_20minCheck = true;
				_10minCheck = true;
				_5minCheck = true;
				_2minCheck = true;
				_1minCheck = true;
				if (_lastMinuteCountDown) then 
				{
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
				}
				else
				{
					RM_DISPLAYTEXT_PUBVAR = ["<t color='#FF0000' size='0.65'>SERVER RESTART</t><br/><t size='0.65'>THE SERVER WILL RESTART IN 60 SECONDS<br/><t color='#FF0000'>LOG OUT NOW!</t>",0,0.7,10,0];
					publicVariable "RM_DISPLAYTEXT_PUBVAR";
				};
				checkServerTime = false;
			};
		};
	} forEach _hardResetTimes;
	
	uiSleep 1;
	
	_ticksEnd = round(diag_TickTime);
	_ticksEndLoop = round(_ticksEnd - _ticksLoop);
	_realSecondsTime = _realSecondsTime + _ticksEndLoop;
};