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
#include "..\# MISSION CONFIG\Settings\missionInfo.hpp"

if (!isServer) exitWith {}; // Exit if not server.

execVM "sia_f\missionEnd\exportScoreboard.sqf";

if (SIA_SHOW_REPLAY) then {
	["Starting replay..."] remoteExec ["hint"];

	[player] remoteExec ["ace_medical_treatment_fnc_fullHealLocal"]; // Fully heal all players
	[player, false] remoteExec ["allowDamage"]; // Disable damage for all players
	if (!isNil "respawn_pos_blufor") then {
		_pos = (getPosASL respawn_pos_blufor);
		[player] remoteExec ["moveOut"];
		{ _x setPosASL _pos } forEach allPlayers;
	}; // Moves all players to blufor spawn (NEEDS IMPROVEMENT)
	[0] remoteExec ["setPlayerRespawnTime"]; // Respawn all players.
	[player, 1] remoteExec ["BIS_fnc_respawnTickets", -2];

	sleep 1;

	// stops record, and starts replay
	call GRAD_replay_fnc_stopRecord;

	// ends mission after replay is over
	[{
		REPLAY_FINISHED
	}, {
		["end1", true, true] remoteExecCall ["BIS_fnc_endMission", 0];
	}, []] call CBA_fnc_waitUntilAndExecute;
} else {
	["end1", true, true] remoteExecCall ["BIS_fnc_endMission", 0];
};
