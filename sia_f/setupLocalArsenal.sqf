_loadout = (getUnitLoadout player);
_loadout = str _loadout splitString "[]," joinString ",";
_loadout = parseSimpleArray ("[" + _loadout + "]");
_loadout = _loadout arrayIntersect _loadout select {_x isEqualType "" && {_x != ""}};
{[_x, _loadout] call ace_arsenal_fnc_addVirtualItems} forEach arsenals;

_mags = magazines player;
{[_x, _mags, true] call ace_arsenal_fnc_addVirtualItems} forEach arsenals;
