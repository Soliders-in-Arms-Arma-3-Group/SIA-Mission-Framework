/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds "ORBAT" tab to briefing that displays a list of players by their squad and roles.

	USAGE:
		Run locally for all player clients. 
		Works best when updated automatically or called globally when player joins.

	PARAMS: None
*/

if (!hasInterface) exitWith {}; // Exit if not a player.


if (!isNil "orbat") then {player removeDiaryRecord ["Diary", orbat]}; // If diary entry already exists, then erase it.

private _side = side player;
private _allGroupsWithPlayers = [];
{if (side _x == _side) then {_allGroupsWithPlayers pushBackUnique group _x}} forEach (call BIS_fnc_listPlayers); // Create array with all player groups matching the player's side
//{if (side _x == _side) then {_allGroupsWithPlayers pushBackUnique _x}} forEach allGroups; // DEBUGGGGG FOR SINGLEPLAYER
_allGroupsWithPlayers = [_allGroupsWithPlayers, [], {groupId _x}, "ASCEND"] call BIS_fnc_sortBy; // Sort array by group callsigns in alphabetical order

// Init variables
_str = ""; 
private _teamColor = '';
private _rolecolor = '';

{
	_sideColor = ([(side  _x), false] call BIS_fnc_sideColor); // Get RGBA color value of group's side.
	_sideColor = (_sideColor apply {_x * 2}) call BIS_fnc_colorRGBAtoHTML; // Brigthen the color and convert it to HEX/HTML.
	_str = _str + format ["<font face='PuristaMedium' size='16' color='%2'>%1</font>", groupId _x,_sideColor] + "<br />"; // Format group callsign with side color.

	{
		_role = roleDescription _x; 
		if (_role == "") then {_role = (getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"))} else {_role = (_role splitString "@") select 0}; // If roleDescription is set, then truncate. Else use config name.
		if (_x == player) then {_roleColor = '#B21A00'} else {_roleColor = '#ffffff'}; // Set color of player's name to tan.

		// Get unit's team and associated color 
		if (group _x == group player) then {	
			_teamColor = switch (assignedTeam _x) do {
				case "MAIN": {"#FFFFFF"};
				case "RED": {"#FEAAAA"};
				case "GREEN": {"#AAFEAA"};
				case "BLUE": {"#AAAAFE"};
				case "YELLOW": {"#FEFEAA"}; 
				default {"#FFFFFF"};
			};
		} else {
			_teamColor = '#FFB84C'; // If unit not in player's group, then set color to Koromiko
		};

		_rankIcon = format ["<img color='%1' image='\A3\Ui_F\Data\GUI\Cfg\Ranks\"+ (rank _x) + "_gs.paa' width='15' height='15'/>", _teamColor]; // Get icon of units' rank from config.
		_roleIcon = format ["<img color='%1' image='\A3\Ui_F\Data\Map\VehicleIcons\"+ (getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "icon")) + "_ca.paa' width='15' height='15'/>", _teamColor]; // Get icon of units' role from config.
		_str = _str + "  " + _roleIcon + "  " + format ["<font color='%2' face='%3'>%1: </font>", _role, _roleColor,'PuristaBold'] + format ["<font  color='%2' face='%3'>%1</font>", (name _x), _teamColor, 'PuristaLight'] + "  " + _rankIcon + "  " + "<br />"; // Combine images, role, and name into one string.
	} forEach ([leader _x] + (units _x - [leader _x])); // Do for all units in group, starting with the group lead.
	_str = _str + "<br />" // Add extra line break after each group.
} forEach _allGroupsWithPlayers;

orbat = player createDiaryRecord ["Diary", ["ORBAT","<execute expression='execVM ""sia_f\orbat.sqf"";'>Refresh</execute>" + "<br></br><br></br>" + _str]]; // Add ORBAT text to diary along with "Refresh" button.