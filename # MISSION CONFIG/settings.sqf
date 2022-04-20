/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Options available for mission makers to configure their missions. The comments to the right of each option are the valid entries.
		Entries are case sensitive.
*/

// Mission Info
// Give a custom name for the mission and faction(s) the players will be playing as. If left blank, the name as listed in the game will be used by default.
sia_f_missionName = "";
sia_f_missionLocationName = "";

// ToDo: change this to use player's namespace when changing
sia_f_showStatusHint = true; // Toggle persistent info display.

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
