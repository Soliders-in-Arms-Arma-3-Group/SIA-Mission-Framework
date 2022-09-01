/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Generates information regarding available vehicles and their seats, weapons, and ammo.
		! Unused
	USAGE:
		Run locally.

	PARAMS:
		0: Array of vehicles (OBJECTS).
*/

params [
	["_vehicles", [], [[]]]
];
if (_vehicles isEqualTo []) exitWith { ["addSupportInfo Error: Invalid Parameters: %1", _this select 0] call BIS_fnc_error }; // Exit if array not given.

private _newDiarySubject = "vehicleInfo";
private _cfgVehicles = configFile >> "CfgVehicles"; // cache cfgVehicles
 
private _newArr = [];
{
	private _vicName = getText (_cfgVehicles >> typeOf _x >> "displayName");
	private _weaponsInfo = [getAllPylonsInfo _x];
	private _className = typeOf _x;

	 // If vehicle has pylons then combine like pylons, else show turret info if any.
	if (count (_weaponsInfo select 0) > 0) then {
		private _pylons = [];
		{
			// Get weapon name and ammo count for each pylon.
			private _weapon = getText (configFile >> "CfgMagazines" >> (_x select 3) >> "displayName");
			private _ammo = _x select 4;

			// Check if existing similar pylon already exists and combine, otherwise add pylon info to array.
			private _index = _pylons findIf {_x select 0 == _weapon};
			if (_index > -1) then { 
				private _pylonInfo = _pylons select _index;
				_pylonInfo set [1, ((_pylonInfo select 1) + _ammo)];
			} else {
				_pylons pushBack [_weapon, _ammo];
			};
		} forEach (_weaponsInfo select 0);

		_weaponsInfo = [_pylons];

	}; 
		private _turrets = (_x weaponsTurret [0]) + (_x weaponsTurret [0,0]);

		// Create new array of display names of turrets.
		if (count _turrets > 0) then {
			private _newArr = [];
			{ _newArr pushBackUnique (getText (configFile >> "CfgWeapons" >> _x >> "displayName")) } forEach _turrets; 
			_turrets = _newArr; 
		};

		_weaponsInfo pushBack _turrets;
		// To Do: Add magazine info.

	_newArr pushBack [_className, _weaponsInfo];
} forEach _vehicles;
_vehicles = _newArr;

// Condense array by removing and numbering duplicates
private _uniqueArr = []; 
private _newArr = []; 
{ _uniqueArr pushBackUnique _x } forEach _vehicles; // create array of unique elements 
{ 
	private _y = _x; // _x from count would overwrite _x from forEach 
 	_newArr pushBack [_y, {_x isEqualTo _y} count _vehicles]
} forEach _uniqueArr; // populate array with amount of items 
_vehicles = _newArr;

// Get editor category of each vehicle.
{
	private _category = getText (configFile >> "CfgEditorSubcategories" >> getText (_cfgVehicles >> ((_x select 0) select 0) >> "editorSubcategory") >> "displayName"); // Get name of the vehicle's eden category;
	_x pushBack _category;
} forEach _vehicles;

// Seperate vehicles into category then sort.
private _newArr = [];
{

	private _category = _x select 2;
	private _index = _newArr findIf {_x select 0 == _category};
	_x deleteAt 2;
	if (_index > -1) then {
		((_newArr select _index) select 1) pushBack _x;	
	} else {
		_newArr pushBack [_category,[_x]];
	}
} forEach _vehicles;

_vehicles = [_newArr] call BIS_fnc_sortBy; // Sort categories alphabetically.


// Expanding info										

private _fnc_vehicleInfoTab = {

	params ["_className", "_weaponsInfo", "_newDiarySubject"];
	private _cfgVehicles = configFile >> "CfgVehicles"; // cache cfgVehicles

	private _displayName = getText (_cfgVehicles >> _className >> "displayName");
	private _category = getText (configFile >> "CfgEditorSubcategories" >> getText (_cfgVehicles >> _className >> "editorSubcategory") >> "displayName");
	private _seatsTotal = [_className, true] call BIS_fnc_crewCount; // Number of total seats: crew + non-FFV cargo/passengers + FFV cargo/passengers
	private _seatsCrew = [_className, false] call BIS_fnc_crewCount; // Number of crew seats only
	private _seatsCargo = _seatsTotal - _seatsCrew; // Number of total cargo/passenger seats: non-FFV + FFV
	private _seatsNonFFVcargo = getNumber (_cfgVehicles >> _className >> "transportSoldier"); // Number of non-FFV cargo seats only
	private _seatsFFVcargo = _seatsCargo - _seatsNonFFVcargo; // Number of FFV cargo seats only

	// Icon img
	private _icon = getText (_cfgVehicles >> _className >> "picture");

	// === Text Formatting ===
	private _strArr = [];
	private _colorSeatsCrew = if (_seatsCrew > 0) then [{ ['#FFB84C', '#FFFFFF'] }, { ['#A9A9A9', '#A9A9A9'] }];
	private _colorSeatsCargo = if (_seatsCargo > 0) then [{ ['#FFB84C', '#FFFFFF'] }, { ['#A9A9A9', '#A9A9A9'] }];

	_strArr pushBack format ["<img image='%1' width='90' height='45'/>",_icon];
	_strArr pushBack "<br></br>";
	_strArr pushBack format ["<font face='PuristaBold'>%1</font>", _displayName];
	_strArr pushBack "<br></br><br></br>";
	_strArr pushBack format ["<font face='PuristaMedium'>Seats<br></br><font face='PuristaLight' color='%3'>Crew: <font color='%4'>%1</font><br></br><font color='%5'>Cargo: <font color='%6'>%2</font></font></font>", _seatsCrew, _seatsCargo, _colorSeatsCrew select 0, _colorSeatsCrew select 1, _colorSeatsCargo select 0, _colorSeatsCargo select 1];

	// Weapons Info

	_weaponsInfo params ["_pylons","_turrets"];
	private _newArr = [];

	// Turrets
	if (count _turrets > 0) then {
		_newArr pushBack "<br></br><br></br><font face='PuristaMedium'>Armaments</font><br></br>";
		{
			if (_forEachIndex > 0) then {_newArr pushBack "<font face='PuristaLight' color='#A9A9A9'>, </font>"};
			_newArr pushBack format ["<font face='PuristaLight' color='#A9A9A9'>%1</font>", _x];
		} forEach _turrets;
	};

	// Pylons
	if (count _pylons > 0) then {
		_newArr pushBack "<br></br><br></br><font face='PuristaMedium'>Munitions</font>";
		{
			_x params ["_weapon","_ammo"];
			_newArr pushBack format ["<br></br><font face='PuristaLight' color='#FFB84C'>%1: </font><font face='PuristaLight'>%2x</font>",_weapon,_ammo]
		} forEach _pylons;
	};
	
	_strArr pushBack (_newArr joinString "");
	_strArr pushBack "<br></br><br></br><execute expression ='player selectDiarySubject ""Diary:Record4""'>Go back</execute>";

	private _text = _strArr joinString "";
	if (!(player diarySubjectExists _newDiarySubject)) then { player createDiarySubject [_newDiarySubject,"Vehicle Information"] };
	private _retValue = player createDiaryRecord ["vehicleInfo", [_displayName, _text, _icon]];
	_retValue;
};

private _text = [""];

// Formatting text
{
	private _category = _x select 0;
	private _str = "";
	//private _diaryLink = player createDiaryLink ["Diary", record, text]

	// Category Header
	_str = _str + format ["<font face='PuristaSemiBold'>%1</font>", _category];
	_str = _str + "<br></br>";

	{	

		(_x select 0) params ["_className", "_weaponsInfo"];
		private _amount = _x select 1;
		private _displayName = getText (_cfgVehicles >> _className >> "displayName");

		// Icon img
		/*
		private _icon = getText (_cfgVehicles >> _className >> "picture");
		_str = _str + format ["<img image='%1' width='20' height='10'/>  ",_icon];
		*/

		// Number of vics
		if (_amount > 0) then {_str = _str + format ["<font face='PuristaLight'>%1x </font>", _amount]}; // Add amount of vics if more than one is avaliable.

		// Name
		private _newDiaryRecord = [_className, _weaponsInfo, _newDiarySubject] call _fnc_vehicleInfoTab;
		_str = _str + "<font face='PuristaMedium'>" + createDiaryLink [_newDiarySubject, _newDiaryRecord, _displayName] + "</font>";		
		
		_str = _str + "<br></br>";
	} forEach (_x select 1);
	_text pushBack (_str + "<br></br>");
} forEach _vehicles;

_text joinString "";
_text = _text joinString "";

_text;