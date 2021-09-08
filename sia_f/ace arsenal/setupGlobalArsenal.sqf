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

if (!isServer) exitWith {}; // Exit if player.

private _arsenals = _this select 0;
private _array = [];
if (typeName _arsenals != "ARRAY") exitWith {["Incorrect format: %1", _arsenals] call BIS_fnc_error}; // Exit if array not given.

{[_x, false, true] call ace_arsenal_fnc_initBox}  forEach _arsenals; // Initialize arsenals.

if (sia_f_haveBasics) then {
	_array = parseSimpleArray (loadfile "sia_f\ace arsenal\item pools\baseArsenalBasics.txt");
	{[_x, _array, true] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals;
};

if (sia_f_acreEnabled) then {
	{
		_acreRadios = ([] call acre_api_fnc_getAllRadios) select 0;
		if (_x != "NONE") then {
			_y = _x;
			if (_x in _acreRadios) then { {[_x, [_y], true] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals }
			else {["Radio type: Invalid option: %1", _x] call BIS_fnc_error}; // Log error if wrong input given.
		}
	} forEach [sia_f_personalRadio, sia_f_handheldRadio, sia_f_manpackRadio];
};

if (sia_f_haveCTab) then {
	_array = parseSimpleArray (loadfile "sia_f\ace arsenal\item pools\baseArsenalcTab.txt");
	{[_x, _array, true] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals;
};

switch (sia_f_haveKATMedical) do {

	case "FULL" : 
	{
	_array = parseSimpleArray (loadfile "sia_f\ace arsenal\item pools\baseArsenalKATFull.txt");
	{[_x, _array, true] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals; 
	};

	case "LIMITED" :
	{ 
	_array = parseSimpleArray (loadfile "sia_f\ace arsenal\item pools\baseArsenalKATLimited.txt");
	{[_x, _array, true] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals;
	};

	case "NONE" : {};

	case default
	{
		["sia_f_haveKATMedical: Invalid option: %1", sia_f_haveKATMedical] call BIS_fnc_error; // Log error if wrong input given.
	};
}
 
