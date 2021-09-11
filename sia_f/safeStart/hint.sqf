private _colorHeader = "#FFB84C";
private _colorPrimary = "#FFFFFF";
private _colorSecondary ="#666666";

_separator = parseText "<br />------------------------<br />";
_image = "sia_f\images\sia_tiny.paa";
_txtHeader = text sia_f_missionName;
_txtHeader setAttributes ["color", _colorHeader, "size", "1.4","font","PuristaSemibold", "shadow","1","shadowColor",_colorSecondary,"shadowOffset","0.07"];
_txt1 = text "Current Phase:";
_txt1 setAttributes ["align", "left","font","PuristaMedium"];
_txt2 = text sia_f_setupPhase;
_txt2 setAttributes ["align", "right","font","PuristaMedium"];
_txt3 = text "CTab:";
_txt3 setAttributes ["align", "left","color", _colorSecondary,"font","PuristaLight"];
_txt4 = text toUpper (str  sia_f_haveCTab);
_txt4 setAttributes ["align", "right","color", _colorSecondary,"font","PuristaLight"];
_txtArsenal = text "Arsenals:";
_txtArsenal setAttributes ["align", "left","color", _colorSecondary,"font","PuristaLight"];
_txtArsenalEnabled = text toUpper (str  sia_f_arsenalEnabled);
_txtArsenalEnabled setAttributes ["align", "right","color", _colorSecondary,"font","PuristaLight"];
_txt5 = text "Radios:";
_txt5 setAttributes ["align", "left","color", _colorSecondary,"font","PuristaLight"];
_txt6 = text toUpper (str sia_f_acreEnabled);
_txt6 setAttributes ["align", "right","color", _colorSecondary,"font","PuristaLight"];
_txtKAT = text "KAT Medical:";
_txtKAT setAttributes ["align", "left","color", _colorSecondary,"font","PuristaLight"];
_txtKATState = text toUpper sia_f_haveKATMedical;
_txtKATState setAttributes ["align", "right","color", _colorSecondary,"font","PuristaLight"];
_txtfaction = text "Faction:";
_txtfaction setAttributes ["align", "left","font","PuristaLight"];
_txtfactionName = text sia_f_factionName;
_txtfactionName setAttributes ["align", "right","font","PuristaLight"];
_txtRole = text "Role:";
_txtRole setAttributes ["align", "left","font","PuristaLight"];
_txtRoleName = text sia_f_roleName;
_txtRoleName setAttributes ["align", "right","font","PuristaLight"];
_txtGroup = text "Group:";
_txtGroup setAttributes ["align", "left","font","PuristaSemibold","color",_colorHeader];
_txtGroupName = text (groupId (group player));
_txtGroupName setAttributes ["align", "right","font","PuristaSemibold","color",_colorHeader];
_groupMembers =  (units group player) apply {name _x};
_txtGroupMembers = "";

_array = [
	image _image,  
	lineBreak, 
	_txtHeader,
	_separator, 
	_txt1, _txt2,
	lineBreak, 
	lineBreak, 
	_txtArsenal,_txtArsenalEnabled,
	lineBreak,
	_txt3,  _txt4,
	lineBreak,
	_txt5, _txt6,
	lineBreak,
	_txtKAT,_txtKATState,
	lineBreak,
	lineBreak,
	_txtfaction, _txtfactionName,
	lineBreak,
	_txtRole, _txtRoleName,
	//_txtRadioType, _txtRadioInfo,
	lineBreak,
	lineBreak,
	_txtGroup,_txtGroupName,
	lineBreak,
	_txtGroupMembers
	];

	{
 _role = roleDescription _x; 
 _roleColor = '';
		if (_role == "") then {_role = (getText(configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName"))} else {_role = (_role splitString "@") select 0}; // If roleDescription is set, then truncate. Else use config name.
		if (_x == player) then {_roleColor = '#B21A00'} else {_roleColor = '#ffffff'}; // Set color of player's name to tan.

			_teamColor = switch (assignedTeam _x) do {
				case "MAIN": {"#FFFFFF"};
				case "RED": {"#FEAAAA"};
				case "GREEN": {"#AAFEAA"};
				case "BLUE": {"#AAAAFE"};
				case "YELLOW": {"#FEFEAA"}; 
				default {"#FFFFFF"};
		};
		_rankIcon = image ("\A3\Ui_F\Data\GUI\Cfg\Ranks\"+ (rank _x) + "_gs.paa"); // Get icon of units' rank from config.
		_rankIcon setAttributes ["align","left","size","0.8","color",_teamColor];
		_array pushBack _rankIcon;
		_txt = text (" " + name _x);
		_txt setAttributes ["align", "left", "color", _teamColor,"font","PuristaMedium","size","0.8"];
		_array pushBack _txt;
		_txt = text _role;
		_txt setAttributes ["align", "right", "color", _colorSecondary,"font","PuristaLight","size","0.8"];
		_array pushBack _txt;
		_array pushBack lineBreak;
} forEach ([leader player] + (units group player - [leader player])); // Do for all units in group, starting with the group lead.

_structuredText = composeText _array;

hintSilent _structuredText;
