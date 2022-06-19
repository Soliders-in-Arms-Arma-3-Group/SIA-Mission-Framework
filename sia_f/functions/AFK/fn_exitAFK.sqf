/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Sets a player to exit the "AFK" status by unsetting their character as captive and invisible.
		Optional ability to run tp script.

	USAGE: Private

	PARAMS: None
*/

if (!hasInterface) exitWith {}; // Exit if not player.

private _unit = player;
private _serializedMedStatus = _unit getVariable ["serializedMedStatus", "{}"];

_unit setCaptive false;
[_unit, false] remoteExec ["hideObjectGlobal", 2];
[_unit, true] remoteExec ["enableSimulationGlobal", 2];
[_unit, _serializedMedStatus] call ace_medical_fnc_deserializeState;

[(name _unit + " is no longer AFK.")] remoteExec ["systemChat"]; // "<player> is AFK" system chat message.
[] spawn { sleep 60; player setVariable ["sia_isAFK", false]; }; // Time out for 60 seconds.

5 cutText ["", "PLAIN", -1, true];
