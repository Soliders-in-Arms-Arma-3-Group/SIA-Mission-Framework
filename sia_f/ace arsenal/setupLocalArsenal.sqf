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

// Add player's loadout to player's local arsenal.
_loadout = (getUnitLoadout player);
_loadout = str _loadout splitString "[]," joinString ",";
_loadout = parseSimpleArray ("[" + _loadout + "]");
_loadout = _loadout arrayIntersect _loadout select {_x isEqualType "" && {_x != ""}};
{[_x, _loadout, false] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;

// Run local arsenal config.
[_arsenals] execVM "# MISSION CONFIG\localArsenalConfig.sqf";

// Add magazines to global arsenal.
[_arsenals] execVM "sia_f\ace arsenal\addMagazinesToArsenal.sqf";