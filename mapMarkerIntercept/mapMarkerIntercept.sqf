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
	
	Name: mapMarkerIntercept.sqf
	Version: 1.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 5:34 PM 29/05/2016
	Modification Date: 5:34 PM 29/05/2016
	
	Description:
	For use with A3Wasteland 1.2b mission (A3Wasteland.com). The script creates dynamic mission map
	markers for use with mission spawning based upon conditions/defines set up in this scripts
	configuration.
	
	Modify server\missions\setupMissionArrays.sqf to run this script, and place this script in the
	directory server\functions\.
	Add in the following 2 lines above the MissionSpawnMarkers = []; declaration.
	_mapMarkerIntercept = [] execVM "server\functions\mapMarkerIntercept.sqf";
	waitUntil {scriptDone _mapMarkerIntercept};

	Parameter(s): none

	Example: none
	
	Change Log:
	1.0 - original base script, defines for use with map Stratis.
	
	----------------------------------------------------------------------------------------------
*/

// The current defines are set up for the map of Stratis (for use with A3Wasteland Stratis 1.2b)

#define MAPWIDTH 8250
#define MAPHEIGHT 8250

#define MAPSTEPS 45

#define MINWATERDEPTH 40
#define MAXWATERDEPTH 41

#define MAXGRADE 0.5
#define MAXRADIUS 15

// If defined, the below debug will show each position and radius on the map as colored map markers.
// #define __DUBUG__

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

{
	switch (true) do
	{
		case (["Mission_", _x] call fn_startsWith):
		{
			deleteMarker _x;
		};
		case (["SunkenMission_", _x] call fn_startsWith):
		{
			deleteMarker _x;
		};
	};
} forEach allMapMarkers;

diag_log "[MAP MARKER INTERCEPT] - DELETED ALL LAND MISSION AND SUNKEN MISSION MAP MARKERS!";

_xPos = (MAPWIDTH / MAPSTEPS);
_yPos = (MAPHEIGHT / MAPSTEPS);

_xPosMeters = MAPSTEPS;
_yPosMeters = MAPSTEPS;

_maxGradient = MAXGRADE;
_maxGradientRadius = MAXRADIUS;

_minWaterDepth = MINWATERDEPTH;
_maxWaterDepth = MAXWATERDEPTH;

_xPosMetersCurr = _xPosMeters;
_yPosMetersCurr = _yPosMeters;

_yPosMax = false;

while {!(_yposMax)} do
{
	_mapPosCurr = [_xPosMetersCurr,_yPosMetersCurr,0];
	_mapPosCurrDepth = ASLtoATL _mapPosCurr;
	_mapPosCurrDepth = (_mapPosCurrDepth select 2);
	if ((surfaceIsWater _mapPosCurr) && (_mapPosCurrDepth >= _minWaterDepth) && (_mapPosCurrDepth <= _maxWaterDepth)) then
	{
		_markerstr = createMarker [format ["SunkenMission_%1",_mapPosCurr],_mapPosCurr];
		#ifdef __DUBUG__
		_markerstr setMarkerShape "ELLIPSE";
		_markerstr setMarkerSize [_maxGradientRadius,_maxGradientRadius];
		_markerstr setMarkerColor "colorBlue";
		_markerstr setMarkerAlpha 1;
		#endif
	}
	else
	{
		_isFlatEmpty = !(_mapPosCurr isFlatEmpty [_maxGradientRadius, -1, _maxGradient, _maxGradientRadius, 0, false] isEqualTo []);
		if (_isFlatEmpty) then
		{
			_isOnRoad = isOnRoad _mapPosCurr;
			_isOnShore = !(_mapPosCurr isFlatEmpty  [-1, -1, -1, -1, 0, true] isEqualTo []);
			_isNearRoad = !(_mapPosCurr nearRoads (_maxGradientRadius * 2) isEqualTo []);
			if ((!_isOnShore) && (!_isOnRoad) && (!_isNearRoad)) then
			{
				_markerstr = createMarker [format ["Mission_%1",_mapPosCurr],_mapPosCurr];
				#ifdef __DUBUG__
				_markerstr setMarkerShape "ELLIPSE";
				_markerstr setMarkerSize [_maxGradientRadius,_maxGradientRadius];
				_markerstr setMarkerColor "colorGreen";
				_markerstr setMarkerAlpha 1;
				#endif
			};
		};
	};
	_xPosMetersCurr = _xPosMetersCurr + _xPosMeters;
	if (_xPosMetersCurr > (_xPosMeters * _xPos)) then
	{
		_xPosMetersCurr = _xPosMeters;
		_yPosMetersCurr = _yPosMetersCurr + _yPosMeters;
	};
	if (_yPosMetersCurr > (_yPosMeters * _yPos)) then
	{
		_yposMax = true;
	};
};

diag_log "[MAP MARKER INTERCEPT] - DYNAMICALLY CREATED NEW MAP MARKERS FOR ALL LAND MISSIONS AND SUNKEN MISSIONS!";
