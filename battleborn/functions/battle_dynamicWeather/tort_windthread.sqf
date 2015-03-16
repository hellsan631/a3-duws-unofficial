private ["_east", "_north", "_eastmax", "_northmax", "_eplus", "_dice", "_nplus", "_time", "_seedvar", "_count"];
tort_windthread = true; _count = 1; _seedvar = _this select 2;

// Random number generator
// Input: number, seed (integer)
// _myrandomnumber = [max] call windthread_tRandom;
windthread_tRandom = {
   _count = _count + 1;
   private["_i","_num","_out","_arr"]; _out = "";
   for "_i" from 1 to 7 do {
      _num = sin(_i^3 + _count + _seedvar) + 1;
      _arr = toArray str(_num);
      if ((count _arr) > 6) then {_out = _out + toString([_arr select ((count _arr) - 2)]);};
   };
   _seedvar = (1000000 - (parseNumber (_out)) + _count) % 1000000;
   ((_this select 0) * parseNumber ("0." + _out))
};

_east = _this select 0; _north = _this select 1;
setwind [_east, _north ,true];
if (([1] call windthread_tRandom) < (overcast * 0.1)) then {_dice = 1} else {_dice = overcast * overcast * overcast};
_eastmax = ([30 * _dice] call windthread_tRandom);
_northmax = ([30 * _dice] call windthread_tRandom);

while {tort_windthread} do {
   _eplus = ([1] call windthread_tRandom) - 0.5; _east = _east + _eplus;
   _nplus = ([1] call windthread_tRandom) - 0.5; _north = _north + _nplus;
   if (([15] call windthread_tRandom) < 1) then {
      if (([1] call windthread_tRandom) < (overcast * 0.3)) then {_dice = 1} else {_dice = overcast * overcast * overcast};
      _eastmax = ([30 * _dice] call windthread_tRandom);
      _northmax = ([30 * _dice] call windthread_tRandom);
   };
   if (_east > abs(_eastmax)) then {_east = _east - (2 * abs(_eplus));};
   if (_east < (-1 * abs(_eastmax))) then {_east = _east + (2 * abs(_eplus));};
   if (_north > abs(_northmax)) then {_north = _north - (2 * abs(_nplus));};
   if (_north < (-1 * abs(_northmax))) then {_north = _north + (2 * abs(_nplus));};
   _time = 10 + ([20 * (1-overcast)] call windthread_tRandom);
   sleep _time;
   //hint format ["WIND E%1 N%2 Emax%3 Nmax%4 TIME%5",_east,_north, _eastmax, _northmax, _time];
   setwind [_east, _north ,true];
};

tort_windthread = false;