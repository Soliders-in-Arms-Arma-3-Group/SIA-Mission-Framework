waitUntil {!isNull player};
execVM "briefing.sqf";
["sia_f\orbat.sqf"] remoteExec ["execVM"];

sleep 1;
[] call BIS_fnc_showMissionStatus;
[[playerSide], [west, east, civilian, independent] - [playerSide]] call ace_spectator_fnc_updateSides;
execVM "sia_f\addAceActions.sqf";

player removeItem "ACE_EarPlugs";
player unassignItem "ItemGPS";
player removeItem "ItemGPS";
removeGoggles player;
player addItem "ACE_EarPlugs";

private _script_handler = [arsenals] execVM "sia_f\setupLocalArsenal.sqf";
waitUntil { scriptDone _script_handler };

waitUntil { ([] call acre_api_fnc_isInitialized) };
sleep 1; // Redundant sleep
["loadRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf";
["reorderRadioMPTT", [personalRadio]] execVM "sia_f\ACRERadioSetup.sqf";

