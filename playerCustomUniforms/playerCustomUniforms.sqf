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

	Name: playerCustomUniforms.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:47 PM 27/11/2016
	Modification Date: 4:47 PM 27/11/2016

	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script allows use of custom
	uniform textures for groups/donators/vip/etc based off a uniform class within the ArmA 3
	configuration if the player UID is matched within the configuration.
	
	Within the _playerCustomUniforms array below, see 'TEMPLATE' for the base structure of how
	this script is configured. The configuration is set up to easily allow for multiple entries.
	
	This script is 100% client side, so in order to change/add/update you will need to repack
	your mission file each time.
	
	Place this script at...
	\addons\playerCustomUniforms\playerCustomUniforms.sqf
	
	Edit...
	\client\init.sqf
	And paste in...
	[] execVM "addons\playerCustomUniforms\playerCustomUniforms.sqf";
	At the bottom of the script.
	
	Add any custom uniform textures to directory...
	\addons\playerCustomUniforms\textures\
	
	Edit...
	\client\clientEvents\onRespawn.sqf
	And paste in...
	[] spawn SL_customUniformCheck;
	At the bottom of the script.
	
	Edit...
	\client\systems\generalStore\buyItems.sqf
	And paste in...
	[] spawn SL_customUniformCheck;
	Underneath the line...
	player forceAddUniform _class;

	Lastly, customize the configuration below via the '_playerCustomUniforms' variable/array.
	
	*NOTE, no uniform templates are supplied with this script, it is entirely up to the end user
	to obtain/extract uniform textures and customize them.
	
	Parameter(s): none

	Example: none
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

if (!hasInterface) exitWith {};  // DO NOT DELETE THIS LINE!

_playerCustomUniforms =
[
	///////////////////////////////////////////////////////////////////////////////////////////////
	// TEMPLATE...
	[ // <GROUPNAME>
		[ // "UID", // <NICKNAME>
			"76561192222222222", //<USERNAME>
			"76561193333333333"  //<USERNAME>
		],
		[ // ["<SIDE>","<UNIFORM CLASS>","<FILE PATH OF REPLACEMENT TEXTURE>"],
			["WEST","U_B_CombatUniform_mcam","addons\playerCustomUniforms\textures\<group>UniformWEST.jpg"], // WEST/BLUFOR 'DEFAULT' UNIFORM
			["EAST","U_O_OfficerUniform_ocamo","addons\playerCustomUniforms\textures\<group>UniformEAST.jpg"], // EAST/OFPOR 'DEFAULT' UNIFORM
			["GUER","U_I_CombatUniform","addons\playerCustomUniforms\textures\<group>UniformGUER.jpg"]  // GUER/INDEPENDENT 'DEFAULT' UNIFORM
		]
	],
	///////////////////////////////////////////////////////////////////////////////////////////////
	[ // TAG
		[
			"765611944444444444", //<USERNAME>
			"765611955555555555"  //<USERNAME>
		],
		[
			["WEST","U_B_CombatUniform_mcam","addons\playerCustomUniforms\textures\tagUniformWEST.jpg"],
			["EAST","U_O_OfficerUniform_ocamo","addons\playerCustomUniforms\textures\tagUniformEAST.jpg"],
			["GUER","U_I_CombatUniform","addons\playerCustomUniforms\textures\tagUniformGUER.jpg"]
		]
	],
	[ // KOBK
		[
			"76561196666666666", //<USERNAME>
			"76561197777777777"  //<USERNAME>
		],
		[
			["WEST","U_B_CombatUniform_mcam","addons\playerCustomUniforms\textures\kobkUniformWEST.jpg"],
			["EAST","U_O_OfficerUniform_ocamo","addons\playerCustomUniforms\textures\kobkUniformEAST.jpg"],
			["GUER","U_I_CombatUniform","addons\playerCustomUniforms\textures\kobkUniformGUER.jpg"]
		]
	],
	[ // G4
		[
			"76561198888888888", //<USERNAME>
			"76561199999999999"  //<USERNAME>
		],
		[
			["WEST","U_B_CombatUniform_mcam","addons\playerCustomUniforms\textures\g4UniformWEST.jpg"],
			["EAST","U_O_OfficerUniform_ocamo","addons\playerCustomUniforms\textures\g4UniformEAST.jpg"],
			["GUER","U_I_CombatUniform","addons\playerCustomUniforms\textures\g4UniformGUER.jpg"]
		]
	]
];

/*	------------------------------------------------------------------------------------------
	DO NOT EDIT BELOW HERE!
	------------------------------------------------------------------------------------------	*/

SL_customUniformCheck = {
	_hasCustomUniform = player getVariable ["SL_customUniform",false];
	if (_hasCustomUniform) exitWith
	{
		waitUntil {uiSleep 0.1; !(player getVariable ["playerSpawning", true]);};
		if ((uniform player == SL_customUniformClassWEST) && ((str (side player)) == "WEST")) then
		{
			player setObjectTextureGlobal [0,SL_customUniformTextureWEST];
		};
		if ((uniform player == SL_customUniformClassEAST) && ((str (side player)) == "EAST")) then
		{
			player setObjectTextureGlobal [0,SL_customUniformTextureEAST];
		};
		if ((uniform player == SL_customUniformClassGUER) && ((str (side player)) == "GUER")) then
		{
			player setObjectTextureGlobal [0,SL_customUniformTextureGUER];
		};
	};
};
	
if !(_playerCustomUniforms isEqualTo []) then
{
	{
		_groupUIDs = _x select 0;
		if ((getPlayerUID player) in _groupUIDs) exitWith
		{
			diag_log format ["[PLAYER CUSTOM UNIFORMS] -> UID %1 FOUND, APPLIED CUSTOM UNIFORM DATA TO %2.",(getPlayerUID player),(name player)];
			player setVariable ["SL_customUniform",true,false];
			_customUniformClassList = _x select 1;
			{
				_customUniformSide = _x select 0;
				switch (_customUniformSide) do
				{
					case "WEST": {
						SL_customUniformClassWEST = _x select 1;
						SL_customUniformTextureWEST = _x select 2;
						};
					case "EAST": {
						SL_customUniformClassEAST = _x select 1;
						SL_customUniformTextureEAST = _x select 2;
						};
					case "GUER": {
						SL_customUniformClassGUER = _x select 1;
						SL_customUniformTextureGUER = _x select 2;
						};
				};
			} forEach _customUniformClassList;
			player addEventHandler ["Take", {
				_unit = _this select 0;
				_container = _this select 1;
				_item = _this select 2;
				if ((_item == SL_customUniformClassWEST) && (uniform _unit == SL_customUniformClassWEST) && ((str (side _unit)) == "WEST")) then
				{
					_unit setObjectTextureGlobal [0,SL_customUniformTextureWEST];
				};
				if ((_item == SL_customUniformClassEAST) && (uniform _unit == SL_customUniformClassEAST) && ((str (side _unit)) == "EAST")) then
				{
					_unit setObjectTextureGlobal [0,SL_customUniformTextureEAST];
				};
				if ((_item == SL_customUniformClassGUER) && (uniform _unit == SL_customUniformClassGUER) && ((str (side _unit)) == "GUER")) then
				{
					_unit setObjectTextureGlobal [0,SL_customUniformTextureGUER];
				};
			}];
			[] spawn SL_customUniformCheck;
		};
	} forEach _playerCustomUniforms;
};
