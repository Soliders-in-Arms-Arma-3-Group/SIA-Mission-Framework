/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Options avalible for mission makers to configure their missions. The comments to the right of each option are the valid entries.
		Entries are case sensitive.
*/

// ============================================================================================
// Respawn Tickets
// Sets the NUMBER of avalible respawn tickets for a side. Leave as "-1" to disable tickets.

sia_f_bluforTickets = -1;
sia_f_indepTickets = -1;
sia_f_opforTickets = -1;
sia_f_civTickets = -1;

// ============================================================================================
// Mission Info
// Give a custom name for the faction the players will be playing as. If left blank, the name as listed in the editor will be used by default.

sia_f_bluforFactionName = "";
sia_f_indepFactioName = "";
sia_f_opforFactionName = "";

sia_f_showStatusHint= true;

// ============================================================================================
// Arsenal Options
// Equipment pools to be included in the arsenal. If you're not using the respective mod for an option, be sure to set it to false.

sia_f_arsenalEnabled = true; 

sia_f_disableArsenalOnRespawn = false; 

sia_f_haveBasics = true; // Add basic items such as compasses, maps, and bandages.
sia_f_haveCTab = true; // Add CTab items such as the helmat cham and rugged tablet.
sia_f_haveKATMedical = "FULL"; // "NONE"/"LIMITED"/"FULL"

// ============================================================================================
// ACRE Radio Options
// 

sia_f_acreEnabled = true;

sia_f_personalRadio = "ACRE_PRC343"; // "NONE"/"ACRE_PRC343"
sia_f_handheldRadio = "ACRE_PRC152"; // "NONE"/"ACRE_PRC148"/"ACRE_PRC152"
sia_f_manpackRadio = "ACRE_PRC117F"; // "NONE"/"ACRE_PRC77"/"ACRE_PRC117F"

// ============================================================================================
// ACE Actions Options
// 

sia_f_enableTPMenu = true; // Enable 'Teleport Menu' on ACE Buttons.
sia_f_enableTPToSquad = true; // Enable 'Teleport to Squad' on ACE Buttons.
sia_f_enableManageKit = true; // Enable 'Manage Kit' on ACE Buttons.
sia_f_enableLoadoutInfo = true; // Enable 'Update Loadout Info' on ACE Buttons.

sia_f_enableGoAFK = true; // Enable Self ACE Action to go AFK.

// ============================================================================================
// Briefing Additionals Settings
// 

sia_f_briefORBAT = true; // Add ORBAT information to briefing.
sia_f_briefWeather = true; // Add weather report to breifing.
sia_f_briefLoadout = true; // Add loadout information to briefing.

// ============================================================================================

/*
Private Settings
	ONLY TOUCH THESE SETTINGS IF YOU NEED TO EDIT THE OBJECTS FROM 'SIA MISSION FRAMEWORK ESSENTIALS'
*/

// ============================================================================================
// ACE Button Settings
// 

sia_f_ACEButtons = ((getMissionLayerEntities "ACE Buttons") select 0);
// ============================================================================================
// Arsenals array settings
// Array of objects for the ACE Arsenal. Default set to the "Arsenals" layer from the SIA Mission Framework Essentials.

sia_f_arsenals = ((getMissionLayerEntities "Arsenals") select 0);
// ============================================================================================