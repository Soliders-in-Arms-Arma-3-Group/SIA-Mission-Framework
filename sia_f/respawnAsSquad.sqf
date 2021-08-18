/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		When all players in a group has died, server will automatically give each player a ticket to respawn.

	USAGE:
		Should only be ran on the server.

	PARAMS:
		0: Unit to be teleported.
*/

while {true} do {
	{
		private _grp = _x;
		if ( {alive _x} count units _grp == 0 ) then { units _grp apply {[_x, 1] call BIS_fnc_respawnTickets} }
	} forEach allGroups;
	sleep 5;
}; 