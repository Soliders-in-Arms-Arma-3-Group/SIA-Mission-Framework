// Checks if player has already saved a load out, if not then saves current loadout
player setVariable ["mpttRadioList", ([] call acre_api_fnc_getMultiPushToTalkAssignment)];

player setVariable["Death_Loadout",getUnitLoadout player];

player setVariable["Last_Group",group player];
if (player == gm) then {setPlayerRespawnTime 1};