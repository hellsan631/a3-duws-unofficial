////////////////////////////////////////
//////  BattleBorn Framework  //////////
////////////////////////////////////////
waitUntil {!isNull player};

player addRating 20000; //Fix that AI doesn't attack players when they kill friendly units so quickly.

if (BATTLE_DELETERESPAWNCORPSE == 1) then {
	[] execVM functionLocation + "battle_deleteCorpse.sqf";
};

if (BATTLE_FASTROPE == 1) then {
	[] execVM functionLocation + "battle_fastRope.sqf";
};

if (BATTLE_FATIGUE == 1) then {
	[] execVM functionLocation + "battle_fatigue.sqf";
};

if (BATTLE_FIELDREPAIR == 1) then {
	[] execVM functionLocation + "battle_fieldRepair.sqf";
};

if (BATTLE_FLIPVEHICLE == 1) then {
	[] execVM functionLocation + "battle_flipAction.sqf";
};

if (BATTLE_DAMAGE_MODENABLE == 1) then {
	[] execVM functionLocation + "battle_handleDamage.sqf";
};

if (BATTLE_INSIGNIA == 1) then {
	[] execVM functionLocation + "battle_insignia.sqf";
};

if (BATTLE_JUMP == 1) then {
	[] execVM functionLocation + "battle_jump.sqf";
};

if (BATTLE_KNIFE == 1) then {
	[] execVM functionLocation + "battle_knife.sqf";
};

if (BATTLE_MAPMARKERS == 1) then {
	[] execVM functionLocation + "battle_mapMarkers.sqf";
};

if (BATTLE_NV_MODENABLE == 1) then {
	[] execVM functionLocation + "battle_nvgEffects.sqf";
};

if (BATTLE_SAVERESPAWNLOADOUT == 1) then {
	[] execVM functionLocation + "battle_respawnLoadout.sqf";
};