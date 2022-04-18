/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: BaerMitUmlaut (https://github.com/acemod/ACE3/pull/7944/files)
			Modified by Siege

=====================================================================

	Description:
		Serializes the medical state of a unit into a string.
		TEMPORARY until next ACE update.
		Anything that had VAR_... or DEFAULT_... was converted from that macro to the actual value
		see these links for how I did that:
		https://github.com/acemod/ACE3/blob/master/addons/medical_engine/script_macros_medical.hpp
		https://ace3.acemod.org/wiki/development/coding-guidelines.html#21-modulepbo-specific-macro-usage


	PARAMS:
		0: Unit <OBJECT> - Unit to get medical state from

	Returns:
		String - Unit's serialize medical state as JSON string

	Example:
		[player] call sia_f_fnc_serializeState
*/
params [
	["_unit", objNull, [objNull]]
];

private _state = call CBA_fnc_createNamespace;

{
	_x params ["_var"];
	_state setVariable [_var, _unit getVariable _x];
} forEach [
	["ace_medical_bloodVolume", 6.0],
	["ace_medical_heartRate", 80],
	["ace_medical_bloodPressure", [80, 120]],
	["ace_medical_peripheralResistance", 100],
	["ace_medical_hemorrhage", 0],
	["ace_medical_pain", 0],
	["ace_medical_inPain", false],
	["ace_medical_painSuppress", 0],
	["ace_medical_openWounds", []],
	["ace_medical_bandagedWounds", []],
	["ace_medical_stitchedWounds", []],
	["ace_medical_fractures", [0, 0, 0, 0, 0, 0]],
	["ace_medical_tourniquets", [0, 0, 0, 0, 0, 0]],
	["ace_medical_occludedMedications", nil],
	["ace_medical_ivBags", nil],
	["ace_medical_triageLevel", 0],
	["ace_medical_triageCard", []],
	["ace_medical_bodyPartDamage", [0, 0, 0, 0, 0, 0]]
];

// Convert medications time to offset
private _medications = _unit getVariable ["ace_medical_medications", []];
{
	_x set [1, _x # 1 - CBA_missionTime];
} forEach _medications;
_state setVariable ["ace_medical_medications", _medications];

// Medical statemachine state
private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
_state setVariable ["ace_medical_statemachineState", _currentState];

// Serialize & return
private _json = [_state] call sia_f_fnc_encodeJSON;
_state call CBA_fnc_deleteNamespace;
_json
