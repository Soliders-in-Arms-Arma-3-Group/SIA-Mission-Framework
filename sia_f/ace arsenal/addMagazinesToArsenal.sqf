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


private _mags = primaryWeaponMagazine player;
_mags arrayIntersect (secondaryWeaponMagazine player); // Create array of player's primary and secondary weapon magazines, and add them to global arsenal.
{if ( isClass (configFile >> "CFGMagazines" >> _x)) then {_mags pushBackUnique _x}} forEach _roleItems;
{[_x, _mags, true] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;
