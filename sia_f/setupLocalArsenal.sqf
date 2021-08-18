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

{[_x, false, false] call ace_arsenal_fnc_initBox}  forEach _arsenals; // Initialize arsenals.

private _role = player getVariable "role";
private _roleItems = "";

private _scopes = ["optic_hamr","optic_mrco","rhsusf_acc_g33_xps3"];

// r, ar, aar, mg, lat, at, tl, sql, medic, pilot, pltsgt, pltco, gm
switch (_role) do
{
	case "ar" : { _roleItems = ["150Rnd_556x45_Drum_Mag_Tracer_F"] };
	case "aar" : { _roleItems = ["ACE_SpareBarrel"] };
	case "mg" : { _roleItems = _scopes + "ACE_SpareBarrel" };
	case "lat" : { _roleItems = ["rhs_weap_M136_hedp","rhs_weap_M136"] };
	case "at" : { _roleItems = ["launch_MRAWS_green_F","MRAWS_HEAT_F","MRAWS_HEAT55_F","MRAWS_HE_F"] };
	case "tl" : { _roleItems = _scopes };
	case "sql" : { _roleItems = _scopes + ["ItemcTab"] };
	case "medic" : { _roleItems = ["IP_B_Kitbag_KSK_Medic_Full","IP_B_AssaultPack_KSK_Medic"] };
	case "pilot" : { _roleItems = ["IP_V_6094_KSK_1_Green"] };
	case "pltsgt" : { _roleItems = [manpackRadio] };
	case "pltco" : { _roleItems = [manpackRadio] };
	case "gm" : {};
};

// Create array of player's primary and secondary weapon magazines, and add them to global arsenal.
private _mags = primaryWeaponMagazine player;
_mags arrayIntersect (secondaryWeaponMagazine player);
{if ( isClass (configFile >> "CFGMagazines" >> _x)) then {_mags pushBackUnique _x}} forEach _roleItems;
{[_x, _mags, true] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;

// Add player's loadout to player's local arsenal
_loadout = (getUnitLoadout player);
_loadout = str _loadout splitString "[]," joinString ",";
_loadout = parseSimpleArray ("[" + _loadout + "]");
_loadout = _loadout arrayIntersect _loadout select {_x isEqualType "" && {_x != ""}};
{_loadout pushBackUnique _x} forEach _roleItems;
{[_x, _loadout] call ace_arsenal_fnc_addVirtualItems} forEach _arsenals;

// Add radios
player addItem personalRadio;
if ((_role == "sql") || (_role == "tl") || (_role == "pltco") || (_role == "pltsgt") || (_role == "gm")) then {player addItem handheldRadio};
if ((_role == "pltco") || (_role == "pltsgt")) then {player addItem manpackRadio};
