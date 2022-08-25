/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Generates support tab information regarding available assets and their ammo.
		! Unused
	USAGE:
		Run locally.

	PARAMS:
		0: Array of vehicles (OBJECTS) for support.
*/

params [
	["_assets", [], [[]]],
	["_support", "", [""]]
];
private _assets = (getMissionLayerEntities "Assets") select 0;

if (_assets isEqualTo []) exitWith { ["addSupportInfo Error: Invalid Parameters: %1", _this select 0] call BIS_fnc_error }; // Exit if array not given. 
 
private _str = [];

{
	private _vicName = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
	private _seatsCargo = count fullCrew [_x, "cargo", true];
	private _seatsCrew = (count fullCrew [_x, "", true]) - _seatsCargo;
	private _weaponsInfo = getAllPylonsInfo _x;

	 // If vehicle has pylons then combine like pylons, else show turret info if any.
	if (count _weaponsInfo > 0) then {
		private _newArr = [];
		{
			// Get weapon name and ammo count for each pylon.
			private _weapon = getText (configFile >> "CfgMagazines" >> (_x select 3) >> "displayName");
			private _ammo = _x select 4;

			// Check if existing similar pylon already exists and combine, otherwise add pylon info to array.
			private _index = _newArr findIf {_x select 0 == _weapon};
			if (_index > -1) then { 
				private _pylonInfo = _newArr select _index;
				_pylonInfo set [1, ((_pylonInfo select 1) + _ammo)];
			} else {
				_newArr pushBack [_weapon, _ammo];
			};
		} forEach _weaponsInfo;

		_weaponsInfo = _newArr;

	} else {
		_weaponsInfo = (_x weaponsTurret [0]) + (_x weaponsTurret [0,0]);

		// Create new array of display names of turrets.
		if (count _weaponsInfo > 0) then {
			private _newArr = [];
			{ _newArr pushBackUnique (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) } forEach _weaponsInfo; 
			_weaponsInfo = _newArr; 
		};
		// To Do: Add magazine info.
	};
	_str pushBack [_vicName, _seatsCrew, _seatsCargo, _weaponsInfo];
} forEach _assets;

_assets = _str;

// Condense array by removing and numbering duplicates
private _uniqueArr = []; 
private _finalArr = []; 

{ 
 _uniqueArr pushBackUnique _x; 
} forEach _assets; // create array of unique elements 
 
{ 
 private _y = _x; // _x from count would overwrite _x from forEach 
 _finalArr pushBack [_y, {_x isEqualTo _y} count _assets]
} forEach _uniqueArr; // populate array with amount of items 

_assets = _finalArr;

private _text = [];

// Formatting text
{
	private _str = "";
	private _amount = _x select 1;
	(_x select 0) params ["_name", "_seatsCrew", "_seatsCargo", "_weaponsInfo"];

	// Amount + Name + Seats
	if (_amount > 1) then {_str = _str + format ["<font face='PuristaLight'>x%1</font> ", _amount]}; // Add amount of vics if more than one is avaliable.
	_str = _str + format ["<font face='PuristaBold'>%1</font> ", _name];
	if (_seatsCargo > 0 || _seatsCrew > 0) then { _str = _str + format ["<font face='PuristaMedium' color='#808080'>(%1+%2)</font>", _seatsCrew, _seatsCargo] }; // Add seat info if any cargo seats are avaliable.

	// Weapons
	if (count _weaponsInfo > 0) then {
		private _newArr = [];

			if ((_weaponsInfo select 0) isEqualType "") then { 
				// Turrets
				_newArr pushBack "<br></br>";
				{
					if (count _newArr > 1) then {_newArr pushBack ", "};
					_newArr pushBack format ["<font face='PuristaMedium' color='#FFB84C'>%1</font>", _x];
				} forEach _weaponsInfo;
			} else { 
				// Pylons
				{
					_x params ["_weapon","_ammo"];
					_newArr pushBack format ["<br></br><font face='PuristaMedium' color='#FFB84C'>%1</font><font face='PuristaLight'>: x%2 rounds</font>",_weapon,_ammo]
				} forEach _weaponsInfo;
			};


		_str = _str + (_newArr joinString "");
	};

	_str = _str + "<br></br><br></br>";
	_text pushBack _str;

} forEach _assets;

_text joinString "";
_text = _text joinString "";

//[[["Test6", _text]]] execVM "sia_f\briefing\createBriefing.sqf";

//private _icon = "z\" + getText (configFile >> "CfgVehicles" >> typeOf _x >> "picture");
//_str = _str + format ["<img image=%1/>",_icon];
