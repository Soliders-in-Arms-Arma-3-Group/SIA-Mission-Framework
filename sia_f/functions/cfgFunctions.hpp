class sia_f
{
	class briefing
	{
		file = "sia_f\functions\briefing";
		class loadoutNotes {}; // sia_f_fnc_loadoutNotes
		class orbat {}; // sia_f_fnc_orbat
	};

	class AFK
	{
		file = "sia_f\functions\AFK";
		class deserializeState {}; // sia_f_fnc_deserializeState
		class encodeJSON {}; // sia_f_fnc_encodeJSON
		class exitAFK {}; // sia_f_fnc_exitAFK
		class goAFK {}; // sia_f_fnc_goAFK
		class serializeState {}; // sia_f_fnc_serializeState
	};
	
	class radios
	{
		file = "sia_f\functions\radios";
		class ACRERadioSetup {}; // sia_f_fnc_ACRERadioSetup
	};

	class safeStart
	{
		file = "sia_f\functions\safeStart";
		class hint {}; // sia_f_fnc_hint
	};

	class teleport
	{
		file = "sia_f\functions\teleport";
		class teleportToSquad {}; // sia_f_fnc_teleportToSquad
	};
};
