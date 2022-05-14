// F3 - Safe Start
// MODIFIED BY LIAM MCKENDRICK FOR SIA
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
//	This script inits the Mission Timer and the Safe Start, has the server setup the publicVariable
//      while the client waits, sets units invincibility and displays hints, then disables it.

// ====================================================================================

// BEGIN SAFE-START LOOP
// If a value was set for the mission-timer, begin the safe-start loop and turn on invincibility
#include "..\..\# MISSION CONFIG\Settings\missionInfo.hpp"

sleep 10; // Give everything a second to settle;
// ToDo: replace with a waitUntil

if (sia_f_missionStarted) exitWith {};

// The server will handle the loop and notifications
if (isServer && SIA_SHOW_STATUS_HINT) then {
	[] spawn {
		while { !sia_f_missionStarted } do {
			remoteExec ["sia_f_fnc_hint"];
			sleep 30; // Refresh every 30 seconds
		};
	};
};

// Enable invincibility for players
if (hasInterface) then {

	player allowDamage false;

	while {!sia_f_missionStarted} do {
		{ [ACE_player, _x, true] call ace_safemode_fnc_setWeaponSafety } forEach (weapons ACE_player);
		sleep 1;
	};

	{ [ACE_player, _x, false] call ace_safemode_fnc_setWeaponSafety } forEach (weapons ACE_player);

	player allowDamage true;
};
