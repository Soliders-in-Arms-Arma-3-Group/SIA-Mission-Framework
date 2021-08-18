player setVariable ["mpttRadioList", ([] call acre_api_fnc_getMultiPushToTalkAssignment)];

player setVariable["Death_Loadout",getUnitLoadout player];

player setVariable["Last_Group",group player];