// F3 - Safe Start
// MODIFIED BY LIAM MCKENDRICK FOR SIA
// Credits: Please see the F3 online manual (http://www.ferstaberinde.com/f3/en/)
// ====================================================================================
//	This script inits the Mission Timer and the Safe Start, has the server setup the publicVariable
//      while the client waits, sets units invincibility and displays hints, then disables it.

// ====================================================================================

// BEGIN SAFE-START LOOP
// If a value was set for the mission-timer, begin the safe-start loop and turn on invincibility

sleep 10; // Give everything a second to settle;
// ToDo: replace with a waitUntil

if (sia_f_missionStarted) exitWith {};

// The server will handle the loop and notifications
if (isServer && sia_f_showStatusHint) then {
	[] spawn {
		while { !sia_f_missionStarted } do {
			remoteExec ["sia_f_fnc_hint"];
			sleep 30; // Refresh every 30 seconds
		};
	};
};

// Enable invincibility for players, but not the GM
if (hasInterface && !((player getVariable "role") in ["gm_blufor","gm_opfor","gm_independent","gm"])) then { 

	player allowDamage false;
	{ [player, _x, true] call ace_safemode_fnc_setWeaponSafety } forEach (weapons player);
	player setVariable ["ace_common_effect_blockThrow", 1]; // force use vanilla throwing so the event handler works (need to make ensure that another function doesn't set it to 0)
	player setVariable ["ace_explosives_PlantingExplosive", true]; // This is the only way to stop planting of explosives that I could find

	private _FiredMan_EH = player addEventHandler ["FiredMan", {
		deleteVehicle (_this # 6);
		
		if (_this # 1 == "Throw") then {
			(_this # 0) addItem (_this # 4); // replace lost grenades, smokes, etc.
		};
	}];

	while { !sia_f_missionStarted } do { // ToDo: Find event handler that does this (CBA "weaponMode" doesn't work because it doesn't account for just turning off the safety)
		// This still doesn't really work, players can just hold down their change fire mode button and shoot normally.
		waitUntil { (player getVariable "ace_safemode_safedWeapons") isNotEqualTo (weapons player) || sia_f_missionStarted };
		if (!sia_f_missionStarted) then {
			{ [player, _x, true] call ace_safemode_fnc_setWeaponSafety } forEach ((weapons player) - (player getVariable "ace_safemode_safedWeapons"));
		};
	};

	// reset everything to their proper states
	player allowDamage true;
	{ [player, _x, false] call ace_safemode_fnc_setWeaponSafety } forEach (weapons player);
	player setVariable ["ace_common_effect_blockThrow", 0];
	player setVariable ["ace_explosives_PlantingExplosive", false];
	player removeEventHandler ["FiredMan", _FiredMan_EH];
};