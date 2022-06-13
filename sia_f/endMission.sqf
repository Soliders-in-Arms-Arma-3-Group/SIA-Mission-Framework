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

params [
	["_isVictory", true]
];

execVM "sia_f\missionEnd\exportScoreboard.sqf";

if !(isNil "ocap_fnc_exportData") then {
	private _realDate = "real_date" callExtension "EST+"; // EST+ might not be a valid option
	private _outcome = if (_isVictory) then { "Mission Completed" } else { "Mission Failed" };
	if (_realDate != "") then {
		private _opType = "MISC";
		private _weekday = (parseSimpleArray _realDate) # 6;
		switch (_weekday) do {
			case 0: { _opType = "MAIN OP"; }; // sunday
			case 5: { _opType = "SIDE OP"; }; // friday
		};

		["Mission End", _outcome, _opType] call ocap_fnc_exportData;
	} else {
		["Mission End", _outcome, "unk"] call ocap_fnc_exportData;
		diag_log "endMission.sqf Error: real_date extension not found.";
	};
} else {
	diag_log "endMission.sqf Error: ocap_fnc_exportData function not found.";
};

["end1", _isVictory, true] remoteExecCall ["BIS_fnc_endMission", 0];
