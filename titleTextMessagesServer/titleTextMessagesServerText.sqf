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
	
	Name: titleTextMessagesServerText.sqf
	Version: 1.0.0
	Author: soulkobk (soulkobk.blogspot.com)
	Creation Date: 4:59 PM 11/10/2016
	Modification Date: 4:57 PM 19/10/2016
	
	Description:
	For use with A3Wasteland 1.Xx mission (A3Wasteland.com). This script MUST be paired up with
	thetitleTextMessagesServer.sqf
	
	You are able to edit this file whenever you want to! After a server restart, it will display the
	updated messages. You no longer need to edit and repack your mission.pbo to change messages!
	
	Place this file SERVER SIDE at...
	\A3Wasteland_settings\titleTextMessagesServerText.sqf
	
	Parameter(s): ["<MESSAGE>",<FADE OUT DURATION>,<SLEEP DURATION>],

	Example: ["You are playing on the [KOBK] A3Wasteland Stratis server.",2,15],
	
	Change Log:
	1.0.0 -	original base script.
	
	----------------------------------------------------------------------------------------------
*/

[
    ["You are playing on the [KOBK] A3Wasteland Stratis server.",2,15],
    ["TeamSpeak -> 127.0.0.1:12701",2,15],
    ["WWW/Forums -> github.com/soulkobk",2,15],
    ["Server restarts are at 6am, 12pm, 6pm and 12am daily (AEST).",2,15],
    ["Day/Night cycle is 5 hours day, 1 hour night per 6 hour session.",2,15],
    ["Voice and text chat have been disabled, please use TeamSpeak for communication.",2,15],
    ["Any queries? Direct them to the administrators via TeamSpeak or the Forum.",30],
    ["Enjoy the server? Tell your friends!",2,15],
    ["Want to become a part of the [KOBK] clan? You can apply via our WWW site.",2,15],
    ["Want to help cover server costs? You can donate via our WWW site.",2,15],
	["Enjoy your time on the battle field!",2,15]
];
