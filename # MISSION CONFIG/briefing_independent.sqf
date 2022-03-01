/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds briefing for independent players to the mission.
		For more information on briefing formatting, see https://community.bistudio.com/wiki/Arma_3:_Briefing
		For an example of a briefing, see https://docs.google.com/document/d/1o6i-wvIkhs4APs_QetKSZI35yEy8_7CHz8u_ZGcM_3g/edit?usp=sharing

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

[[["Signal", _signal], ["Support", _support], ["Execution", _execution], ["Mission", _mission], ["Situation", _situation]]] execVM "sia_f\briefing\createBriefing.sqf";