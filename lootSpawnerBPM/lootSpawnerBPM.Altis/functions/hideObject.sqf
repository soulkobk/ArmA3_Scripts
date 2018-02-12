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

	Name: hideObject.sqf
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

_bld2Hide = nearestObjects [player, ["House","Ruins"], 50];
_bld2Hide = _bld2Hide select 0;
hideObject _bld2Hide;
