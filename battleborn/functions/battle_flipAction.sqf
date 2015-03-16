if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

battle_fnc_flipVehicle = compile preprocessFileLineNumbers (functionLocation + "battle_fieldRepair\fnc_flipVehicle.sqf");

flipVehicleEH = player addMPEventHandler ["MPRespawn", {

	player addAction ["Flip Vehicle", {[] call battle_fnc_flipVehicle;}, [], 0, false, true, "", "_this == vehicle _target"];

}];


