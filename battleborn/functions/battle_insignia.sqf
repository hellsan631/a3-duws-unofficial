if (!(isDedicated)) then {
    waitUntil {!isNil "BIS_fnc_init";};
    waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

[] spawn {

	while {true} do {

		[player, "Praxus_insignia"] call BIS_fnc_setUnitInsignia;

		sleep 20;

	};

};