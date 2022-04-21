#include "..\..\# MISSION CONFIG\Settings\aceActions.hpp"
#include "..\..\# MISSION CONFIG\Settings\arsenal.hpp"
#include "..\..\# MISSION CONFIG\Settings\missionInfo.hpp"
#include "..\..\# MISSION CONFIG\Settings\tickets.hpp"

sia_f_setupComplete = false;
publicVariable "sia_f_setupComplete";

startTime = date;
setTimeMultiplier 0.1;

sia_f_setupPhase = "Waiting";
publicVariable "sia_f_setupPhase";

sia_f_missionStarted = false;
publicVariable "sia_f_missionStarted";

private _script_handler = execVM "# MISSION CONFIG\settings.sqf"; // LOAD SETTINGS
waitUntil { scriptDone _script_handler };

if (sia_f_missionName == "" || isNil "sia_f_missionName") then { sia_f_missionName = missionName }; // Get mission name.

if (sia_f_missionLocationName == "") then {
	private _arr = (toArray worldName);
	_str = toUpper (toString [(_arr select 0)]);
	_arr set [0, ((toArray _str) select 0)];
	sia_f_missionLocationName = (toString _arr)
	};  // Get location name. Set first letter to uppercase if pulled from game files.

// Publicize Variables
publicVariable "sia_f_missionName";
publicVariable "sia_f_missionLocationName";
publicVariable "sia_f_ACEButtons";
{ player setVariable ["sia_showStatusHint", SIA_SHOW_STATUS_HINT]; } remoteExec ["call", [0, -2] select isDedicated];
// ToDo: make server-side functions that take over the client's using of these variables
	// either process whatever the client would process with these or have the server send the variable
	// see https://community.bistudio.com/wiki/Code_Optimisation#Multiplayer_recommendations


 // Setup Global Arsenal
if (SIA_ARSENAL_ENABLED && (!isNil "sia_f_arsenals")) then {
	publicVariable "sia_f_arsenals";
	[sia_f_arsenals] execVM "sia_f\ace arsenal\setupGlobalArsenal.sqf";

	{
		clearBackpackCargoGlobal _x;
		clearMagazineCargoGlobal _x;
		clearWeaponCargoGlobal _x;
		clearItemCargoGlobal _x;
		[_x, false] remoteExecCall ["ace_dragging_fnc_setDraggable"];
		[_x, false] remoteExecCall ["ace_dragging_fnc_setCarryable"];
	} forEach sia_f_arsenals;
};

// Setup Respawns
if (!isNil "respawn_pos_blufor") then { "respawn_west" setMarkerPos respawn_pos_blufor  };
if (!isNil "respawn_pos_opfor") then { "respawn_east"  setMarkerPos respawn_pos_opfor };
if (!isNil "respawn_pos_indep") then { "respawn_guerilla" setMarkerPos respawn_pos_indep };
if (!isNil "respawn_pos_civilian") then {"respawn_civilian" setMarkerPos respawn_pos_civilian };

// Setup Respawn tickets
if (SIA_BLUFOR_TICKETS != 0) then { [west, SIA_BLUFOR_TICKETS] call BIS_fnc_respawnTickets };
if (SIA_INDEP_TICKETS != 0) then { [independent, SIA_INDEP_TICKETS] call BIS_fnc_respawnTickets };
if (SIA_OPFOR_TICKETS != 0) then { [east, SIA_OPFOR_TICKETS] call BIS_fnc_respawnTickets };
if (SIA_CIV_TICKETS != 0) then { [civilian, SIA_CIV_TICKETS] call BIS_fnc_respawnTickets };

if (!isNil "sia_f_ACEButtons") then {
	// Revo's TP Menu Function
	if (SIA_ENABLE_TP_MENU) then {
		["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message
		{ ["addActions", [_x]] call TPD_fnc_teleport; } forEach sia_f_ACEButtons; // Add 'Teleport Menu' to objects
	};

	{ _x setObjectTextureGlobal [0, "sia_f\images\ace_button_img.jpg"] } forEach sia_f_ACEButtons;
};

sia_f_setupComplete = true;
publicVariable "sia_f_setupComplete";
