if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

private ["_ScriptLocation"];

_ScriptLocation = functionLocation + "battle_handleDamage\";

[_ScriptLocation] execVM _ScriptLocation + "locationDamage.sqf"; //process the compiling functions

fn_diagDamage 		= compile preprocessFileLineNumbers (functionLocation + "battle_diag\fnc_diagDamage.sqf");
fn_arrayAppend 		= compile preprocessFileLineNumbers (_ScriptLocation + "fn_arrayAppend.sqf");
fn_addDamageHandler = compile preprocessFileLineNumbers (_ScriptLocation + "fn_addDamageHandler.sqf");
fn_projectileTables = compile preprocessFileLineNumbers (_ScriptLocation + "fn_projectileTables.sqf");
fn_findDamage 		= compile preprocessFileLineNumbers (_ScriptLocation + "fn_findDamage.sqf");
fn_runDamage 		= compile preprocessFileLineNumbers (_ScriptLocation + "fn_runDamage.sqf");

[name player, "Adding Damage Handlers"] call battle_fnc_diaglog;

[player] call fn_addDamageHandler;

player addEventHandler ["HandleRating", {
	[
		[
			["Enemy Killed", "align = 'center' size = '0.7' shadow = '1' size = '0.7'"]
		]
	] spawn bis_fnc_typeText2;

}];

"BATTLE_findDamage" addPublicVariableEventHandler {
    (_this select 1) call fn_findDamage;
};