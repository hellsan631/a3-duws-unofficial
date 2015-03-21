folderLocation = "";

missionLocation = [ ( str missionConfigFile ), 0, -15 ] call BIS_fnc_trimString;
scriptLocation = folderLocation + "battleborn\";
uiLocation = missionLocation + folderLocation + "battleborn\UI";
soundLocation = missionLocation + folderLocation + "battleborn\sounds\";
functionLocation = folderLocation + "battleborn\functions\";
dataLocation = missionLocation + folderLocation + "battleborn\data\";

[] execVM scriptLocation + "defaultSettings.sqf";

battle_fnc_diaglog 		= compile preprocessFileLineNumbers (functionLocation + "battle_diag\fnc_diaglog.sqf");

"BATTLE_diagLog" addPublicVariableEventHandler {

	if(isServer) then {
		diag_log format ["DiagLog: Unit: %1 | Log: %2", _this select 1 select 0, _this select 1 select 1];
	};

};

sleep 3;

["<t size='.6'>Running BattleBorn Scripts</t>",0.02,0.3,7,1,0,3010] spawn bis_fnc_dynamicText;

if (isServer || isDedicated) then {
	[] execVM scriptLocation + "initServer.sqf";
};

[] execVM scriptLocation + "initClient.sqf";
