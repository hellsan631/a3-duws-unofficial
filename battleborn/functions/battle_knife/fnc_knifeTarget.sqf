if (isDedicated) exitWith {};

private ["_knifeTarget", "_killer", "_knifeUnit", "_knifeSound"];

_knifeTarget = cursorTarget;
_killer = _this select 1;

_knifeSound = soundLocation + "knife_sound.ogg";

if ((isNil "_knifeTarget") || (isNull _knifeTarget)) exitWith {false;};

if ((_knifeTarget isKindOf "Man")&&((_knifeTarget distance _killer) < BATTLE_KNIFEDISTANCE)&&(side _knifeTarget != side _killer)) then {

	[_killer] call battle_fnc_unitKnifeAnimation;

	battle_unitKnifeAnimation = _killer;
	publicVariable "battle_unitKnifeAnimation";

	sleep 0.05;

	_knifeTarget setDamage 1;

	playSound3D [_knifeSound, _killer, false, getPosATL _killer, 1, 1, 10];

};