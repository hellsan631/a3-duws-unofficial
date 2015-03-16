if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

battle_fnc_fieldRepair = compile preprocessFileLineNumbers (functionLocation + "battle_fieldRepair\fnc_fieldRepair.sqf");

[true] call battle_fnc_fieldRepair;
