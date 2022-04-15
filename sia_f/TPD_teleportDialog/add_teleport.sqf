_button = _this select 0;
_action = ["TpSL", "Open Teleport Menu", "\a3\modules_f_curator\data\portraitobjectivemove_ca.paa", { execVM "sia_f\TPD_teleportDialog\call_teleport.sqf" }, { true }] call ace_interact_menu_fnc_createAction;
[_button, 0, ["ACE_MainActions"], _action, true] call ace_interact_menu_fnc_addActionToObject;
