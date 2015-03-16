if (!(isDedicated)) then {
    waitUntil {!isNil "BIS_fnc_init";};
    waitUntil {!(isnull (findDisplay 46));};
};

waitUntil {!isNull player && player == player};

getLoadout = compile preprocessFileLineNumbers (functionLocation + 'battle_respawnLoadout\fn_getLoadout.sqf');
setLoadout = compile preprocessFileLineNumbers (functionLocation + 'battle_respawnLoadout\fn_setLoadout.sqf');

// Load saved loadout (including ammo count) on respawn
respawnLoadoutEH = player addMPEventHandler ["MPRespawn", {

    private ["_respawnLoadout"];

    _respawnLoadout = profileNamespace getVariable "saveLoadout";

    [player, _respawnLoadout, ["ammo"]] spawn setLoadout;

}];

if(BATTLE_DAMAGE_MODENABLE == 0) then {
	[] spawn {

	    while{true} do {

	        if(alive player) then {

	            _respawnLoadout = [player,["ammo","repetitive"]] call getLoadout;

				profileNamespace setVariable ["saveLoadout", _respawnLoadout];

	        } else {

	        	waitUntil {alive player};

	        	sleep 5;

	    	};

	    	sleep 20;

	    };
	};
};