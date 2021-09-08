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

if (!isNil "sia_f_ACEButtons" && sia_f_enableTPToSquad) then {
_action = ["TpSquad", "Teleport to Squad", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\meet_ca.paa", {[_this select 1]execVM "sia_f\teleportToSquad.sqf"}, {true}] call ace_interact_menu_fnc_createAction; 
{[_x, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject} forEach sia_f_ACEButtons;
};


// Manage Loadouts
if (sia_f_enableManageKit) then {
	_statement = {
		player setVariable["Saved_Loadout",getUnitLoadout player]; 
		hint "Kit saved. Will be loaded on respawn."
	};
	_action = ["siaKit", "Save/Manage Kit", "\A3\Ui_F\Data\IGUI\Cfg\Actions\gear_ca.paa", _statement, {true}] call ace_interact_menu_fnc_createAction;
	{[_x, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;} forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["SaveKit", "Save Current Kit", "\A3\Ui_F\Data\GUI\Rsc\RscDisplayArcadeMap\icon_save_ca.paa", _statement, {true}] call ace_interact_menu_fnc_createAction; 
	{[_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject;} forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["LoadKit", "Load Saved Kit", "\A3\Ui_F\Data\IGUI\Cfg\Actions\reammo_ca.paa", {player setUnitLoadout(player getVariable["Saved_Loadout",[]]); hint "Saved kit loaded."}, {true}] call ace_interact_menu_fnc_createAction; 
	{[_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject;} forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["ClearKit", "Remove Saved Kit", "z\ace\addons\arsenal\data\iconClearContainer.paa", {player setVariable["Saved_Loadout",nil]; hint "Saved kit cleared. Will use kit from death when respawned"}, {true}] call ace_interact_menu_fnc_createAction; 
	{[_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject;} forEach (sia_f_ACEButtons + sia_f_arsenals);
};

// SIA actions 
	_action = ["SIA", "SIA Options", "sia_f\images\sia_tiny.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;
	
	if (sia_f_enableGoAFK) then {
	_action = ["SIA_AFK", "Go AFK", "", {execVM "sia_f\goAFK\goAFK.sqf"}, { !(player getVariable["sia_isAFK",false]) }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;
	};
	
	// SIA Radio Actions
	if (sia_f_acreEnabled) then {
	_action = ["SIA_ConfigACRE", "ACRE Settings", "", {}, {true}] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;
	};

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
    sia_f_missionStarted = true; 
	publicVariable "sia_f_missionStarted";
	["sia_f\startMission.sqf"] remoteExec ["execVM", 2];
};
_action = ["missionStart","Start Mission","",_statement,{!sia_f_missionStarted}] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;