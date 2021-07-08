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

if (!hasInterface) exitWith {}; // Exit if not human player

private _arsenals = _this select 0;
if (typeName _arsenals != "ARRAY") exitWith {}; // Exit if array not given.

{[_x, false, false] call ace_arsenal_fnc_initBox}  forEach _arsenals; // Initialize arsenals.

// Add player's loadout to player's local arsenal
_loadout = (getUnitLoadout player);
_loadout = str _loadout splitString "[]," joinString ",";
_loadout = parseSimpleArray ("[" + _loadout + "]");
_loadout = _loadout arrayIntersect _loadout select {_x isEqualType "" && {_x != ""}};
{[_x, _loadout] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;

// Create array of player's primary and secondary weapon magazines, and add them to global arsenal.
_mags = primaryWeaponMagazine player;
_mags = _mags + secondaryWeaponMagazine player;
{[_x, _mags, true] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;
