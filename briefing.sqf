/*

	SIA Mission Framework (https://github.com/Soliders-in-Arms-Arma-3-Group/SIA-Mission-Framework.VR.git)
	Author: McKendrick

=====================================================================

	Description:
		Adds briefing to mission.

	USAGE:
		Run locally.

	PARAMS: None
*/

_situation = "NATO forces have launched a large aerial campaign against CSAT forces in the enemy-held eastern region of europe. Command estimates friendly forces will have air superiority until 0700.
<br></br><br></br>A UAV scan has revealed the location of an ammo dump and a command post. Command has tasked a German KSK unit to neutralize these objectives while the skies are uncontested.
<br></br><br></br>FRIENDLY FORCES:
<br></br> • German KSK
<br></br>   - Infantry
<br></br>   - Rotary Transport & Light CAS 
<br></br> • North Atlantic Treaty Organization (NATO)
<br></br>   - Attack Jets
<br></br><br></br><font color='#d6392b'>ENEMY FORCES</font>
<br></br> • Canton Protocol Strategic Alliance Treaty (CSAT)
<br></br>   - Patrols
<br></br>   - Airborne
<br></br>   - Light Vics
<br></br>   - Armored Vics
<br></br>   - MANPAD Turrets
<br></br>   - Rotary Transport & Light CAS
";
_mission = "German KSK ARE TASKED WITH neutralizing key objectives BY NO LATER THAN 0700.";
_execution = "1. Insert into the AO.
<br></br>2. Locate and destroy x1 Drone Operation Terminal at  <marker name='kassel'>OBJ Kassel</marker>.
<br></br>3. Locate and destroy x3 Ammo Trucks at <marker name='mannheim'>OBJ Mannheim</marker>.
<br></br>4. Exfiltrate and RTB to FOB Goslar.
<br></br><br></br>COMMANDER's INTENT:
<br></br>Destory key objectives with explosives. Soften garrisons with <font color='#61a358'>Reaper 1</color>. Avoid enemy QRF by utilizing <font color='#61a358'>November 1</color> for transport.";
_support = "x2 A-164 and x1 OH-6M avaliable via Simplex.";
_signal = "343 Channels
<br></br>Ch 1 - Alpha
<br></br>Ch 4 - MG Team
<br></br>Ch 6 - Plt Co
<br></br><br></br>152 Channels
<br></br>Ch 1 - PLATOON NET
<br></br>Ch 2 - AIR NET
<br></br><br></br><font color='#61a358'>Vortex</color> avaliable via Simplex with PRC-177F.
<br></br><font color='#61a358'>November 2</color> avaliable via Simplex to Pilots only.";


private _script_handler =execVM "sia_f\f_conditionNotes.sqf";
waitUntil { scriptDone _script_handler };
player createDiaryRecord ["Diary",["Signal",_signal],taskNull,"",true];
 _script_handler = [_support, [ merlin1, ah1]] execVM "sia_f\addSupportInfo.sqf";
waitUntil { scriptDone _script_handler };
player createDiaryRecord ["Diary",["Execution",_execution],taskNull,"",true];
player createDiaryRecord ["Diary",["Mission",_mission],taskNull,"",true];
player createDiaryRecord ["Diary",["Situation",_situation],taskNull,"",true];