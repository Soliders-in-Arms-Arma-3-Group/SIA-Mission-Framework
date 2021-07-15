/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Sets a player to "AFK" status by setting their character as captive, invisible, and in ACE spectator. 
		Gives player action to exit "AFK" status and with option to teleport to squad.

	USAGE:
		Add action locally to call script.
		Example: (in initPlayerLocal.sqf) player addAction ["Go AFK", {"execVM "sia_f\goAFK.sqf"}];

	PARAMS: None
*/

if (!hasInterface) exitWith {}; // Exit if not player.

if ( captive player || !alive player || !simulationEnabled player || !isAbleToBreathe player || ((!isTouchingGround player) && (vehicle player == player )) || ((currentPilot vehicle player == player) && isEngineOn vehicle player) )  exitWIth {5 cutText ["Going AFK is not allowed at this time.","PLAIN",-1,true]};

private _timeout = 30; // Time in seconds to temporarily suspend script after use.

player hideObjectGlobal true; // Hide player object.
player setCaptive true; // Set player to captive.
if (vehicle player != player) then {moveOut player}; // If player is in a vehicle, eject player from the vehicle.
player enableSimulationGlobal false; // Disables player movement.
player setVariable["sia_isAFK",true]; // Updates player variable.
[(name player + " is now AFK.")] remoteExec ["systemChat"]; // "<player> is AFK" system chat message.

5 cutText ["You are now AFK\nYou may exit in " + (str _timeout) + " seconds.\nWARNING: ACE Medical is still simulated.","PLAIN",-1,true];

sleep _timeout; // Wait before option to exit AFK is given.

// Exit AFK function
fnc_sia_exitAFK = {	

	player hideObjectGlobal false;
	player setCaptive false;
	player enableSimulationGlobal true;
	5 cutText ["","PLAIN",-1,true];
	[(name player + " is no longer AFK.")] remoteExec ["systemChat"]; // "<player> is AFK" system chat message.
	[] spawn { sleep 60; player setVariable["sia_isAFK",false]; } // Time out for 60 seconds.
};

// Add action to return to game.
afk_exitID = player addAction ["Exit AFK", { 
		_this call fnc_sia_exitAFK; 
		_this select 0 removeAction (_this select 2); 
		_this select 0 removeAction afk_exitID_TP; 
	}, nil, 1, true, true];

// Add action to return to game with option to teleport.
afk_exitID_TP = player addAction ["Exit AFK and Teleport to Squad", {
		_this call fnc_sia_exitAFK; 
		[player] execVM "sia_f\teleportToSquad.sqf"; 
		_this select 0 removeAction (_this select 2); 
		_this select 0 removeAction afk_exitID;
	 }, nil, 2, true, true];

while {(player getVariable "sia_isAFK") && !(simulationEnabled player)} do { 5 cutText ["You are AFK\nUse action menu to exit","PLAIN",-1,true];  sleep 30; }; // Display info text while player is AFK