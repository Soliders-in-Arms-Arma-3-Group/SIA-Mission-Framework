/*

	SIA Mission Framework
	Author: McKendrick

=====================================================================

	Description:
	When a character is entered it is validated and changes the
	correct slider it is associated with. I probably over-complicated
	this more then I had to but onChar behaves weird.

	PARAMS:
		0: Array of objects
*/

waitUntil {!isNull player};

_tphq = ["TpSL", "Teleport to Squad", "", {[_this select 1]execVM "scripts\tp.sqf"}, {true}] call ace_interact_menu_fnc_createAction; 
[hq_button, 0, ["ACE_MainActions"], _tphq, true] call ace_interact_menu_fnc_addActionToObject;

// Manage Loadouts
_action = ["Loadout", "Manage Loadout", "images\gear_ca.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[hq_button, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;

_action = ["SaveKit", "Save Loadout", "images\reammo_ca.paa", {player setVariable["Saved_Loadout",getUnitLoadout player]; hint "Loadout saved. Will be loaded on respawn."}, {true}] call ace_interact_menu_fnc_createAction; 
[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;

_action = ["LoadKit", "Load Loadout", "z\ace\addons\disarming\UI\disarm.paa", {player setUnitLoadout(player getVariable["Saved_Loadout",[]]); hint "Loadout loaded."}, {true}] call ace_interact_menu_fnc_createAction; 
[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;

_action = ["ClearKit", "Remove Saved Loadout", "z\ace\addons\arsenal\data\iconClearContainer.paa", {player setVariable["Saved_Loadout",nil]; hint "Loadout cleared. Will save loadout on death."}, {true}] call ace_interact_menu_fnc_createAction; 
[hq_button, 0, ["ACE_MainActions", "Loadout"], _action, true] call ace_interact_menu_fnc_addActionToObject;
