if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

private ["_fatigue"];

[] spawn {

	while {BATTLE_FATIGUE == 1} do {

		_fatigue = getFatigue player;

		_fatigue = _fatigue - BATTLE_FATIGUEDECAY;

		if(_fatigue < 0) then {
			_fatigue = 0;
		};

		player setFatigue _fatigue;

		sleep 5;

	};

};
