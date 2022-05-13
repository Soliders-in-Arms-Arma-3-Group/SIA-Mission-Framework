/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Initializes and sets up global arsenal.

	USAGE:
		Run on server.

	PARAMS:
		0: Array of objects to act as arsenals.
*/
#include "..\..\# MISSION CONFIG\Settings\arsenal.hpp"
#include "..\..\# MISSION CONFIG\Settings\radio.hpp"

if (!isServer) exitWith {}; // Exit if player.

params [
	["_arsenals", [], [[]]]
];
if (_arsenals isEqualTo []) exitWith { ["setupGlobalArsenal Error: Invalid Parameters: %1", _this select 0] call BIS_fnc_error }; // Exit if array not given.

private _array = [];
{ [_x, false, true] call ace_arsenal_fnc_initBox } forEach _arsenals; // Initialize arsenals.

if (SIA_HAVE_BASICS) then {
	_array = parseSimpleArray (loadFile "sia_f\ace arsenal\item pools\baseArsenalBasics.txt");
	{ [_x, _array, true] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;
};

if (SIA_ACRE_ENABLED) then {
	{
		private _acreRadios = ([] call acre_api_fnc_getAllRadios) select 0;
		if (_x != "NONE") then {
			private _y = _x;
			if (_x in _acreRadios) then {
				{ [_x, [_y], true] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;
			} else {
				["setupGlobalArsenal Error: Radio type - Invalid option: %1", _x] call BIS_fnc_error; // Log error if wrong input given.
			};
		};
	} forEach [SIA_PERSONAL_RADIO, SIA_HANDHELD_RADIO, SIA_MANPACK_RADIO];
};

if (SIA_HAVE_CTAB) then {
	_array = parseSimpleArray (loadFile "sia_f\ace arsenal\item pools\baseArsenalcTab.txt");
	{ [_x, _array, true] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;
};

switch (SIA_HAVE_KAT_MEDICAL) do {
	case "FULL" : 
	{
		_array = parseSimpleArray (loadFile "sia_f\ace arsenal\item pools\baseArsenalKATFull.txt");
		{ [_x, _array, true] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;
	};

	case "LIMITED" :
	{ 
		_array = parseSimpleArray (loadFile "sia_f\ace arsenal\item pools\baseArsenalKATLimited.txt");
		{ [_x, _array, true] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;
	};

	case "NONE" : {};

	case default
	{
		["SIA_HAVE_KAT_MEDICAL: Invalid option: %1", SIA_HAVE_KAT_MEDICAL] call BIS_fnc_error; // Log error if wrong input given.
	};
}
