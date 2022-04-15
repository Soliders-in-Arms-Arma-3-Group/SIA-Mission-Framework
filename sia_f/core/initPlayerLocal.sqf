waitUntil {!isNull player};
waitUntil {!isNil "sia_f_setupComplete"}; // Test if this is needed
waitUntil {sia_f_setupComplete};

sia_f_factionName = "";
// Get player side and faction name
	switch (side player) do
	{
		case west: { sia_f_factionName = sia_f_bluforFactionName; execVM "# MISSION CONFIG\briefing_blufor.sqf" };

		case east: { sia_f_factionName = sia_f_opforFactionName; execVM "# MISSION CONFIG\briefing_opfor.sqf" };

		case independent: { sia_f_factionName = sia_f_indepFactionName; execVM "# MISSION CONFIG\briefing_independent.sqf" };

		default {};
	}; // could do this by renaming bluefor, opfor, and indep in these vars/files to west, east, and independent, then just parse each of them.

	if (sia_f_factionName == "") then { sia_f_factionName = getText (configfile >> "CfgFactionClasses" >> (faction player) >> "displayName") };

	sia_f_roleName = roleDescription player;
	if (sia_f_roleName != "") then { // If roleDescription is set, then truncate. Else use config name.
		sia_f_roleName = (sia_f_roleName splitString "@") select 0;
	} else {
		sia_f_roleName = getText (configFile >> "CfgVehicles" >> (typeOf player) >> "displayName");
	};

if (([(side player)] call BIS_fnc_respawnTickets) > 0) then { [] call BIS_fnc_showMissionStatus }; // Check if tickets are avaliable, if so, display them
[[playerSide], [west, east, civilian, independent] - [playerSide]] call ace_spectator_fnc_updateSides; // Update ACE Spectator to hide enemy sides.
execVM "sia_f\addAceActions.sqf";

player removeItem "ACE_EarPlugs";
player unassignItem "ItemGPS";
player removeItem "ItemGPS";
removeGoggles player;
player addItem "ACE_EarPlugs";

private _script_handler = [sia_f_arsenals] execVM "sia_f\ace arsenal\setupLocalArsenal.sqf";
waitUntil { scriptDone _script_handler };

private _script_handler = [] execVM "sia_f\radios\giveACRERadios.sqf";
waitUntil { scriptDone _script_handler };

// Setup and load ACRE Settings
["loadRadioDefaultSpatials", []] execVM "sia_f\radios\ACRERadioSetup.sqf";
["reorderRadioMPTT", [sia_f_personalRadio]] execVM "sia_f\radios\ACRERadioSetup.sqf";

["ace_arsenal_displayClosed", {
	["loadRadioDefaultSpatials", []] execVM "sia_f\radios\ACRERadioSetup.sqf";
	["reorderRadioMPTT", [sia_f_personalRadio]] execVM "sia_f\radios\ACRERadioSetup.sqf";
}] call CBA_fnc_addEventHandler;
