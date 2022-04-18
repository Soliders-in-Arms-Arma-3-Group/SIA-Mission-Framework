player setVariable ["mpttRadioList", ([] call acre_api_fnc_getMultiPushToTalkAssignment)];

player setVariable ["Death_Loadout", getUnitLoadout player];

player setVariable ["Last_Group", group player];

player setVariable ["Had_Earplugs_In", ([player] call ace_hearing_fnc_hasEarPlugsIn)];

[player, 4] call ace_medical_treatment_fnc_setTriageStatus // Set player's corpse triage to "Deceased"
