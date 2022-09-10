/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Teleports the player to any possible member of their squad, starting with their leader.

	USAGE:
		Can run locally or on server.

	PARAMS:
		0: Unit to be teleported.
*/

if (!hasInterface) exitWith {}; // Exit if not a player.
private _units = (units group player) - [player];
private _safezone = 100;
private _target = objNull;
private _i = 0;

if (count _units < 1) exitWith {
	1 cutText ["Teleport failed, squad is empty!", "PLAIN", -1, true];
	false
};

{
	if (
	((player distance _x) > _safezone) &&	
	(side _x == side player) &&
	isAbleToBreathe _x &&
	simulationEnabled _x &&
	((vehicle _x == _x) || ((vehicle _x) emptyPositions "cargo" > 0))
	) exitWith { _target = _x };
} forEach _units;

if (isNull _target) then {
	1 cutText ["Teleport Failed: No suitable unit found.", "PLAIN DOWN", -1, true];
	false
} else {
	private _str = "Teleporting to " + (name _target) + "...";
	if (vehicle _target != _target) then { _str = _str + "\nVehicle: " + getText (configFile >> "cfgVehicles" >> (typeOf (vehicle _target)) >> "displayName") };
	1 cutText [_str, "PLAIN DOWN", -1, true];
		[{ 0 cutText ["", "BLACK OUT", 1] }, [], 0.5] call CBA_fnc_waitAndExecute;

		//Teleport player 0.3m behind squad
		if (vehicle _target == _target) then {
		_LX = (getPos _target select 0) + (0.3 * sin ((getDir _target) - 180));
		_LY = (getPos _target select 1) + (0.3 * cos ((getDir _target) - 180));
		_LZ = (getPos _target select 2);
		[{ player setPos _this }, [_LX, _LY, _LZ], 2.5] call CBA_fnc_waitAndExecute;
		} else {
			[{ player moveInCargo _this }, (vehicle _target), 2.5] call CBA_fnc_waitAndExecute;	 
		};

		//Teleport effects
		[
			{
				0 cutText ["", "BLACK IN", .5];
				1 cutText ["", "PLAIN", -1, true];
			},
			[],
			3
		] call CBA_fnc_waitAndExecute;
		
	true
};