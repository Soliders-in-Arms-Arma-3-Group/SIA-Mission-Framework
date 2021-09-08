/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds player's kit to their local arsenal, and adds their primary/secondary magazines to the global arsenal.

	USAGE:
		Run locally for all players.

	PARAMS:
		0: Array of objects to act as arsenals.
*/

if (!hasInterface) exitWith {}; // Exit if not player

private _arsenals = _this select 0;
if (typeName _arsenals != "ARRAY") exitWith {["Incorrect format: %1", _arsenals] call BIS_fnc_error}; // Exit if array not given.

private _role = player getVariable ["role", "none"];

// Add player's loadout to player's local arsenal
_loadout = (getUnitLoadout player);
_loadout = str _loadout splitString "[]," joinString ",";
_loadout = parseSimpleArray ("[" + _loadout + "]");
_loadout = _loadout arrayIntersect _loadout select {_x isEqualType "" && {_x != ""}};
{[_x, _loadout] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;

// Run local arsenal config
[_arsenals] execVM "# MISSION CONFIG\localArsenalConfig.sqf";

// Add radios
if (sia_f_acreEnabled) then {
	if (sia_f_personalRadio == "ACRE_PRC343") then {player addItem sia_f_personalRadio};

	if (sia_f_handheldRadio == "ACRE_PRC152" || sia_f_handheldRadio == "ACRE_PRC148") then {
		if ((_role == "sql") || (_role == "tl") || (_role == "pltco") || (_role == "pltsgt") || (_role == "gm")) then {player addItem sia_f_handheldRadio};
	};

	if (sia_f_manpackRadio == "ACRE_PRC77" || sia_f_manpackRadio == "ACRE_PRC117F") then {
		if ((_role == "pltco") || (_role == "pltsgt")) then {player addItem sia_f_manpackRadio};
	};
};