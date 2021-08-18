/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds "Manage Loadout" and "Teleport to Squad" functions as Ace Actions to objects.

	USAGE:
		Run locally for all player clients start.

	PARAMS:
		0: Array of objects
*/

waitUntil {!isNull player};

if (!isNil "hq_button") then {
_tphq = ["TpSL", "Teleport to Squad", "", {[_this select 1]execVM "scripts\tp.sqf"}, {true}] call ace_interact_menu_fnc_createAction; 
[hq_button, 0, ["ACE_MainActions"], _tphq, true] call ace_interact_menu_fnc_addActionToObject;

// Manage Loadouts
	_action = ["Loadout", "Manage Loadout", "images\gear_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[hq_button, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

	_action = ["SaveKit", "Save Loadout", "images\reammo_ca.paa", {player setVariable["Saved_Loadout",getUnitLoadout player]; hint "Loadout saved. Will be loaded on respawn."}, {true}] call ace_interact_menu_fnc_createAction; 
	[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;

	_action = ["LoadKit", "Load Loadout", "z\ace\addons\disarming\UI\disarm.paa", {player setUnitLoadout(player getVariable["Saved_Loadout",[]]); hint "Loadout loaded."}, {true}] call ace_interact_menu_fnc_createAction; 
	[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;

	_action = ["ClearKit", "Remove Saved Loadout", "z\ace\addons\arsenal\data\iconClearContainer.paa", {player setVariable["Saved_Loadout",nil]; hint "Loadout cleared. Will save loadout on death."}, {true}] call ace_interact_menu_fnc_createAction; 
	[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;
};

// SIA actions 
	_action = ["SIA", "SIA Options", "sia_f\images\sia_tiny.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;
	
	_action = ["SIA_AFK", "Go AFK", "", {execVM "sia_f\goAFK\goAFK.sqf"}, { !(player getVariable["sia_isAFK",false]) }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;

	// SIA Radio Actions
	_action = ["SIA_ConfigACRE", "ACRE Settings", "", {}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;

{
	private _displayName = (getText (ConfigFile >> "CfgWeapons" >> _x >> "displayName") splitString "AN/") select 0;
	private _configName = _x;
	private _iconPath = getText (configfile >> "CfgWeapons" >> _x >> "picture");
	_action = [("SIA_ConfigACRE_Radios" + _configName), _displayName, _iconPath, {}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;
	 
	{
	_action = [("SIA_ConfigSpatial_" + _configName + _x),( "Set " + _x +  " As Default"), "", {params ["", "", "_params"]; ["setRadioDefaultSpatial", [_params select 0, _params select 1]] execVM "sia_f\ACRERadioSetup.sqf"}, {true}, {}, [_configName, _x]] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE", ("SIA_ConfigACRE_Radios" + _configName)], _action] call ace_interact_menu_fnc_addActionToClass;
	} forEach ["LEFT", "CENTER", "RIGHT"];

} forEach ["ACRE_PRC343", "ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"];

	_action = ["SIA_loadSpatials", "Load Saved Settings", "", { ["loadRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf"; ["reorderRadioMPTT", [personalRadio]] execVM "sia_f\ACRERadioSetup.sqf"; }, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

	_action = ["SIA_resetSpatials", "Clear Saved Settings", "", { ["resetRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf" }, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

	_action = ["SIA_getSpatials", "Print Saved Settings", "", { ["printRadioDefaultSpatials", []] execVM "sia_f\ACRERadioSetup.sqf" }, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

// Zeus action
_statement = {
    hasMissionStarted = true; 
	publicVariable "hasMissionStarted";
	["sia_f\startMission.sqf"] remoteExec ["execVM", 2];
};
_action = ["missionStart","Start Mission","",_statement,{!hasMissionStarted}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;