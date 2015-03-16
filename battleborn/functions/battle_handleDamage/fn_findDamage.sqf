private ["_unit", "_damage", "_location", "_projectile", "_damageArray"];

_unit 			= _this select 0;
_damage  		= _this select 1;
_location  		= _this select 2;
_projectile 	= _this select 3;

if (!(local _unit)) exitWith {
	BATTLE_findDamage = _this;
	if (isServer) then {
        (owner _unit) publicVariableClient "BATTLE_findDamage";
    } else {
        publicVariableServer "BATTLE_findDamage";
    };
};

if (damage _unit >= 1) exitWith {};

_damageArray = _unit getVariable ["BATTLE_damageArray", []];

_damageArray pushBack [_unit, _damage, _location, _projectile];

_unit setVariable ["BATTLE_damageArray", _damageArray, false];

//we want to wait for damage to run its course, so we need to suspend the script. the only way to do that is to spawn this
[_unit, _damageArray] spawn {

	private ["_unit", "_damageArray", "_prevCount", "_last", "_dmgExe", "_unitTrueDMG", "_unitTrueIndex", "_tempDmg", "_tempLoc", "_tempLen"];

	_unit 				= _this select 0;
	_damageArray 		= _this select 1;
	_last = 0;

	_prevCount = count _damageArray;

	//Might improve this by using diag_TickTime to measure total time eclipsed, or diag_FrameNo
	if(_prevCount > 6) then {

		sleep 0.05;

		_damageArray = _unit getVariable ["BATTLE_damageArray", []];

		if((count _damageArray) == _prevCount && (count _damageArray) > 6) then {
			_last = 1;
		};
	};

	if (_last != 1) exitWith {};

	if(_last == 1) then {
		_dmgExe = _unit getVariable ["BATTLE_runDamage", 0];

		if (_dmgExe == 0) then {
			_unit setVariable ["BATTLE_runDamage", 1, false];
		} else {
			_last = 0;
		};
	};

	if(_last == 1) then {
		_unitTrueDMG = 0;
		_unitTrueIndex = 0;

		{
			_tempDmg 	= _x select 1;
			_tempLoc 	= _x select 2;
			_tempLen 	= count (toArray _tempLoc);

			if(_tempDmg > _unitTrueDMG && (_tempLoc != "?" && _tempLen > 2)) then {
				_unitTrueDMG = _tempDmg;
				_unitTrueIndex = _forEachIndex;
			};

		} forEach _damageArray;

		(_damageArray select _unitTrueIndex) call fn_runDamage;
	};

};