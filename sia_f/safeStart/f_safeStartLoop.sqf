// F3 - Safe Start, Server Loop
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
//=====================================================================================

// Run the loop only on the server
if !(isServer) exitWith {};

while { !sia_f_missionStarted } do {
	// Update mission information
	remoteExec ["sia_f_fnc_hint"];

	uisleep 60; // Sleep 60 seconds

	// If mission timer has been terminated by admin briefing, simply exit
	//if (sia_f_missionStarted) exitWith {};
	{ [ACE_player, _x, true] call ace_safemode_fnc_setWeaponSafety } forEach (weapons ACE_player);
};

//Once the mission timer has reached 0, disable the safeties
if (sia_f_missionStarted) then {
	// Broadcast message to players
	["Mission starting now!"] remoteExec ["hint"];

	// Remotely execute script to disable safety for all selectable units
};
