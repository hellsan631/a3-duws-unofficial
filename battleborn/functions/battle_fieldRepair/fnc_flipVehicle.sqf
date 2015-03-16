private ["_veh", "_objects", "_caller"];

_caller = _this select 1;
_objects = nearestObjects [_caller, ["Car","Tank"], 5];

if (count _objects > 0) then {
	_veh = (_objects select 0);
};

if (!isNil "_veh") then {
	if ({alive _x} count crew _veh == 0) then {
		_veh setVectorUp [0,0,1];
		_veh setPosATL [getPosATL _veh select 0, getPosATL _veh select 1,0];
	} else {
		hint format ["There are people still inside of the vehicle %1", name _caller];
		sleep 3;
		hint "";
	};
} else {
	hint format ["There is no vehicle in range %1", name _caller];
	sleep 3;
	hint "";
};