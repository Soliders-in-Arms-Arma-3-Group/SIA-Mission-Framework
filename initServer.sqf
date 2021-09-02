startTime = date;
setTimeMultiplier 0.1;

arsenals = ((getMissionLayerEntities "Arsenals") select 0);
publicVariable "arsenals";

hasMissionStarted = false;
publicVariable "hasMissionStarted";

personalRadio = "ACRE_PRC343";
handheldRadio = "ACRE_PRC152";
manpackRadio = "ACRE_PRC117F";
publicVariable "personalRadio";
publicVariable "handheldRadio";
publicVariable "manpackRadio";

[west, 10] call BIS_fnc_respawnTickets;

 //Revo's TP Function
["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message
["addActions", [hq_button]] call TPD_fnc_teleport; // Add actions to given objects for all players
