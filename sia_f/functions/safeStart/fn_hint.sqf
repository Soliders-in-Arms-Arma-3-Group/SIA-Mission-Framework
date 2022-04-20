/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description: Formats and displays information about the current mission in the form of a hint.

	USAGE: Private

	PARAMS: None
*/

if (!sia_f_showStatusHint || !hasInterface) exitWith {}; // Exit if not a player or if player has disabled status hint.

private _colorHeader = "#FFB84C"; // light orange
private _colorPrimary = "#FFFFFF"; // white
private _colorSecondary ="#666666"; // gray

private _fontHeader = "PuristaMedium";
private _fontPrimary = "PuristaLight";
private _fontSecondary = "PuristaSemibold";

private _systemTime = systemTimeUTC; // Cache System's current time.

private _separator = parseText "<br />------------------------------<br />";
private _image = "sia_f\images\sia_tiny.paa";

private _txtHeader = text sia_f_missionName;
_txtHeader setAttributes ["color", _colorHeader, "size", "1.4", "font", _fontSecondary, "shadow", "1", "shadowColor", _colorSecondary, "shadowOffset", "0.07"];

private _txtSetup = text "Current Phase:";
_txtSetup setAttributes ["align", "left", "font", _fontHeader];

private _txtSetupPhase = text sia_f_setupPhase;
_txtSetupPhase setAttributes ["align", "right", "font", _fontHeader];

private _txtLocation = text (sia_f_missionLocationName + "     " + str (date select 1) + "-" + str (date select 2) + "-" + str (date select 0) + "     " + ([daytime, "HH:MM"] call BIS_fnc_timeToString));
_txtLocation setAttributes ["center", "left", "color", _colorSecondary, "font", _fontPrimary, "size", "0.8"];

private _txtSystemTime = text "System Time:";
_txtSystemTime setAttributes ["align", "left", "font", _fontHeader];

private _timezoneOffset = -5;
private _timezoneName = "EST";
if ( (_systemTime select 1) >= 3 && (_systemTime select 1) <= 11 ) then { _timezoneOffset = -4; _timezoneName = "EDT" }; // Quick and dirty DST adjustment.

private _hour = _systemTime select 3;
_hour = if (_hour <= 11) then [{ _hour + 24 + _timezoneOffset }, { _hour + _timezoneOffset }]; // Adjust hour of day for UTC being a day ahead of ET.

_txtTime = text (([(_hour + ((_systemTime select 4) / 60)), "HH:MM"] call BIS_fnc_timeToString) + " " + _timezoneName);
_txtTime setAttributes ["align", "right", "font", _fontHeader];

private _txt3 = text "CTab:";
_txt3 setAttributes ["align", "left", "color", _colorSecondary, "font", _fontPrimary];
private _txt4 = text toUpper (str sia_f_haveCTab);
_txt4 setAttributes ["align", "right", "color", _colorSecondary, "font", _fontPrimary];

private _txtArsenal = text "Arsenals:";
_txtArsenal setAttributes ["align", "left", "color", _colorSecondary, "font", _fontPrimary];
private _txtArsenalEnabled = text toUpper (str sia_f_arsenalEnabled);
_txtArsenalEnabled setAttributes ["align", "right", "color", _colorSecondary, "font", _fontPrimary];

private _txt5 = text "Radios:";
_txt5 setAttributes ["align", "left", "color", _colorSecondary, "font", _fontPrimary];
private _txt6 = text toUpper (str sia_f_acreEnabled);
_txt6 setAttributes ["align", "right", "color", _colorSecondary, "font", _fontPrimary];

private _txtKAT = text "KAT Medical:";
_txtKAT setAttributes ["align", "left", "color", _colorSecondary, "font", _fontPrimary];
private _txtKATState = text toUpper sia_f_haveKATMedical;
_txtKATState setAttributes ["align", "right", "color", _colorSecondary, "font", _fontPrimary];

private _txtFaction = text "Faction:";
_txtFaction setAttributes ["align", "left", "font", _fontPrimary];
private _txtFactionName = text sia_f_factionName;
_txtFactionName setAttributes ["align", "right", "font", _fontPrimary];

private _txtRole = text "Role:";
_txtRole setAttributes ["align", "left", "font", _fontPrimary];
private _txtRoleName = text sia_f_roleName;
_txtRoleName setAttributes ["align", "right", "font", _fontPrimary];

private _txtGroup = text "Group:";
_txtGroup setAttributes ["align", "left", "font", _fontSecondary, "color", _colorHeader];
private _txtGroupName = text (groupId (group player));
_txtGroupName setAttributes ["align", "right", "font", _fontSecondary, "color", _colorHeader];
private _groupMembers =  (units group player) apply {name _x};
private _txtGroupMembers = "";

private _array = [
	image _image,
	lineBreak,
	_txtHeader,
	lineBreak,
	_txtLocation,
	_separator,
	_txtSetup, _txtSetupPhase,
	lineBreak,
	_txtSystemTime, _txtTime,
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
	_txtFaction, _txtFactionName,
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
	private _role = roleDescription _x;
	private _roleColor = '';

	if (_role != "") then { // If roleDescription is set, then truncate. Else use config name.
		_role = (_role splitString "@") select 0
	} else {
		_role = getText (configFile >> "CfgVehicles" >> (typeOf _x) >> "displayName")
	};

	if (_x == player) then { // Set color of player's name to tan.
		_roleColor = '#B21A00'
	} else {
		_roleColor = '#ffffff'
	};

	private _teamColor = switch (assignedTeam _x) do {
		case "RED": { "#FEAAAA" };
		case "GREEN": { "#AAFEAA" };
		case "BLUE": { "#AAAAFE" };
		case "YELLOW": { "#FEFEAA" };
		default { "#FFFFFF" };
	};

	private _rankIcon = image ("\A3\Ui_F\Data\GUI\Cfg\Ranks\"+ (rank _x) + "_gs.paa"); // Get icon of units' rank from config.
	_rankIcon setAttributes ["align","left","size","0.8","color", _teamColor];
	_array pushBack _rankIcon;

	private _txt = text (" " + name _x);
	_txt setAttributes ["align", "left", "color", _teamColor, "font", _fontHeader, "size", "0.8"];
	_array pushBack _txt;

	_txt = text _role;
	_txt setAttributes ["align", "right", "color", _colorSecondary, "font", _fontPrimary, "size", "0.8"];
	_array pushBack _txt;
	_array pushBack lineBreak;
} forEach ([leader player] + (units group player - [leader player])); // Do for all units in group, starting with the group lead.

private _structuredText = composeText _array;

hintSilent _structuredText;
