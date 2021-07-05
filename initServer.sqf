arsenals = [ars1, ars2, ars3];
publicVariable "arsenals";

ENH_AmbientFlyby_Enabled = false;

[west, 10] call BIS_fnc_respawnTickets;

missionStarted = false;
publicVariable "missionStarted";

crossedRiver = false;
publicVariable "crossedRiver";

// Revo's TP Function
["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message
["addActions", [hq_button]] call TPD_fnc_teleport; // Add actions to given objects for all players