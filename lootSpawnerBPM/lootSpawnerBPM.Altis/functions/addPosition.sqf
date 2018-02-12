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

	Name: addPosition.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 12:00 PM 08/06/2016
	Modification Date: 6:00 PM 02/02/2018

	Description:

	Parameter(s): none

	Example: none

	Change Log:
	1.0.0 - original base script.

	----------------------------------------------------------------------------------------------
*/

if (isNil "bldPosArr") then
{
	bldPosArr = []
};

_posIsWater = false;
_pos = getPosATL player;

if (surfaceIsWater _pos) then
{
	_pos = getPosASL player;
	_posIsWater = true;
};

if (isNil "currBuilding") exitWith
{
	hint parseText "<t color='#ff0000' align='center'>ERROR</t><br/>BUILDING CLASS NOT REGISTERED<br/>PRESS 'G' FIRST!<br/>TO REGISTER A BUILDING CLASS";
};

_bldPos = currBuilding worldToModel _pos;
if (player inArea currBuildingMkrID) then
{
	if !(_bldPos in bldPosArr) then
	{
		bldPosArr pushbackUnique _bldPos;
		_object = createVehicle ["Sign_Arrow_Yellow_F",getPosATL player, [], 0, "CAN_COLLIDE"];
		if (_posIsWater isEqualTo true) then
		{
			_object setPosASL (getPosASL player);
		};
		_object disableCollisionWith player;
		hint parseText format ["<t color='#00ff00' align='center'>ADDED BUILDING POSITION</t><br/>%1<br/>TO BUILDING<br/><br/>'%2'<br/><br/>COPIED<br/><t color='#ffff00' align='center'>%3</t><br/>BUILDING POSITIONS TO CLIPBOARD",str _bldPos,(typeOf currBuilding),(count bldPosArr)];
		_string = format ["_buildingPos_%1 = %2;",(typeOf currBuilding),str bldPosArr];
		copyToClipboard _string;
	};
}
else
{
	hint parseText format ["<t color='#ff0000' align='center'>ERROR</t><br/>POSITION<br/>%1<br/><t color='#ff0000' align='center'>IS NOT WITHIN THE BOUNDS OF</t><br/>'%2'<br/>AT POSITION<br/>%3",_bldPos,(typeOf currBuilding),(getPos currBuilding)];
};
