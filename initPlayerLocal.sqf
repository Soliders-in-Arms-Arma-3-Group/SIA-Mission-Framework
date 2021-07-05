waitUntil {!isNull player};

[] call BIS_fnc_showMissionStatus;
[[playerSide], [west, east, civilian, independent] - [playerSide]] call ace_spectator_fnc_updateSides;
execVM "briefing.sqf";
["scripts\orbat.sqf"] remoteExec ["execVM"];
execVM "scripts\autoRadioSetup.sqf";


player removeItem "ACE_EarPlugs";
player removeItem "ItemGPS";
removeGoggles player;
player addItem "ACE_EarPlugs";


