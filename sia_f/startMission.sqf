/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Code that executes when mission has started. 

	USAGE:
		Should only be ran on the server.

	PARAMS:
		None
*/

if (!isServer) exitWith {}; // Exit if not server.

if (isMultiplayer) then {setDate startTime}; // Set time to start of mission.
setTimeMultiplier 1; // Set time acceleration to default.

// Update variable.
sia_f_missionStarted = true; 
publicVariable "sia_f_missionStarted";

if (sia_f_briefLoadout) then { ["sia_f\briefing\f_loadoutNotes.sqf"] remoteExec ["execVM"] }; // Refresh loadout information

sleep 1;

sia_f_setupPhase = "In Progress";
["setupPhase",["Mission is a go!","\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
[""] remoteExec ["hintSilent"];

sleep 10;

if (sia_f_showIntroText) then { ["sia_f\introText.sqf"] remoteExec ["execVM"] };