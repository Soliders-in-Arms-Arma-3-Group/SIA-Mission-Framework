/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Optional configuration option to add items to the arsenals' of specific roles.
		Note that the gear each player spawns in with is already added to their local arsenal.

	USAGE:
		Run locally.

	PARAMS:
		0: Array of objects to act as arsenals.
*/
// =======================================================================================
// DO NOT DELETE OR EDIT vvv

if (!hasInterface) exitWith {}; // Exit if not player
private _arsenals = _this select 0;
if (typeName _arsenals != "ARRAY") exitWith {["Incorrect format: %1", _arsenals] call BIS_fnc_error}; // Exit if array not given.
private _role = player getVariable ["role", "none"];
private _roleItems = [];

switch (_role) do
{
	
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
	case default { [" Role not listed in config: %1", _role] call BIS_fnc_error }; // Log error if role not listed.
};

{[_x, _roleItems, false] call ace_arsenal_fnc_addVirtualItems} forEach sia_f_arsenals;