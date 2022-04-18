/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Generates briefing diary record with the given record names and entries.

	USAGE:
		Run locally.

	PARAMS:
		0: ARRAY (Example: [["Situation", "The sky is cloudy."]]).
*/

private _briefing = _this select 0;

if (sia_f_briefWeather) then {
	_script_handler = execVM "sia_f\briefing\f_conditionNotes.sqf";
	waitUntil { scriptDone _script_handler };
};

if (sia_f_briefLoadout) then {
	call sia_f_fnc_loadoutNotes;
};

{ player createDiaryRecord ["Diary", [(_x select 0), (_x select 1)], taskNull, "", true] } forEach _briefing;

if (sia_f_briefORBAT) then { remoteExec ["sia_f_fnc_orbat"] };
