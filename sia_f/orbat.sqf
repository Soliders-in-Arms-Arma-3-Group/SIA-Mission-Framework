if (!isNil "orbat") then {player removeDiaryRecord ["Diary", orbat]};

private _allGroupsWithPlayers = [];
{_allGroupsWithPlayers pushBackUnique group _x} forEach (call BIS_fnc_listPlayers);
_allGroupsWithPlayers = [_allGroupsWithPlayers, [], {groupId _x}, "ASCEND"] call BIS_fnc_sortBy;

_str = ""; 

{
	_str = _str + "<font color='#7FFF00' size='12' face='TahomaB'>" + (groupId _x) + "</font>" + "<br></br>";
	{
		_role = roleDescription _x; 
		if (_role == "") then {_role = (getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"))} else {_role = (_role splitString "@") select 0};
		_str = _str + "<font color='#349d9e'>" + (_role) + "</font>" + ":  " + (name _x) + "<br></br>";
	} forEach units _x;
	_str = _str + "<br></br><br></br>"
} forEach _allGroupsWithPlayers;

orbat = player createDiaryRecord ["Diary", ["ORBAT","<execute expression='execVM ""scripts\orbat.sqf"";'>Refresh</execute>" + "<br></br><br></br>" + _str]]; 