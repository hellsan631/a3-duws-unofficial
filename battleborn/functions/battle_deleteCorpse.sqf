if (!(isDedicated)) then {
	waitUntil {!isNil "BIS_fnc_init";};
	waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

battle_fnc_deleteCorpse = compile preprocessFileLineNumbers (functionLocation + "battle_cleanup\fnc_deleteCorpse.sqf");

deleteCorpseEH = player addMPEventHandler ["MPRespawn", {

   _this spawn battle_fnc_deleteCorpse;

}];

