/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Code that executes when mission has ended.

	USAGE:
		Should only be ran on the server.

	PARAMS:
		None
*/

if (!isServer) exitWith {}; // Exit if not server.

execVM "sia_f\missionEnd\exportScoreboard.sqf";

["end1", true, true] remoteExecCall ["BIS_fnc_endMission", 0];
