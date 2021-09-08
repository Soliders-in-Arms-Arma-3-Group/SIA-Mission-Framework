waitUntil {!isNull player};
waitUntil {sia_f_setupComplete};

sia_f_factionName = "";
// Get player side and faction name
	switch (side player) do
	{
		case west : { sia_f_factionName = sia_f_bluforFactionName; execVM "# MISSION CONFIG\briefing_blufor.sqf" };	

		case east : { sia_f_factionName = sia_f_opforFactionName; execVM "# MISSION CONFIG\briefing_opfor.sqf" };	

		case independent : { sia_f_factionName = sia_f_indepFactionName; execVM "# MISSION CONFIG\briefing_independent.sqf" };	

		case default { };
	};

	if (sia_f_factionName == "") then { sia_f_factionName = getText (configfile >> "CfgFactionClasses" >> (faction player) >> "displayName") };

	sia_f_roleName = roleDescription player; 
	if (sia_f_roleName == "") then {_role = (getText(configFile >> "CfgVehicles" >> (typeOf player) >> "displayName"))} else {sia_f_roleName = (sia_f_roleName splitString "@") select 0}; // If roleDescription is set, then truncate. Else use config name.


sleep 1;
[] call BIS_fnc_showMissionStatus;
[[playerSide], [west, east, civilian, independent] - [playerSide]] call ace_spectator_fnc_updateSides;
execVM "sia_f\addAceActions.sqf";

player removeItem "ACE_EarPlugs";
player unassignItem "ItemGPS";
player removeItem "ItemGPS";
removeGoggles player;
player addItem "ACE_EarPlugs";


sleep 3; // Redundant sleep

private _script_handler = [sia_f_arsenals] execVM "sia_f\ace arsenal\setupLocalArsenal.sqf";
waitUntil { scriptDone _script_handler };

private _script_handler = [] execVM "sia_f\giveACRERadios.sqf";
waitUntil { scriptDone _script_handler };

waitUntil { ([] call acre_api_fnc_isInitialized) };
["loadRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf";
["reorderRadioMPTT", [sia_f_personalRadio]] execVM "sia_f\ACRERadioSetup.sqf";

