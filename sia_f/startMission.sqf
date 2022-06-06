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

if (!isServer) exitWith {}; // Exit if not server.

if (isMultiplayer) then { setDate startTime }; // Set time to start of mission.
setTimeMultiplier 1; // Set time acceleration to default.

// Update variable.
sia_f_missionStarted = true;
publicVariable "sia_f_missionStarted";

if (sia_f_briefLoadout) then { remoteExec ["sia_f_fnc_loadoutNotes"] }; // Refresh loadout information if enabled.

sleep 1;

// Update phase to "Mission Started".
sia_f_setupPhase = "In Progress";
["setupPhase", ["Mission is a go!", "\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
[""] remoteExec ["hintSilent"];

if (fileExists "onMissionStart.sqf") then { execVM "onMissionStart.sqf" };

// Display intro text if enabled.
if (sia_f_showIntroText) then {
	sleep 3;
	private _zeus = _this select 0;
	[sia_f_missionName] remoteExec ["BIS_fnc_moduleMissionName", _zeus];
	sleep 10;
	["sia_f\introText.sqf"] remoteExec ["execVM"];
};
