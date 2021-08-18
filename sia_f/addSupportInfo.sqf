/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Generates support tab information regarding avaliable assets and their ammo.

	USAGE:
		Run locally.

	PARAMS:
		0: Array of assets for support.
*/
private _str = "";
private _assets = _this select 1;

{
	_str = _str + "<font face='PuristaBold' size = '16'>" + getText (configfile >> "CfgVehicles" >> typeOf _x >> "displayName") + "</font><br></br>";
	{
	if (str (_x select 4) != "-1") then {
		 _str = _str + 
		 "<font face='PuristaMedium' color='#FFB84C'>" + 
		 getText (configfile >> "CfgMagazines" >> (_x select 3) >> "displayName") + 
		 "</font><font face='PuristaLight'>: x" + 
		 str (_x select 4) + 
		 " rounds</font><br></br>"
		 };
	} forEach  getAllPylonsInfo _x;
	_str = _str + "<font face='PuristaMedium'>Cargo Seats: " + "<font face='PuristaLight'>" +  str (_x emptyPositions "cargo") + "</font><br></br><br></br>";
} forEach _assets;

_str = _str + "<br></br><br></br>" + (_this select 0);
player createDiaryRecord ["Diary",["Support",_str],taskNull,"",true];

//private _icon = "z\" + getText (configfile >> "CfgVehicles" >> typeOf _x >> "picture");
//_str = _str + format ["<img image=%1/>",_icon];