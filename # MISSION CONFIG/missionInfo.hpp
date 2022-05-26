/* Respawn Template Options
Add or remove the following templates in the line of code below to configure your respawn settings.
SEE https://community.bistudio.com/wiki/Arma_3:_Respawn#Official_Templates for more info.

	"ace_spectator": Enables ACE spectator during respawn.
	"Wave": Players who die around the same time as each other will have their respawn timer synced.
	"Counter": Display respawn countdown.
	"Tickets": Enables respawn tickets system.

*/

respawnTemplates[] = { "ace_spectator", "Wave", "Counter", "Tickets" }; // RESPAWN SETTINGS.

// ==================================================================================

author = "Soldiers in Arms"; // YOUR NAME

onLoadName = "SIA Mission Framework"; // THE MISSION'S NAME

onLoadMission = "Version 0.7.4"; // LOADING SCREEN TEXT

// loadScreen = "loadScreen.jpg"; // OPTIONAL LOADING SCREEN IMAGE (must be a .JPG or .PAA file in your mission folder, HIGHLY recommended: 2:1 aspect ratio)

respawnDelay = 60; // RESPAWN TIMER IN SECONDS. NOTE: IF USING TEMPLATE "Wave", RESPAWN DELAY IS THE MEDIAN RESPAWN TIME, NOT MAX
