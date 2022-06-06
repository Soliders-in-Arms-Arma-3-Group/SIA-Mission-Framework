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

private _opType = "ZGM";
private _weekday = ("real_date" callExtension "EST+") select 6;
switch (_weekday) do {
	case 0: { _opType = "Main"; }; // sunday
	case 5: { _opType = "Side"; }; // friday
};

if !(isNil "ocap_fnc_exportData") then {
	["Mission End", "Mission ended with Siege at the top of the leaderboard", _opType] call ocap_fnc_exportData;
};

["end1", true, true] remoteExecCall ["BIS_fnc_endMission", 0];
