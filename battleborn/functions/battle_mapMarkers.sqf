if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

battle_fnc_mapMarkers = compile preprocessFileLineNumbers (functionLocation + "battle_mapMarkers\fnc_mapMarkers.sqf");

["player", "ai"] call battle_fnc_mapMarkers;