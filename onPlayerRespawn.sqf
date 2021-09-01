removeAllWeapons player;
removeGoggles player;
removeHeadgear player;
removeVest player;
removeUniform player;
removeAllAssignedItems player;
clearAllItemsFromBackpack player;
removeBackpack player;

// Load saved player loadout
_loadout = player getVariable "Saved_Loadout";

// If player does not have a saved loadout, load loadout from death
if (isNil "_loadout") then {player setUnitLoadout(player getVariable["Death_Loadout",[]]);} else {player setUnitLoadout(_loadout);  hint "Saved loadout loaded."};

// Give player earplugs
player removeItem "ACE_EarPlugs";
player addItem "ACE_EarPlugs";

// Failsafe add player to old group
_sqd = player getVariable["Last_Group",[]];
if (group player != _sqd) then {player joinSilent _sqd};

// Restore ACRE PTT Assignment
waitUntil { ([] call acre_api_fnc_isInitialized) };
["loadRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf";
["reorderRadioMPTT", [personalRadio]] execVM "sia_f\ACRERadioSetup.sqf";

// Exit player from AFK if still set as AFK
private _isAFK = player getVariable["sia_isAFK",false];
if (_isAFK) then { [false] execVM "sia_f\goAFK\exitAFK.sqf" };
