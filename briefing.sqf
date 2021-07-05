_situation = "";
_mission = "";
_execution = "";
_support = "";
_signal = "";

player createDiaryRecord ["Diary",["Signal",_signal],taskNull,"",true];
player createDiaryRecord ["Diary",["Support",_support],taskNull,"",true];
player createDiaryRecord ["Diary",["Execution",_execution],taskNull,"",true];
player createDiaryRecord ["Diary",["Mission",_mission],taskNull,"",true];
player createDiaryRecord ["Diary",["Situation",_situation],taskNull,"",true];