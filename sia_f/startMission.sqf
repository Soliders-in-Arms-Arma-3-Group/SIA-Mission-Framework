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
setTimeMultiplier 1; // Set time acceleration to default;

["sia_f\briefing\f_loadoutNotes"] remoteExec ["execVM"];

sleep 1;

["setupPhase",["Mission is a go!","\A3\ui_f\data\IGUI\Cfg\simpleTasks\types\run_ca.paa"]] remoteExec ["BIS_fnc_showNotification"];
[""] remoteExec ["hintSilent"];

sleep 9;

["sia_f\introText.sqf"] remoteExec ["execVM"];