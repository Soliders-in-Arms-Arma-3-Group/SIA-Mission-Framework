/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds player's primary/secondary magazines to the global arsenal.

	USAGE:
		Run locally.

	PARAMS:
		0: Array of objects to act as arsenals.
*/

params [
	["_arsenals", [], [[]]]
];
if (_arsenals isEqualTo []) exitWith { ["addMagazinesToArsenal Error: Invalid Parameters: %1", _this select 0] call BIS_fnc_error }; // Exit if array not given.

private _mags = primaryWeaponMagazine player;
{ _mags pushBackUnique _x } forEach (secondaryWeaponMagazine player); // Create array of player's primary and secondary weapon magazines, and add them to every arsenal.
{ [_x, _mags, true] call ace_arsenal_fnc_addVirtualItems } forEach _arsenals;
