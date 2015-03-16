private ["_unit"];

_unit = _this select 0;

_unit removeAllEventHandlers "HandleDamage";

_unit addEventHandler ["HandleDamage", {

    [_this select 0, _this select 2, _this select 1, _this select 4] call fn_findDamage;

    false;

}];