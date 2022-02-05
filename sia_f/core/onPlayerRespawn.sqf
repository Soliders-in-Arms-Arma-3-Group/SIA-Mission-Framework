// Load saved player loadout
_loadout = player getVariable "Saved_Loadout";

// If player does not have a saved loadout, load loadout from death
if (isNil "_loadout") then {player setUnitLoadout(player getVariable["Death_Loadout",[]]);} else {player setUnitLoadout(_loadout);  hint "Saved kit loaded."};

// Check if player had earplugs in on death, and put them back in.
if (player getVariable["Had_Earplugs_In", false]) then {
player removeItem "ACE_EarPlugs";
player addItem "ACE_EarPlugs";
[player, true] call ace_hearing_fnc_putInEarplugs;
};

// Failsafe add player to old group
_sqd = player getVariable["Last_Group",[]];
if (group player != _sqd) then {player joinSilent _sqd};

// Restore ACRE PTT Assignment
waitUntil { ([] call acre_api_fnc_isInitialized) };
["loadRadioDefaultSpatials", []] execVM "sia_f\radios\ACRERadioSetup.sqf";
["reorderRadioMPTT", [sia_f_personalRadio]] execVM "sia_f\radios\ACRERadioSetup.sqf";

// Exit player from AFK if still set as AFK
private _isAFK = player getVariable["sia_isAFK",false];
if (_isAFK) then { [false] execVM "sia_f\goAFK\exitAFK.sqf" };
