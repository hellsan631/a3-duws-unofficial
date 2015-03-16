private ["_damageLog", "_unit"];

_unit = _this select 0;

_damageLog = format ["Damage: HP: %1 | getDamage: %2", (_unit getVariable "BATTLE_UnitHP"), (damage _unit)];

[(name _unit), _damageLog] call battle_fnc_diaglog;