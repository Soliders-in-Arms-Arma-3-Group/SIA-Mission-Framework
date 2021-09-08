//hint parseText "<t color='#ff0000'>SIA Mission Framework</t>";
_separator = parseText "<br />------------------------<br />";
_image = "sia_f\images\sia_tiny.paa";
_txt1 = text "Status:";
_txt1 setAttributes ["align", "left"];
_txt2 = text "Pre-Mission";
_txt2 setAttributes ["align", "right"];
_txt3 = text "CTab:";
_txt3 setAttributes ["align", "left"];
_txt4 = text (str sia_f_haveCTab);
_txt4 setAttributes ["align", "right"];
_txt5 = text "Radios:";
_txt5 setAttributes ["align", "left"];
_txt6 = text (str sia_f_acreEnabled);
_txt6 setAttributes ["align", "right"];
_txtfaction = text "Faction:";
_txtfaction setAttributes ["align", "left"];
_txtfactionName = text sia_f_factionName;
_txtfactionName setAttributes ["align", "right"];
_txtRole = text "Role:";
_txtRole setAttributes ["align", "left"];
_txtRoleName = text roleName;
_txtRoleName setAttributes ["align", "right"];
_txtGroup = text "Group:";
_txtGroup setAttributes ["align", "left"];
_txtGroupName = text (groupId (group player));
_txtGroupName setAttributes ["align", "right"];


_structuredText = composeText [
	image _image, 
	lineBreak, 
	lineBreak, 
	text sia_f_missionName, 
	_separator, 
	_txt1, _txt2,
	lineBreak, 
	lineBreak, 
	_txt3,  _txt4,
	lineBreak,
	_txt5, _txt6,
	lineBreak,
	_txtfaction, _txtfactionName,
	lineBreak,
	_txtRole, _txtRoleName,
	//_txtRadioType, _txtRadioInfo,
	lineBreak,
	lineBreak,
	_txtGroup,_txtGroupName
	];

/*
_structuredText = "";
{
	_structuredText = _structuredText + (name _x);
} forEach (units group player);
*/
hintSilent _structuredText;
