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
	
	Name: fixTownStreetLamps.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 6:42 PM 05/11/2016
	Modification Date: 6:42 PM 05/11/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script will check your town lamps
	to see if they have been shot out (globes blown), if so it will fix it and turn each lamp back on.
	
	The maximum time any lamp in the town area is able to stay off is set by the variable
	_sleepTimeBetweenChecks. When the lamps	turn back on, they will realistically (or as close to)
	flicker back to the on state.
	
	Place this script at...
	\addons\fixTownStreetLamps\fixTownStreetLamps.sqf
	
	Edit file...
	\server\init.sqf
	
	And paste at the bottom of the script...
	[] execVM "addons\fixTownStreetlamps\fixTownStreetLamps.sqf";
	
	Parameter(s):

	Example:
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

_sleepTimeBetweenChecks = 30*60; // default is 30 minutes.

_typesOfLamps =
[
	"Lamps_Base_F",
	"Land_LampAirport_F",
	"Land_LampSolar_F",
	"Land_LampStreet_F",
	"Land_LampStreet_small_F",
	"PowerLines_base_F",
	"Land_LampDecor_F",
	"Land_LampHalogen_F",
	"Land_LampHarbour_F",
	"Land_LampShabby_F",
	"Land_PowerPoleWooden_L_F",
	"Land_NavigLight",
	"Land_runway_edgelight",
	"Land_runway_edgelight_blue_F",
	"Land_Flush_Light_green_F",
	"Land_Flush_Light_red_F",
	"Land_Flush_Light_yellow_F",
	"Land_Runway_PAPI",
	"Land_Runway_PAPI_2",
	"Land_Runway_PAPI_3",
	"Land_Runway_PAPI_4",
	"Land_fs_roof_F",
	"Land_fs_sign_F"
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

_townMarkerArray = [];
{
	if (["Town_", _x] call fn_startsWith) then
	{
		_townMarkerArray pushBack _x;
	};
} forEach allMapMarkers;

_townDetails = compileFinal preprocessFileLineNumbers "mapConfig\towns.sqf";
{
	_townMarkerCurr = _x;
	{
		_townMarkerName = _x select 0;
		_townMarkerRadius = _x select 1;
		_townMarkerCityName = _x select 2;
		_townMarkerPos = getMarkerPos _townMarkerName;
		if (_townMarkerCurr isEqualTo _townMarkerName) then
		{
			[_townMarkerPos,_townMarkerRadius,_townMarkerCityName,_sleepTimeBetweenChecks,_typesOfLamps] spawn
			{
				params ["_townMarkerPos","_townMarkerRadius","_townMarkerCityName","_sleepTimeBetweenChecks","_typesOfLamps"];
				diag_log format ["[FIX TOWN STREET LAMPS] -> %1 ENABLED (%2M RADIUS)",_townMarkerCityName,_townMarkerRadius];
				while {true} do
				{
					_townLampsNextCheck = diag_tickTime + _sleepTimeBetweenChecks;
					_townLamps = nearestObjects [_townMarkerPos, _typesOfLamps, _townMarkerRadius];
					{
						_townLamp = _x;
						_townLampHitIndexes = count (getAllHitPointsDamage _townLamp select 0);
						if (!isNil "_townLampHitIndexes") then
						{
							if (_townLampHitIndexes > 0) then
							{
								[_townLamp,_townLampHitIndexes] spawn
								{
									params ["_townLamp","_townLampHitIndexes"];
									for "_i" from 0 to (_townLampHitIndexes - 1) do
									{
										_townLampIndexDamage = _townLamp getHitIndex _i;
										if (_townLampIndexDamage > 0) then
										{
											for "_j" from 0 to round(random 5) do
											{
												_townLamp setHitIndex [_i,1];
												uiSleep (random 0.5);
												_townLamp setHitIndex [_i,0];
												uiSleep (random 0.5);
											};
										};
									};
								};
							};
						};
						_townLampHitIndexes = nil;
					} forEach _townLamps;
					waitUntil {diag_tickTime > _townLampsNextCheck};
				};
			};
		};
	} forEach (call _townDetails);
} forEach _townMarkerArray;
