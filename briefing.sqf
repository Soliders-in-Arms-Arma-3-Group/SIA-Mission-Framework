/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds briefing to mission.

	USAGE:
		Run locally.

	PARAMS: None
*/

_situation = "";
_mission = "";
_execution = "";
_signal = "";

private _script_handler =execVM "sia_f\f_conditionNotes.sqf";
waitUntil { scriptDone _script_handler };
player createDiaryRecord ["Diary",["Signal",_signal],taskNull,"",true];
 //_script_handler = [_support, [ merlin1, ah1]] execVM "sia_f\addSupportInfo.sqf";
waitUntil { scriptDone _script_handler };
player createDiaryRecord ["Diary",["Execution",_execution],taskNull,"",true];
player createDiaryRecord ["Diary",["Mission",_mission],taskNull,"",true];
player createDiaryRecord ["Diary",["Situation",_situation],taskNull,"",true];