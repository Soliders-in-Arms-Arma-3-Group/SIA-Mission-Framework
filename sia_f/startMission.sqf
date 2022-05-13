/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Code that executes when mission has started. 

	USAGE:
		Should only be ran on the server.

	PARAMS:
		0: Object - the zeus, used to display Zeus's name in intro text if enabled.
*/
#include "..\# MISSION CONFIG\Settings\briefing.hpp"
#include "..\# MISSION CONFIG\Settings\missionInfo.hpp"

if (!isServer) exitWith {}; // Exit if not server.

if (isMultiplayer) then { setDate startTime }; // Set time to start of mission.
setTimeMultiplier 1; // Set time acceleration to default.

// Update variable.
sia_f_missionStarted = true;
publicVariable "sia_f_missionStarted";

if (SIA_BRIEF_LOADOUT) then { remoteExec ["sia_f_fnc_loadoutNotes"] }; // Refresh loadout information if enabled.

sleep 1;

// Update phase to "Mission Started".
sia_f_setupPhase = "In Progress";
["setupPhase", ["Mission is a go!", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
[""] remoteExec ["hintSilent"];

if (SIA_SHOW_REPLAY) then { [] remoteExec ["GRAD_replay_fnc_init", 0, true] }; // Start GRAD replay recording if enabled.

// Display intro text if enabled.
if (SIA_SHOW_INTRO_TEXT) then {
	sleep 3;
	private _zeus = _this select 0;
	[sia_f_missionName] remoteExec ["BIS_fnc_moduleMissionName", _zeus];
	sleep 10;
	["sia_f\introText.sqf"] remoteExec ["execVM"];
};
