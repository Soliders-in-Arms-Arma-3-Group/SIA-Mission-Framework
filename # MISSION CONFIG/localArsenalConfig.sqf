/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Configuration option to add items to the arsenals' of specific roles and/or to the arsenal globally.
		NOTE that the gear each player spawns in with is already added to their local arsenal.

	USAGE:
		Run locally.

	PARAMS:
		0: Array of objects to act as arsenals.
*/
// =======================================================================================
// DO NOT DELETE OR EDIT vvv

if (!hasInterface) exitWith {}; // Exit if not player

params [
	["_arsenals", [], [[]]]
];
if (_arsenals isEqualTo []) exitWith { ["localArsenalConfig Error: Invalid Parameters: %1", _this select 0] call BIS_fnc_error }; // Exit if array not given.

private _role = player getVariable ["role", "none"];
private _roleItems = [];
private _presets = [];
private _globalArsenal = [];

// DO NOT DELETE OR EDIT ^^^
// =======================================================================================
// Declare items to add to the arsenal globally (for everyone), in the brackets with quotation marks and seperated by a comma.
// Compatible with the "Export" function on the in-game attribute Arsenal editor.
_globalArsenal = ["ItemWatch"];

// Configure presets. You may also define what roles are considered infantry below, or create additional presets using the same format.
_presets = [

	// Infantry Preset
	[
		["ItemCompass","SmokeShell"], // Classnames of items to to add, seperated by a comma.
		["r","ar","aar","mg","lat","at","hat","tl","sql","medic","pltsgt","pltco","engy"] // Roles to apply it to.
	],

	// Leadership Preset
	[
		["Binocular"],
		["tl","sql","pltsgt","pltco"]
	]

];
// =======================================================================================
// DO NOT DELETE OR EDIT vvv
switch (_role) do {
// DO NOT DELETE OR EDIT ^^^
// =======================================================================================
// Configure role-specific local arsenals.
// Enter classnames of items in the brackets with quotation marks and seperated by a comma. You can also add your own roles by following the format.
// Example: case "r" : { _roleItems = ["RHS_M4","Binoculars","SmokeGrenade"] };

	// Rifleman
	case "r" : { _roleItems = [] };

	// Autorifleman
	case "ar" : { _roleItems = [] };

	// Asst. Autorifleman
	case "aar" : { _roleItems = [] };

	// Machinegunner
	case "mg" : { _roleItems = [] };

	// Light Anti-tank
	case "lat" : { _roleItems = [] };

	// Medium Anti-tank
	case "at" : { _roleItems = [] };

	// Heavy Anti-tank
	case "hat" : { _roleItems = [] };

	// Team Leader
	case "tl" : { _roleItems = [] };

	// Squad Leader
	case "sql" : { _roleItems =  [] };

	// Medic
	case "medic" : { _roleItems = [] };

	// Jet Pilot
	case "jet_pilot" : { _roleItems = [] };

	// Helicopter Pilot
	case "heli_pilot" : { _roleItems = [] };

	// Crewman
	case "crewman" : { _roleItems = [] };

	// Sniper
	case "sniper" : { _roleItems = [] };

	// Spotter
	case "spotter" : { _roleItems = [] };

	// Platoon Sergeant
	case "pltsgt" : { _roleItems = [] };

	// Platoon Lead
	case "pltco" : { _roleItems = [] };

	// Drone Operator
	case "drone_op" : { _roleItems = [] };

	// Engineer
	case "engy" : { _roleItems = [] };

	// Game Master
	case "gm" : { _roleItems = [] };

	// No role given
	case "none" : { _roleItems = [] };


// =======================================================================================
// DO NOT DELETE OR EDIT vvv

	// Role not listed error
	default { [" Role not listed in config: %1", _role] call BIS_fnc_error }; // Log error if role not listed.
};

private _arsenalContents = _roleItems + _globalArsenal;
{ [_x, _arsenalContents, false] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals;

{
	_presetItems = _x select 0;
	_presetRoles = _x select 1;

	if (_role in _presetRoles) then  { { [_x, _presetItems, false] call ace_arsenal_fnc_addVirtualItems } forEach sia_f_arsenals };
} forEach _presets;
