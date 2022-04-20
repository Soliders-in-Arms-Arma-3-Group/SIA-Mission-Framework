/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Creates array of scoreboard data (names and deaths) of all players.
		Made for usage for SIA's Medal Hall sheet.

	Parameter(s): None
*/

private _arr = [];

// Cycle through all players for name and death.
{

	_arr pushBack [name _x, (getPlayerScores _x) select 4];

} forEach allPlayers - entities "HeadlessClient_F";

// Print data to server log/console.
// ! - THIS IS TEMP TILL BETTER SOLUTION IS IMPLEMENTED

diag_log format ["SCOREBOARD FOR %1", sia_f_missionName];
diag_log _arr;