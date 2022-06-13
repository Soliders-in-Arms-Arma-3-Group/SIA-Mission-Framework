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

waitUntil { !isNull player };

private ["_action", "_statement"];

if (!isNil "sia_f_ACEButtons" && sia_f_enableTPToSquad) then {
	_action = ["TpSquad", "Teleport to Squad", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\meet_ca.paa", { [_this select 1] spawn sia_f_fnc_teleportToSquad }, { true }] call ace_interact_menu_fnc_createAction;
	{ [_x, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject } forEach sia_f_ACEButtons;
};

// === Manage Loadouts =======================================================================================
if (sia_f_enableManageKit) then {
	_statement = {
		player setVariable ["Saved_Loadout", getUnitLoadout player];
		hint "Kit saved. Will be loaded on respawn.";
	};
	_action = ["siaKit", "Save/Manage Kit", "\A3\Ui_F\Data\IGUI\Cfg\Actions\gear_ca.paa", _statement, { true }] call ace_interact_menu_fnc_createAction;
	{ [_x, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject; } forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["SaveKit", "Save Current Kit", "\A3\Ui_F\Data\GUI\Rsc\RscDisplayArcadeMap\icon_save_ca.paa", _statement, { true }] call ace_interact_menu_fnc_createAction;
	{ [_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject; } forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["LoadKit", "Load Saved Kit", "\A3\Ui_F\Data\IGUI\Cfg\Actions\reammo_ca.paa", { player setUnitLoadout (player getVariable ["Saved_Loadout", []]); hint "Saved kit loaded." }, { true }] call ace_interact_menu_fnc_createAction;
	{ [_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject; } forEach (sia_f_ACEButtons + sia_f_arsenals);

	_action = ["ClearKit", "Remove Saved Kit", "z\ace\addons\arsenal\data\iconClearContainer.paa", { player setVariable ["Saved_Loadout", nil]; hint "Saved kit cleared. Will use kit from death when respawned" }, { true }] call ace_interact_menu_fnc_createAction;
	{ [_x, 0, ["ACE_MainActions", "siaKit"], _action, true] call ace_interact_menu_fnc_addActionToObject; } forEach (sia_f_ACEButtons + sia_f_arsenals);
};

// === SIA actions =======================================================================================
_action = ["SIA", " SIA Options", "sia_f\images\sia_tiny.paa", {}, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToClass;

if (sia_f_enableGoAFK) then {
	_action = ["SIA_AFK", "Go AFK", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\wait_ca.paa", { [] spawn sia_f_fnc_goAFK }, { !(player getVariable ["sia_isAFK", false]) }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;
};

// === Update Loadout Info =======================================================================================
if (sia_f_enableLoadoutInfo && sia_f_briefLoadout) then {
	_action = ["loadoutInfo", "Update Team Loadout Info", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\documents_ca.paa", {
		call sia_f_fnc_loadoutNotes;
		[] spawn {
			sleep 0.2; openMap true;
			player selectDiarySubject "Diary";
		};
	}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;
};

// === Mission Info Hint System =======================================================================================
_action = ["SIA_Hint", "Show Mission Info", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\unknown_ca.paa", { call sia_f_fnc_hint }, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;

_statement = {
	if (sia_f_showStatusHint) then {
		sia_f_showStatusHint = false;
		hint "Persistent Hint is now DISABLED";
	} else {
		sia_f_showStatusHint = true;
		hint "Persistent Hint is now ENABLED";
	};
};

_action = ["SIA_Hint_Toggle", "Toggle Persistent Hint", "", _statement, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_Hint"], _action] call ace_interact_menu_fnc_addActionToClass;

// === SIA Misc Actions =======================================================================================
_action = ["SIA_MusicStop", "Stop Music", "\A3\Ui_F\Data\IGUI\RscIngameUI\RscUnitInfoAirRTDFull\ico_cpt_music_OFF_ca.paa", { playMusic "" }, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["SIA_MusicMute", "Mute All Music", "", { 1 fadeMusic 0 }, { musicVolume > 0 }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_MusicStop"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["SIA_MusicUnmute", "Unmute All Music", "", { 1 fadeMusic 0.5 }, { musicVolume <= 0 }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_MusicStop"], _action] call ace_interact_menu_fnc_addActionToClass;

// === SIA Radio Actions =======================================================================================
if (sia_f_acreEnabled) then {
	_action = ["SIA_ConfigACRE", "ACRE Settings", "\A3\Ui_F\Data\IGUI\Cfg\simpleTasks\types\radio_ca.paa", {
		["loadRadioDefaultSpatials", []] spawn sia_f_fnc_ACRERadioSetup;
		["reorderRadioMPTT", [sia_f_personalRadio]] spawn sia_f_fnc_ACRERadioSetup;
		hint "Saved settings loaded.";
	}, { true }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass;
};

{
	private _displayName = (getText (ConfigFile >> "CfgWeapons" >> _x >> "displayName") splitString "AN/") select 0;
	private _configName = _x;
	private _iconPath = getText (configFile >> "CfgWeapons" >> _x >> "picture");
	_action = [("SIA_ConfigACRE_Radios" + _configName), _displayName, _iconPath, {}, { true }] call ace_interact_menu_fnc_createAction;
	[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

	{
		_action = [("SIA_ConfigSpatial_" + _configName + _x), ( "Set " + _x +  " As Default"), "", {
			params ["", "", "_params"];
			["setRadioDefaultSpatial", [_params select 0, _params select 1]] spawn sia_f_fnc_ACRERadioSetup;
		}, { true }, {}, [_configName, _x]] call ace_interact_menu_fnc_createAction;
		[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE", ("SIA_ConfigACRE_Radios" + _configName)], _action] call ace_interact_menu_fnc_addActionToClass;
	} forEach ["LEFT", "CENTER", "RIGHT"];

} forEach ["ACRE_PRC343", "ACRE_PRC148","ACRE_PRC152","ACRE_PRC77","ACRE_PRC117F"];

_action = ["SIA_loadSpatials", "Load Saved Settings", "", {
	["loadRadioDefaultSpatials", []] spawn sia_f_fnc_ACRERadioSetup;
	["reorderRadioMPTT", [sia_f_personalRadio]] spawn sia_f_fnc_ACRERadioSetup;
}, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["SIA_resetSpatials", "Clear Saved Settings", "", { ["resetRadioDefaultSpatials", []] spawn sia_f_fnc_ACRERadioSetup; }, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["SIA_getSpatials", "Print Saved Settings", "", { ["printRadioDefaultSpatials", []] spawn sia_f_fnc_ACRERadioSetup; }, { true }] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "SIA_ConfigACRE"], _action] call ace_interact_menu_fnc_addActionToClass;

// === Zeus/Plt actions =======================================================================================
_action = ["setupPhase", "Set Phase", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\use_ca.paa", {}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;
if ((player getVariable ["role", ""]) == "pltco") then { [(typeOf player), 1, ["ACE_SelfActions", "SIA"], _action] call ace_interact_menu_fnc_addActionToClass; }; // Give plt leader access to phase change.

_action = ["upperbrief", "Upper-level Brief", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa", {
	["setupPhase", ["The upper-level brief is commencing!", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
	sia_f_setupPhase = "Upper-level Briefing";
	publicVariable "sia_f_setupPhase";
}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToZeus;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["lowerbrief", "Lower-level Brief", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa", {
	["setupPhase", ["The lower-level brief is commencing!", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\whiteboard_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
	sia_f_setupPhase = "Lower-level Briefing";
	publicVariable "sia_f_setupPhase";
}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToZeus;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["kitUp", "Kit Up", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa", {
	["setupPhase", ["Time to kit up!", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\rearm_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
	sia_f_setupPhase = "Kitting Up";
	publicVariable "sia_f_setupPhase";
}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToZeus;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["mountUp", "Mount Up", "\A3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa", {
	["setupPhase", ["Time to mount up!", "\A3\ui_f\data\IGUI\Cfg\HoldActions\holdAction_loadDevice_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
	sia_f_setupPhase = "Mounting Up";
	publicVariable "sia_f_setupPhase";
}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToZeus;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToClass;

_action = ["standby", "Stand By", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\wait_ca.paa", {
	["setupPhase", ["Stand By", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\wait_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
	sia_f_setupPhase = "Standing By";
	publicVariable "sia_f_setupPhase";
}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToZeus;
[(typeOf player), 1, ["ACE_SelfActions", "SIA", "setupPhase"], _action] call ace_interact_menu_fnc_addActionToClass;

// Start Mission Action + Confirmation
_action = ["missionStart", "Start Mission", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\getin_ca.paa", {}, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;

_action = ["missionStartConfirm", "Confirm", "", { [[player], "sia_f\startMission.sqf"] remoteExec ["execVM", 2] }, { !sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "missionStart"], _action] call ace_interact_menu_fnc_addActionToZeus;

// End Mission Action + Confirmation
_action = ["missionEnd", "End Mission", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\getOut_ca.paa", {}, { sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions"], _action] call ace_interact_menu_fnc_addActionToZeus;

_action = ["missionEndWin", "Win", "", { [[true],"sia_f\endMission.sqf"] remoteExec ["execVM", 2] }, { sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "missionEnd"], _action] call ace_interact_menu_fnc_addActionToZeus;

_action = ["missionEndLose", "Lose", "", { [[false],"sia_f\endMission.sqf"] remoteExec ["execVM", 2] }, { sia_f_missionStarted }] call ace_interact_menu_fnc_createAction;
[["ACE_ZeusActions", "missionEnd"], _action] call ace_interact_menu_fnc_addActionToZeus;
