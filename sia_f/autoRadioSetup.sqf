waitUntil { ([] call acre_api_fnc_isInitialized) };

_hasPersonalRadio = false;
_hasHandheldRadio = false;
_personalRadio = ["ACRE_PRC343"] call acre_api_fnc_getRadioByType;
_handheldRadio = ["ACRE_PRC152"] call acre_api_fnc_getRadioByType;

// Check if player has 343, and set it to Right Ear
if ([player, "ACRE_PRC343"] call acre_api_fnc_hasKindOfRadio) then {
	_hasPersonalRadio = true;
	[ _personalRadio, "RIGHT" ] call acre_api_fnc_setRadioSpatial;
};

// Check if player has the Faction Radio, and set it Left Ear
if ([player, _handheldRadio] call acre_api_fnc_hasKindOfRadio) then {
	_hasHandheldRadio = true;
	[ _handheldRadio, "LEFT" ] call acre_api_fnc_setRadioSpatial;
};

// If player has both radios, set the order
if (_hasPersonalRadio && _hasHandheldRadio) then { [ [ _personalRadio, _handheldRadio ] ] call acre_api_fnc_setMultiPushToTalkAssignment };
