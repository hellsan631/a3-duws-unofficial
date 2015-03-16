private ["_ScriptLocation"];

_ScriptLocation = _this select 0;

battle_fnc_damageReset 	= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_damageReset.sqf");
battle_fnc_hitHead  	= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_hitHead.sqf");
battle_fnc_hitBody		= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_hitBody.sqf");
battle_fnc_hitLegs  	= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_hitLegs.sqf");
battle_fnc_hitArms		= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_hitArms.sqf");
battle_fnc_hitBase  	= compile preprocessFileLineNumbers (_ScriptLocation + "fnc_hitBase.sqf");
