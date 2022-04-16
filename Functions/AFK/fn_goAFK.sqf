/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Sets a player to "AFK" status by setting their character as captive and invisible.
		Gives player action to exit "AFK" status and with option to teleport to squad.

	USAGE:
		Add action locally to call script.
		Example: (in initPlayerLocal.sqf) player addAction ["Go AFK", {[] spawn sia_f_fnc_goAFK}];

	PARAMS: None
*/

if (!hasInterface) exitWith {}; // Exit if not player.

if (
	captive player ||
	!alive player ||
	!simulationEnabled player ||
	!isAbleToBreathe player ||
	(!isTouchingGround player) && (vehicle player == player)
	|| (currentPilot vehicle player == player) && (isEngineOn vehicle player)
) exitWIth { 5 cutText ["Going AFK is not allowed at this time.","PLAIN", -1, true] };

private _timeout = 15; // Time in seconds to temporarily suspend script after use.

private _unit = player;
player setCaptive true; // Set player to captive.
[_unit, true] remoteExec ["hideObjectGlobal", 2]; // Hide player object.
[_unit, false] remoteExec ["enableSimulationGlobal", 2]; // Disables player movement.
player setVariable ["sia_isAFK", true]; // Updates player variable.
[(name player + " is now AFK.")] remoteExec ["systemChat"]; // "<player> is AFK" system chat message.

5 cutText ["You are now AFK\nYou may exit in " + (str _timeout) + " seconds.\nWARNING: ACE Medical is still simulated.", "PLAIN", -1, true];

sleep _timeout; // Pause until exit dialog is opened.

if (!alive player) exitWith {}; // Exit if player is dead.

createDialog "dialogAFK"; // Open Exit Dialog
_display = findDisplay 3289;

// Exit AFK if player closes dialog with escape key.
_display displayAddEventHandler ["KeyDown", {
	params ["_display","_key"];
	if (_key == 1) exitWith { [false] spawn sia_f_fnc_exitAFK }; // ESC pressed while dialog is open, overwrite default behavior
	false
}];
