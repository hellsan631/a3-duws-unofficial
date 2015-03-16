[] spawn {

	while {true} do {
		{

			private ["_CheckVariable"];
			_CheckVariable = _x getVariable "BATTLE_REMOVENVG";

			if (isNil ("_CheckVariable")) then {
				_CheckVariable = 0;
				_x setVariable ["BATTLE_REMOVENVG", 1 ,true];
			};

			if(!(isplayer _x) && (_CheckVariable == 0)) then {

				if(BATTLE_REMOVENVG_AI == 1) then {
					_x unlinkItem "NVGoggles";
					_x unlinkItem "NVGoggles_OPFOR";
					_x unlinkItem "NVGoggles_INDEP";
				};

				sleep 0.05;

				if(BATTLE_REMOVENVG_AI == 1) then {
					_x addPrimaryWeaponItem "acc_flashlight";

					sleep 0.05;

					_x enableGunLights "forceOn";
				};

			};

		} forEach (allUnits);

		sleep 10;
	};
};