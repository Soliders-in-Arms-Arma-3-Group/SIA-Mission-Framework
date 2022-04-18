/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: BaerMitUmlaut (https://github.com/acemod/ACE3/pull/7944/files)
			Modified by Siege

=====================================================================

	Description:
		Deserializes the medical state of a unit and applies it.
		TEMPORARY until next ACE update.
		Anything that had VAR_... or DEFAULT_... was converted from that macro to the actual value
		see these links for how I did that:
		https://github.com/acemod/ACE3/blob/master/addons/medical_engine/script_macros_medical.hpp
		https://ace3.acemod.org/wiki/development/coding-guidelines.html#21-modulepbo-specific-macro-usage
		I had to guess what ERROR_1 meant, just changed it to our error logging convention


	PARAMS:
		0: Unit <OBJECT> - Unit to apply medical state to
		1: State as JSON <STRING> - medical state to apply to unit

	Returns:
		None

	Example:
		[player, _json] call sia_f_fnc_deserializeState
*/
params [
	["_unit", objNull, [objNull]],
	["_json", "{}", [""]]
];

if (isNull _unit) exitWith {};
if (!local _unit) exitWith { ["deserializeState Error: unit [%1] is not local", _unit] call BIS_fnc_error };

// If unit is not initialized yet, wait until event is raised
if !(_unit getVariable ["ace_medical_initialized", false]) exitWith {
	["ace_medical_status_initialized", {
		params ["_unit"];
		_thisArgs params ["_target"];

		if (_unit == _target) then {
			_thisArgs call sia_f_fnc_deserializeState;
			[_thisType, _thisId] call CBA_fnc_removeEventHandler;
		};
	}, _this] call CBA_fnc_addEventHandlerArgs;
};

private _state = [_json] call CBA_fnc_parseJSON;

// Set medical variables
{
	_x params ["_var", "_default"];
	private _value = _state getVariable _x;
	// Treat null as nil
	if (_value isEqualTo objNull) then {
		if (isNil "_default") then {
			_value = nil;
		} else {
			_value = _default;
		};
	};

	if (isNil "_value") then {
		_unit setVariable [_var, nil, true];		
	} else {
		_unit setVariable [_var, _value, true];
	};
	// engine was yelling at me for trying to use setVariable with a nil _value, so that is why there are so many seemingly pointless ifs here
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

// Reset timers
_unit setVariable ["ace_medical_lastWakeUpCheck", nil];

// Convert medications offset to time
private _medications = _state getVariable ["ace_medical_medications", []];
{
	_x set [1, _x # 1 + CBA_missionTime];
} forEach _medications;
_unit setVariable ["ace_medical_medications", _medications, true];

// Update effects
[_unit] call ace_medical_engine_fnc_updateDamageEffects;
[_unit] call ace_medical_status_fnc_updateWoundBloodLoss;

// Transition within statemachine
private _currentState = [_unit, ace_medical_STATE_MACHINE] call CBA_statemachine_fnc_getCurrentState;
private _targetState = _state getVariable ["ace_medical_statemachineState", "Default"];
[_unit, ace_medical_STATE_MACHINE, _currentState, _targetState] call CBA_statemachine_fnc_manualTransition;

// Manually call wake up transition if necessary
if (_currentState in ["Unconscious", "CardiacArrest"] && {_targetState in ["Default", "Injured"]}) then {
	[_unit, false] call ace_medical_status_fnc_setUnconsciousState;
};

_state call CBA_fnc_deleteNamespace;
