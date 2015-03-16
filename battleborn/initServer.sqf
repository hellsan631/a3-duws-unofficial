////////////////////////////////////////
//////  BattleBorn Framework  //////////
////////////////////////////////////////

if (!isServer) exitWith {};

if (BATTLE_REMOVENVG_AI == 1 || BATTLE_FORCEFLASHLIGHTUSE_AI == 1) then {
	[] execVM functionLocation + "battle_removeNVG.sqf";
};

if (BATTLE_DYNAMIC_WEATHER == 1) then {
	[] execVM functionLocation + "battle_dynamicWeather.sqf";
};

if (BATTLE_CLEANUP == 1) then {
	[] execVM functionLocation + "battle_cleanup.sqf";
};

if(BATTLE_TIMEACCELERATION == 1) then {
	setTimeMultiplier BATTLE_TIMEACCELERATION_FACTOR;
};