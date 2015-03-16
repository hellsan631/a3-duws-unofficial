if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

battle_fnc_unitKnifeAnimation  	= compile preprocessFileLineNumbers (functionLocation + "battle_knife\fnc_unitKnifeAnimation.sqf");
battle_fnc_knifeTarget  		= compile preprocessFileLineNumbers (functionLocation + "battle_knife\fnc_knifeTarget.sqf");

"battle_unitKnifeAnimation" addPublicVariableEventHandler {

	private ["_unit"];

    _unit = _this select 1;
    [_unit] call battle_fnc_unitKnifeAnimation;

};

knifeEH = player addMPEventHandler ["MPRespawn", {

    private ["_battle_knife_conditions"];

    _battle_knife_conditions = "((cursorTarget distance _this)<"+BATTLE_KNIFEDISTANCE+")&&(alive cursorTarget)&&((side cursorTarget) != (side _this))";

	player addAction ["<t color='#ff0000'>Knife</t>", {[_this] call battle_fnc_knifeTarget;}, [], 6, true, true, "", _battle_knife_conditions];

}];