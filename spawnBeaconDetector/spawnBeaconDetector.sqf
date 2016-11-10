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
	
	Name: spawnBeaconDetector.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 7:05 PM 09/11/2016
	Modification Date: 7:05 PM 09/11/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This is a spawn beacon detector for
	use within A3Wasteland so that players who are equpped with a 'mine detector' can track and
	steal spawn beacons!
	
	When a spawn beacon detector is activated, beeps will sound in the 3d environment (just like a
	real detector) at the player position so that other players within ~100m can also hear the
	player trying to detect spawn beacons. Spawn beacon detectors are no longer silent!
	
	Constant 'beep' sound = facing the correct 'general' direction.
	Constant 'blip-blip' sound = facing the wrong 'general' direction.
	
	Place this script file at...
	\addons\spawnBeaconDetector\spawnBeaconDetector.sqf
	
	Place the .paa file at...
	\addons\spawnBeaconDetector\spawnBeaconDetector.paa
	
	Place the sounds directory and files at...
	\addons\spawnBeaconDetector\sounds\
	
	Edit the file...
	\client\functions\playerActions.sqf
	
	And paste in...
	["<img image='addons\spawnBeaconDetector\spawnBeaconDetector.paa'/> Spawn Beacon Detector On", "addons\spawnBeaconDetector\spawnBeaconDetector.sqf",0,-10,false,false,"","('MineDetector' in (items player)) && !spawnBeaconDetectorInProgress && vehicle player == player"],
	["<img image='addons\spawnBeaconDetector\spawnBeaconDetector.paa'/> Spawn Beacon Detector Off", {spawnBeaconDetectorInProgress = false},0,-10,false,false,"","(spawnBeaconDetectorInProgress)"],
	
	Above the line...
	[format ["<img image='client\icons\playerMenu.paa' color='%1'/> <t colo.........
	
	Edit the file...
	\client\init.sqf
	
	And paste in...
	spawnBeaconDetectorInProgress = false;
	
	Below the line...
	doCancelAction = false;
	
	Parameter(s):

	Example:
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/
	
_spawnBeaconSoundPath = [(str missionConfigFile), 0, -15] call BIS_fnc_trimString;
_spawnBeaconDetectorOn = _spawnBeaconSoundPath + "addons\spawnBeaconDetector\sounds\spawnBeaconDetectorOn.ogg";
_spawnBeaconDetectorOff = _spawnBeaconSoundPath + "addons\spawnBeaconDetector\sounds\spawnBeaconDetectorOff.ogg";
_spawnBeaconDetectorBlipBlip = _spawnBeaconSoundPath + "addons\spawnBeaconDetector\sounds\spawnBeaconDetectorBlipBlip.ogg";
_spawnBeaconDetectorBeep = _spawnBeaconSoundPath + "addons\spawnBeaconDetector\sounds\spawnBeaconDetectorBeep.ogg";

#define BETWEEN(COMPARE,START,END) (if ((COMPARE > START) && (COMPARE <= END)) then {true} else {false})

if (spawnBeaconDetectorInProgress) exitWith
{
	["You Are Already Using The Spawn Beacon Detector!", 5] call mf_notify_client;
};

if (vehicle player != player) exitWith
{
	["You Need To Be On Foot To Use The Spawn Beacon Detector!", 5] call mf_notify_client;
};

_spawnBeaconDetectorObjects = nearestObjects [player, ["Land_Tentdome_F", "Land_HandyCam_F", "Land_Device_assembled_F"], 100];

if ((count _spawnBeaconDetectorObjects) > 0) then
{
	spawnBeaconDetectorInProgress = true;
	spawnBeaconFound = false;
	["", 5] call mf_notify_client;
	playSound3D [_spawnBeaconDetectorOn, eyePos player, false, eyePos player, 1.00, 1.00, 100];
	uiSleep 0.5;
	_spawnBeaconNearest = nil;
	while {spawnBeaconDetectorInProgress} do
	{
		if !(alive player) exitWith {};
		if (vehicle player != player) exitWith
		{
			["You Got In To A Vehicle, Detection Aborted!", 5] call mf_notify_client;
			playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
			spawnBeaconDetectorInProgress = false;
		};
		if !("MineDetector" in (items player)) exitWith
		{
			["You Dropped Your Spawn Beacon Detector, Detection Aborted!", 5] call mf_notify_client;
			playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
			spawnBeaconDetectorInProgress = false;
		};
		_spawnBeaconDetectorObjects = nearestObjects [player, ["Land_Tentdome_F", "Land_HandyCam_F", "Land_Device_assembled_F"], 100];
		for [{_i = 0},{_i < (count _spawnBeaconDetectorObjects)},{_i = _i + 1}] do
		{
			_isBeacon = (_spawnBeaconDetectorObjects select _i) getVariable ["a3w_spawnBeacon", false];
			if (_isBeacon) exitWith
			{
				_spawnBeaconNearest = _spawnBeaconDetectorObjects select _i;
			};
		};
		if (isNil "_spawnBeaconNearest") exitWith
		{
			_text = format ["No Spawn Beacons Detected Within %1M, Detection Aborted!",100];
			[_text, 5] call mf_notify_client;
			playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
			spawnBeaconDetectorInProgress = false;
		};
		_spawnBeacondNearestDirection = round([player, position _spawnBeaconNearest] call BIS_fnc_relativeDirTo);
		_spawnBeaconNearestDistance = round(player distance _spawnBeaconNearest);
		if (_spawnBeaconNearestDistance <= 100) then
		{
			if ((_spawnBeacondNearestDirection > 315) || (_spawnBeacondNearestDirection < 45)) then
			{
				switch (true) do
				{
					case (BETWEEN(_spawnBeaconNearestDistance,90,100)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.82, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,80,90)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.84, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,70,80)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.86, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,60,70)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.88, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,50,60)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.90, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,40,50)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.92, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,30,40)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.94, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,20,30)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.96, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,10,20)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 0.98, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,5,10)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 1.00, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,3,5)): {playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 1.02, 100];};
					case (BETWEEN(_spawnBeaconNearestDistance,0,3)): {spawnBeaconDetectorInProgress = false; spawnBeaconFound = true;};
				};
			}
			else
			{
				playSound3D [_spawnBeaconDetectorBlipBlip, eyePos player, false, eyePos player, 1.00, 1.00, 100];
				if (BETWEEN(_spawnBeaconNearestDistance,0,3)) then
				{
					spawnBeaconDetectorInProgress = false;
					spawnBeaconFound = true;
				};
			};
			if (!spawnBeaconFound) then
			{
				uiSleep 0.1;
			};
		}
		else
		{
			["Spawn Beacons Are Out Of Detection Range, Detection Aborted!", 5] call mf_notify_client;
			playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
			spawnBeaconDetectorInProgress = false;
		};
		uiSleep 0.1;
	};
	if (spawnBeaconFound) then
	{
		["Spawn Beacon Found!", 5] call mf_notify_client;
		playSound3D [_spawnBeaconDetectorBlipBlip, eyePos player, false, eyePos player, 1.00, 1.00, 100];
		uiSleep 0.1;
		playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 1.00, 100];
		uiSleep 0.1;
		playSound3D [_spawnBeaconDetectorBlipBlip, eyePos player, false, eyePos player, 1.00, 1.00, 100];
		uiSleep 0.1;
		playSound3D [_spawnBeaconDetectorBeep, eyePos player, false, eyePos player, 1.00, 1.00, 100];
	};
	uiSleep 0.5;
	playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
}
else
{
	_text = format ["No Spawn Beacons Detected Within %1M, Detection Aborted!",100];
	[_text, 5] call mf_notify_client;
	playSound3D [_spawnBeaconDetectorOn, eyePos player, false, eyePos player, 1.00, 1.00, 100];
	uiSleep 0.5;
	playSound3D [_spawnBeaconDetectorOff, eyePos player, false, eyePos player, 1.00, 1.00, 100];
};
