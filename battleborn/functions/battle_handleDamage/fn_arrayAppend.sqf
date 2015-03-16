private ["_n"];

_n = count (_this select 0);

{
   (_this select 0) set [_n, _x];
   _n = _n + 1;
} forEach (_this select 1);

(_this select 0)