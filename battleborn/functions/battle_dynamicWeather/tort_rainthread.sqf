private ["_amount", "_time", "_seedvar", "_count"];
tort_rainthread = true; _count = 1; _seedvar = _this select 2;

// Random number generator
// Input: number, seed (integer)
// _myrandomnumber = [max] call rainthread_tRandom;
rainthread_tRandom = {
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

while {tort_rainthread} do {
   rainControlledBy = "ArmA";
   _time = 30 + floor([400 * (1 - windstr)] call rainthread_tRandom);
   sleep _time;
   //
   _amount = [overcast + rain] call rainthread_tRandom;
   if (_amount > (_this select 1)) then {_amount = (_this select 0) + ([(_this select 1)-(_this select 0)] call rainthread_tRandom);};
   if (_amount < (_this select 0)) then {_amount = (_this select 0) + ([((_this select 1)-(_this select 0))/10] call rainthread_tRandom);};
   _time = 10 + floor(([10] call rainthread_tRandom) + ([10] call rainthread_tRandom) + ([10] call rainthread_tRandom) + ([300 * (1 - windstr)] call rainthread_tRandom));
   if (overcast > 0.65) then {
      // only control if overcast > 0.65 as no checks for clouds above player can be done. simulcloudocclusion is broken.
      rainControlledBy = "Script";
      _time setrain _amount;
   };
   sleep (_time + floor([0.2 * _time] call rainthread_tRandom));
};

tort_rainthread = false;