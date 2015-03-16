private ["_unit"];

_unit = _this select 0;

_unit SetUnitPos "UP";
_unit playActionNow "gesturePoint";
_unit disableAI "MOVE";