/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Actions for the player to configure and setup their ACRE 2 radio settings.

	USAGE:
		Example: ["setRadioDefaultSpatial", ["ACRE_PRC152", "LEFT"]] execVM "sia_f\ACRERadioSetup.sqf"
	PARAMS:
		0: Mode, can be:
			"setRadioDefaultSpatial" - Updates and applies setting for given radio and ear.
			"loadRadioDefaultSpatials" - Applies all saved settings.
			"resetRadioDefaultSpatials" - Sets all settings to "BOTH".
			"printRadioDefaultSpatials" - Hints all radios with corresponding saved setting. 
			"reorderRadioMPTT" - Sets the given radio to push to talk one.
		1: Params - Parameter changes according to mode.
*/

if (!hasInterface) exitWith {}; // Exit if not player.

private ["_mode", "_params"];
_mode   = _this param [0, "", [""]];
_params = _this param [1, [], [[]]];

fnc_sia_getACREHash = {
	private _hash = profileNamespace getVariable "SIA_F_ACREDefaultSpatial"; // Load player's current default spatial settings.
	if (isNil "_hash") then { 
		["ACRE_PRC343", "ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"] createHashMapFromArray ["RIGHT","LEFT","LEFT","LEFT","LEFT"] // If player has no default settings, then load a blank template.
	} else {_hash};
};

switch (_mode) do
{
	case "setRadioDefaultSpatial" :
	{
		private _radio = _params select 0;
		private _ear =_params select 1;
		private _hash = _this call fnc_sia_getACREHash; // Get hash of settings.
		_hash set [_radio, _ear]; // Change new setting.
		profileNamespace setVariable ["SIA_F_ACREDefaultSpatial", _hash]; // Update player's settings.
		saveProfileNamespace;
		[([_radio] call acre_api_fnc_getRadioByType), _ear] call acre_api_fnc_setRadioSpatial; // Apply chosen radio spatialization.
		hint (getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName") + " is now set to ear: " + str (_hash get _radio));
	};	

	case "loadRadioDefaultSpatials" :
	{
		private _hash = _this call fnc_sia_getACREHash; // Get hash of settings.
		{
			if ([player, _x] call acre_api_fnc_hasKindOfRadio) then { 
			[([_x] call acre_api_fnc_getRadioByType), _y] call acre_api_fnc_setRadioSpatial; 
			};
		} forEach _hash; // Loop through saved settings, checking if player has that radio and applying the saved setting.
	};

	case "resetRadioDefaultSpatials" :
	{
		private _hash = ["ACRE_PRC343", "ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"] createHashMapFromArray ["BOTH","BOTH","BOTH","BOTH","BOTH"];
		profileNamespace setVariable ["SIA_F_ACREDefaultSpatial", _hash]; // Update player's settings.
		saveProfileNamespace;
		hint "Radio spatialization settings reset."
	};

	case "printRadioDefaultSpatials" :
	{
		private _hash = _this call fnc_sia_getACREHash; // Get hash of settings.
		private _str = ""; // Initialize empty string.
		{
			_str = (_str + (getText (ConfigFile >> "CfgWeapons" >> _x >> "displayName")) + " : " + _y + "\n");
		} forEach _hash;
		hint _str;
	};
	
	case "reorderRadioMPTT" :
	{
		private  _radio = ([_params select 0] call acre_api_fnc_getRadioByType);
		private _mptt = [] call acre_api_fnc_getMultiPushToTalkAssignment;
		private _index = _mptt find _radio;

		if (_index > 0) then {
			_mptt deleteAt _index;
			_mptt insert [0,[_radio]];

			private _success = [_mptt] call acre_api_fnc_setMultiPushToTalkAssignment;
			if (!_success) then {["ACRE Reorder MPTT failed!"] call BIS_fnc_error};
		};
	};

	case default
	{
		["Unknown mode: %1", _mode] call BIS_fnc_error; // Throw error if incorrect mode is given.
	};
};
