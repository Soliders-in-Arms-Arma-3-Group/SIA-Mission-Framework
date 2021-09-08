/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds briefing for blufor players to the mission.
		For more information on briefing formatting, see https://community.bistudio.com/wiki/Arma_3:_Briefing
		For an example of a briefung, see https://docs.google.com/document/d/11zSTSHv8v64CqT0mSXw441630pR9oYmi0KlSHdoXYW0/edit#heading=h.8vcpjemrohvy

	USAGE:
		Run locally.

	PARAMS: None
*/
//=======================================================================================
// Put briefing in the quotations below. 

_situation = "";

_mission = "";

_execution = "";

_support = "";

_signal = "";

// =======================================================================================
// DO NOT DELETE OR EDIT vvv

if (sia_f_briefLoadout) then {
	_script_handler = execVM "sia_f\briefing\f_conditionNotes.sqf";
	waitUntil { scriptDone _script_handler };
};

if (sia_f_briefWeather) then {
	_script_handler = execVM "sia_f\briefing\f_loadoutNotes.sqf";
	waitUntil { scriptDone _script_handler };
};

player createDiaryRecord ["Diary",["Signal",_signal],taskNull,"",true];
player createDiaryRecord ["Diary",["Support",_support],taskNull,"",true];
player createDiaryRecord ["Diary",["Execution",_execution],taskNull,"",true];
player createDiaryRecord ["Diary",["Mission",_mission],taskNull,"",true];
player createDiaryRecord ["Diary",["Situation",_situation],taskNull,"",true];

if (sia_f_briefORBAT) then {["sia_f\orbat.sqf"] remoteExec ["execVM"]};
