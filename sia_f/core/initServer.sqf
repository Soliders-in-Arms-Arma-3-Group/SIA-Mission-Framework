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
	if (sia_f_acreEnabled) then {
		publicVariable "sia_f_personalRadio";
		publicVariable "sia_f_handheldRadio";
		publicVariable "sia_f_manpackRadio";
	};
	publicVariable "sia_f_missionName";
	publicVariable "sia_f_missionLocationName";
	publicVariable "sia_f_bluforFactionName";
	publicVariable "sia_f_indepFactioName";
	publicVariable "sia_f_opforFactionName";
	publicVariable "sia_f_arsenalEnabled";
	publicVariable "sia_f_haveCTab";
	publicVariable "sia_f_haveKATMedical";
	publicVariable "sia_f_enableTPToSquad";
	publicVariable "sia_f_enableManageKit";
	publicVariable "sia_f_enableLoadoutInfo";
	publicVariable "sia_f_enableGoAFK";
	publicVariable "sia_f_briefORBAT";
	publicVariable "sia_f_briefWeather";
	publicVariable "sia_f_briefLoadout";
	publicVariable "sia_f_ACEButtons";
	publicVariable "sia_f_acreEnabled";
	publicVariable "sia_f_showStatusHint";
	// ToDo: make server-side functions that take over the client's using of these variables
		// either process whatever the client would process with these or have the server send the variable
		// see https://community.bistudio.com/wiki/Code_Optimisation#Multiplayer_recommendations


 // Setup Global Arsenal
if (sia_f_arsenalEnabled && (!isNil "sia_f_arsenals")) then {
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
if (sia_f_bluforTickets != 0) then { [west, sia_f_bluforTickets] call BIS_fnc_respawnTickets };
if (sia_f_indepTickets != 0) then { [independent, sia_f_indepTickets] call BIS_fnc_respawnTickets };
if (sia_f_opforTickets != 0) then { [east, sia_f_opforTickets] call BIS_fnc_respawnTickets };
if (sia_f_civTickets != 0) then { [civilian, sia_f_civTickets] call BIS_fnc_respawnTickets };

if (!isNil "sia_f_ACEButtons") then {
	// Revo's TP Menu Function
	if (sia_f_enableTPMenu) then {
		["enableGlobalMessage", false] call TPD_fnc_teleport; // Disable global message
		{ ["addActions", [_x]] call TPD_fnc_teleport; } forEach sia_f_ACEButtons; // Add 'Teleport Menu' to objects
	};

	{ _x setObjectTextureGlobal [0, "sia_f\images\ace_button_img.jpg"] } forEach sia_f_ACEButtons;
};

sia_f_setupComplete = true;
publicVariable "sia_f_setupComplete";
