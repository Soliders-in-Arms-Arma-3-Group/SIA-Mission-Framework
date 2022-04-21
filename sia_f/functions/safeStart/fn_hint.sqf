/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description: Formats and displays information about the current mission in the form of a hint.

	USAGE: Private

	PARAMS: None
*/
#include "..\..\..\# MISSION CONFIG\Settings\arsenal.hpp"
#include "..\..\..\# MISSION CONFIG\Settings\radio.hpp"

#define COLOR_HEADER "#FFB84C" // light orange
#define COLOR_PRIMARY "#FFFFFF" // white
#define COLOR_SECONDARY "#666666" // gray

#define FONT_HEADER "PuristaMedium"
#define FONT_PRIMARY "PuristaLight"
#define FONT_SECONDARY "PuristaSemibold"

#define ALIGN_RIGHT_FONT "align", "right", "font"
#define ALIGN_LEFT_FONT "align", "left", "font"

#define ALIGN_RIGHT_COLOR "align", "right", "color"
#define ALIGN_LEFT_COLOR "align", "left", "color"

if (!(player getVariable ["sia_showStatusHint", true]) || !hasInterface) exitWith {}; // Exit if not a player or if player has disabled status hint.

private _systemTime = systemTimeUTC; // Cache System's current time.

private _separator = parseText "<br />------------------------------<br />";
private _image = "sia_f\images\sia_tiny.paa";

private _txtHeader = text sia_f_missionName;
_txtHeader setAttributes ["color", COLOR_HEADER, "size", "1.4", "font", FONT_SECONDARY, "shadow", "1", "shadowColor", COLOR_SECONDARY, "shadowOffset", "0.07"];

private _txtSetup = text "Current Phase:";
_txtSetup setAttributes [ALIGN_LEFT_FONT, FONT_HEADER];

private _txtSetupPhase = text sia_f_setupPhase;
_txtSetupPhase setAttributes [ALIGN_RIGHT_FONT, FONT_HEADER];

private _txtLocation = text (sia_f_missionLocationName + "     " + str (date select 1) + "-" + str (date select 2) + "-" + str (date select 0) + "     " + ([daytime, "HH:MM"] call BIS_fnc_timeToString));
_txtLocation setAttributes ["center", "left", "color", COLOR_SECONDARY, "font", FONT_PRIMARY, "size", "0.8"];

private _txtSystemTime = text "System Time:";
_txtSystemTime setAttributes [ALIGN_LEFT_FONT, FONT_HEADER];

private _timezoneOffset = -5;
private _timezoneName = "EST";
if ( (_systemTime select 1) >= 3 && (_systemTime select 1) <= 11 ) then { _timezoneOffset = -4; _timezoneName = "EDT" }; // Quick and dirty DST adjustment.

private _hour = _systemTime select 3;
_hour = if (_hour <= 11) then [{ _hour + 24 + _timezoneOffset }, { _hour + _timezoneOffset }]; // Adjust hour of day for UTC being a day ahead of ET.

_txtTime = text (([(_hour + ((_systemTime select 4) / 60)), "HH:MM"] call BIS_fnc_timeToString) + " " + _timezoneName);
_txtTime setAttributes [ALIGN_RIGHT_FONT, FONT_HEADER];

private _txtCTab = text "CTab:";
_txtCTab setAttributes [ALIGN_LEFT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];
private _txtCTabEnabled = text toUpper (str SIA_HAVE_CTAB);
_txtCTabEnabled setAttributes [ALIGN_RIGHT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];

private _txtArsenal = text "Arsenals:";
_txtArsenal setAttributes [ALIGN_LEFT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];
private _txtArsenalEnabled = text toUpper (str SIA_ARSENAL_ENABLED);
_txtArsenalEnabled setAttributes [ALIGN_RIGHT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];

private _txtRadios = text "Radios:";
_txtRadios setAttributes [ALIGN_LEFT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];
private _txtRadiosEnabled = text toUpper (str SIA_ACRE_ENABLED);
_txtRadiosEnabled setAttributes [ALIGN_RIGHT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];

private _txtKAT = text "KAT Medical:";
_txtKAT setAttributes [ALIGN_LEFT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];
private _txtKATState = text toUpper SIA_HAVE_KAT_MEDICAL;
_txtKATState setAttributes [ALIGN_RIGHT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY];

private _txtFaction = text "Faction:";
_txtFaction setAttributes [ALIGN_LEFT_FONT, FONT_PRIMARY];
private _txtFactionName = text sia_f_factionName;
_txtFactionName setAttributes [ALIGN_RIGHT_FONT, FONT_PRIMARY];

private _txtRole = text "Role:";
_txtRole setAttributes [ALIGN_LEFT_FONT, FONT_PRIMARY];
private _txtRoleName = text sia_f_roleName;
_txtRoleName setAttributes [ALIGN_RIGHT_FONT, FONT_PRIMARY];

private _txtGroup = text "Group:";
_txtGroup setAttributes [ALIGN_LEFT_FONT, FONT_SECONDARY, "color", COLOR_HEADER];
private _txtGroupName = text (groupId (group player));
_txtGroupName setAttributes [ALIGN_RIGHT_FONT, FONT_SECONDARY, "color", COLOR_HEADER];
private _groupMembers =  (units group player) apply {name _x};
private _txtGroupMembers = "";

private _array = [
	image _image, // const start
	lineBreak,
	_txtHeader,
	lineBreak,
	_txtLocation,
	_separator, // const end
	_txtSetup, _txtSetupPhase,
	lineBreak,
	_txtSystemTime, _txtTime,
	lineBreak, // const start
	lineBreak,
	_txtArsenal,_txtArsenalEnabled,
	lineBreak,
	_txtCTab,  _txtCTabEnabled,
	lineBreak,
	_txtRadios, _txtRadiosEnabled,
	lineBreak,
	_txtKAT,_txtKATState,
	lineBreak,
	lineBreak, // const end
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
		_roleColor = COLOR_PRIMARY
	};

	private _teamColor = switch (assignedTeam _x) do {
		case "RED": { "#FEAAAA" };
		case "GREEN": { "#AAFEAA" };
		case "BLUE": { "#AAAAFE" };
		case "YELLOW": { "#FEFEAA" };
		default { COLOR_PRIMARY };
	};

	private _rankIcon = image ("\A3\Ui_F\Data\GUI\Cfg\Ranks\"+ (rank _x) + "_gs.paa"); // Get icon of units' rank from config.
	_rankIcon setAttributes ["align","left","size","0.8","color", _teamColor];
	_array pushBack _rankIcon;

	private _txt = text (" " + name _x);
	_txt setAttributes [ALIGN_LEFT_COLOR, _teamColor, "font", FONT_HEADER, "size", "0.8"];
	_array pushBack _txt;

	_txt = text _role;
	_txt setAttributes [ALIGN_RIGHT_COLOR, COLOR_SECONDARY, "font", FONT_PRIMARY, "size", "0.8"];
	_array pushBack _txt;
	_array pushBack lineBreak;
} forEach ([leader player] + (units group player - [leader player])); // Do for all units in group, starting with the group lead.

private _structuredText = composeText _array;

hintSilent _structuredText;
