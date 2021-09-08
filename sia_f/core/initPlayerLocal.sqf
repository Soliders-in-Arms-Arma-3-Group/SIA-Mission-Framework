execVM "# MISSION CONFIG\briefing.sqf";


sia_f_factionName = "";

sleep 1;
[] call BIS_fnc_showMissionStatus;
[[playerSide], [west, east, civilian, independent] - [playerSide]] call ace_spectator_fnc_updateSides;
execVM "sia_f\addAceActions.sqf";

player removeItem "ACE_EarPlugs";
player unassignItem "ItemGPS";
player removeItem "ItemGPS";
removeGoggles player;
player addItem "ACE_EarPlugs";

sleep 1;

// Get faction name
	switch (side player) do
	{
		case west : { sia_f_factionName = sia_f_bluforFactionName };	

		case east : { sia_f_factionName = sia_f_opforFactionName };	

		case independent : { sia_f_factionName = sia_f_indepFactionName };	

		case default { };
	};

	if (sia_f_factionName == "") then { sia_f_factionName = getText (configfile >> "CfgFactionClasses" >> (faction player) >> "displayName") };

	roleName = roleDescription player; 
	if (roleName == "") then {_role = (getText(configFile >> "CfgVehicles" >> (typeOf player) >> "displayName"))} else {roleName = (roleName splitString "@") select 0}; // If roleDescription is set, then truncate. Else use config name.

sleep 3; // Redundant sleep

private _script_handler = [sia_f_arsenals] execVM "sia_f\ace arsenal\setupLocalArsenal.sqf";
waitUntil { scriptDone _script_handler };

waitUntil { ([] call acre_api_fnc_isInitialized) };
["loadRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf";
["reorderRadioMPTT", [sia_f_personalRadio]] execVM "sia_f\ACRERadioSetup.sqf";

