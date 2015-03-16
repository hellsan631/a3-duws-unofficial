diag_log format ["------------------ DUWS Unofficial START ----v1.22 based on Modified ------ player: %1", profileName];
//////////////////////////////////////////////////////
//  HOW TO MANUALLY CREATE THE MISSION:
//  1)YOU MUST PLACE THE HQ LOCATION
//  2)DEFINE THE CAPTURABLE ZONES
//  -- YOU CAN ALSO JUST PUT A HQ SOMEWHERE AND LET THE ZONES BEING RANDOMLY GENERATED
//  -- YOU MUST PLACE MANUALLY THE HQ IF YOU ARE ALREADY PLACING THE ZONES BY HAND
//  3) DONT FORGET TO DEFINE THE VARIABLES BELOW. If you are ONLY placing the HQ by hand, you just need to put "hq_manually_placed" to "true" instead of "false". If you are also placing the zones by hand, make "zones_manually_placed" to "true".
/////////////////////////////////////////////////////////////
//  1) In the gamelogic, for the HQ( !! MAKE ONLY ONE HQ !!): _null=[getpos this] execVM "initHQ\BluHQinit.sqf"
//
//  2) In the init of gamelogic, to create a capturable enemy zone: _null = ["zone name",pts awarded upon capture, zone radius,getpos this,false/true,false/true] execvm "createzone.sqf";
//  "zone name": name of the zone
//  pts awarded upon capture: points you earn when you capture the zone. Also the amount of points of army power you take and receive from the enemy after capture
//  zone radius: how large the zone is
//  getpos this: It's the position of the zone. The gamelogic actually. You don't have to modify this.
//  false/true: if the zone is fortified or not. If the zone is fortified, there will be a bit more enemies and they will be maning static defences if there are any
//  false/true: if the zone is selecting randomly a prefab base. Prefab is selected according to the zone radius. The bigger the zone, the bigger the prefab asset will be chosen.
//
//  EXAMPLE, in the init of a gamelogic you have placed on the map:_null=["OP Xander",20,200,getpos this,true,false] execvm "initZones\createzone.sqf"
//
//  3) Define these variables:


[] execVM "battleborn\init.sqf";


if (isNil "weather_type") then {weather_type = "tropical";};     // choose between "tropical" - "arid" - "temperate" - "temperate_cold" - "mediterranean"
if (isNil "opfor_ai_skill") then {opfor_ai_skill = [0.35,0.45];};    // set the skill range of ennemy AI
if (isNil "blufor_ai_skill") then {blufor_ai_skill = [0.9,1.0];};    // set the skill range of friendly AI, from 0 to 1 (0 being completely dumb)
hq_manually_placed = false;  // you must specify if you have manually placed HQ or not. false = HQ is randomly placed -- true = you have manually placed the HQ
zones_manually_placed = false;  // you must specify if you have manually placed the zones or not. false = zones are randomly generated -- true = you have manually placed the zones
zones_max_dist_from_hq = 7500;
dynamic_weather_enable = true;
manually_chosen = false;
Attack = false;
PlayerMrkrs = true;
zoneFound = false;


if (isNil "enable_fast_travel") then {
	enable_fast_travel = true; // allow fast travel or not
};
if (isNil "enableChopperFastTravel") then {
	enableChopperFastTravel = true;  // chopper taxi (support) will fast travel (teleport) or not
};
if (isNil "commandpointsblu1") then {
	commandpointsblu1 = 20;            // Starting CP
};

if (isNil "blufor_ap") then {
	blufor_ap = 0;
};              // STARTING ARMY POWER
opfor_ap = 0;
///////////////////////////////////////////////////////
// initialise variables
//////////////////////////////////////////////////////
// MOST OF THE VALUES ARE BEING OVERWRITTEN BY PLAYER INPUT AT THE BEGINNING
//////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////
debugmode = false;  // Debug mode, kind of obsolete
/// ------------- VALUES UNDER THIS ARE OVERWRITTEN
zones_number = 4; // Number of capturables zones to create (when zones are created randomly)
zones_spacing = 2000; // minimum space between 2 zones (in meters) // SOON OBSOLETE
zones_max_radius = 700;   // Determine the maximum radius a generated zone can have
zones_min_radius = 350; // Determine the minium radius a generated zone can have. SHOULD NOT BE UNDER 200.
///////////////////////////////////////////////////////
// This mission will have a harder time generating stuff if a lot of the terrain of the island is sloped, meaning that valid locations will be harder/take longer to find (side missions, mission init).
// Keep that in mind when tweaking the zones amount/radius value.
/////////////////////////////////////////////////////////


// preprocess the qrf file for the EH
QRF_test = compile preprocessFile "WARCOM\WARCOM_opf_qrf.sqf";
persistent_stat_script_init = [] execVM "persistent\persistent_stats_init.sqf";
waitUntil {scriptDone persistent_stat_script_init};
execvm "dynamic_music\dyn_music_init.sqf";
[] call compile preprocessFile "kndr_unit_markers.sqf";

//enable ZBE units caching
ZbeCacheStatus = paramsArray select 10;

if (ZbeCacheStatus == 1) then {
	if (isServer) then {[1000,-1,false,100,1000,1000]execvm "zbe_cache\main.sqf"};
};


missions_success = 0; // nber of missions succes(!!dont touch!!)
zones_created = false;
blu_hq_created = false;
can_get_mission = true;
failsafe_zones_not_found = false;
createcenter sideLogic;
LogicGroup = createGroup SideLogic;
PAPABEAR=[West,"HQ"];
locator_hq_actived = false;
op_zones_index = 0;
clientisSync = false;
fobSwitch = false;
player_is_choosing_hqpos = false;


if (isNil "amount_zones_created") then
{
amount_zones_created = 0;
};

if (isNil "HQ_pos_found_generated") then
{
HQ_pos_found_generated = false;
};

if (isNil "chosen_settings") then
{
chosen_settings = false;
};

if (isNil "chosen_hq_placement") then
{
chosen_hq_placement = false;
};

if (isNil "zoneundercontrolblu") then
{
zoneundercontrolblu = 0;
};

if (isNil "amount_zones_captured") then
{
amount_zones_captured = 0;
};
if (isNil "savegameNumber") then
{
savegameNumber = 0;
};
if (isNil "capturedZonesNumber") then
{
capturedZonesNumber = 0;
};
if (isNil "finishedMissionsNumber") then
{
finishedMissionsNumber = 0;
};
if (isNil "OvercastVar") then
{
OvercastVar = 0;
};
if (isNil "FogVar") then
{
FogVar = 0;
};
if (isNil "WindVar") then
{
WindVar = 0;
};
if (isNil "Array_of_FOBS") then // this is a special one (if/else)
{	// if the player is sp or server or no fobs have been created
Array_of_FOBS = [];
}
else /// JIP for the client
{
	{
	[_x] execVM "support\FOBactions.sqf";
	} forEach Array_of_FOBS;
};
if (isNil "Array_of_FOBname") then
{
Array_of_FOBname = [];
};
if (isNil "WARCOM_zones_controled_by_BLUFOR") then
{
WARCOM_zones_controled_by_BLUFOR = [];publicVariable "WARCOM_zones_controled_by_BLUFOR";
};
if (isNil "Array_of_OPFOR_zones") then
{
Array_of_OPFOR_zones = [];publicVariable "Array_of_OPFOR_zones";
};
if (isNil "WARCOM_zones_controled_by_OPFOR") then
{
WARCOM_zones_controled_by_OPFOR = [];publicVariable "WARCOM_zones_controled_by_OPFOR";
};
if (isNil "MTV1cap") then
{
MTV1cap = false;publicVariable "MTV1cap";
};
if (isNil "MTV1") then
{
MTV1 = ObjNull;
};
if (isNil "weatherdone") then
{
weatherdone = false;publicVariable "weatherdone";
};
if (isNil "officedead") then
{
officedead = false;publicVariable "officedead";
};


//MTV MARKER JIP
if (!isServer) then{
if ((MTV1cap) && (alive MTV1)) then {[MTV1, "mil_triangle", "ColorGreen", "2", "2", "MTV-1"] call kndr_assignMarker};
};

////////////////////////////////////////////////////////////////////////////////////////////////




player allowDamage false;

//Time of Day
 if (time < 10) then {
setDate [2035, 8, 6, (paramsArray select 3), 1];
};

#include "dialog\supports_init.hpp"
#include "dialog\squad_number_init.hpp"



if (!isMultiplayer) then {
	getsize_script = [player] execVM "mapsize.sqf";
};


Warcom_Limiter_Param = paramsArray select 6; //disbale/enable warcomm AI limiter for improved fps
// IF MP
if (isMultiplayer) then {

	// Get the variables from the parameters lobby
	revive_activated = paramsArray select 0; // Revives, true or false
	DUWSMP_CP_death_cost = paramsArray select 1;
	player_fatigue = paramsArray select 2;
	AttackHeli = paramsArray select 4; //disable/enable attack choppers
	TrkAllPlayer = paramsArray select 5; //disbale/enable player markers
	UseIED = paramsArray select 7;
	UseSiren = paramsArray select 8;
	MisEndCond = paramsArray select 9;


	if (revive_activated == 1) then {[]execVM "duws_revive\reviveInit.sqf"};
	if (revive_activated == 0) then {vas_onRespawn = true};
	if (AttackHeli == 0) then {Attack = false};
	if (AttackHeli == 1) then {Attack = true};
	if (TrkAllPlayer == 0) then {PlayerMrkrs = false};
	if (player_fatigue == 0) then {[]execVM "fatigue.sqf"};
	if (UseIED == 1) then {[] spawn {call compile preprocessFileLineNumbers "EPD\Ied_Init.sqf";}};

	// TcB AIS Wounding System --------------------------------------------------------------------------
if (revive_activated == 2) then {

if ((!isDedicated) || (!isServer)) then {
	waitUntil {!isNull player};
	TCB_AIS_PATH = "ais_injury\";
	{[_x] call compile preprocessFile (TCB_AIS_PATH+"init_ais.sqf")} forEach units group player;
};
};
// --------------------------------------------------------------------------------------------------------------



	if (support_armory_available) then {hq_blu1 addaction ["<t color='#ff0066'>Armory 1 (VAS)</t>","VAS\open.sqf", "", 0, true, true, "", "_this == player"];};
	if (support_armory_available) then {hq_blu1 addaction ["<t color='#ff0066'>Armory 2 (VA)</t>","va.sqf", "", 0, true, true, "", "_this == player"];};
	if (support_halo_available) then {hq_blu1 addAction ["<t color='#15ff00'>HALO Alone (5CP)</t>", "ATM_airdrop\atm_airdrop.sqf", "", 0, true, true, "", "_this == player"];};
	if (support_halo_available) then {hq_blu1 addAction ["<t color='#15ff00'>HALO Group (5CP)</t>", "COB_HALO\grphalo.sqf", "", 0, true, true, "", "_this == player"];};

	if (support_armory_available) then {_x addaction ["<t color='#ff0066'>Armory 1 (VAS)</t>","VAS\open.sqf", "", 0, true, true, "", "_this == player"]} forEach (Array_of_FOBS);
	if (support_armory_available) then {_x addaction ["<t color='#ff0066'>Armory 2 (VA)</t>","va.sqf", "", 0, true, true, "", "_this == player"]} forEach (Array_of_FOBS);
	if (support_halo_available) then {_x addaction ["<t color='#15ff00'>HALO Alone (5CP)</t>", "ATM_airdrop\atm_airdrop.sqf", "", 0, true, true, "", "_this == player"]} forEach (Array_of_FOBS);
    if (support_halo_available) then {_x addaction ["<t color='#15ff00'>HALO Group (5CP)</t>", "COB_HALO\grphalo.sqf", "", 0, true, true, "", "_this == player"]} forEach (Array_of_FOBS);




	PlayerKilledEH = player addEventHandler ["killed", {commandpointsblu1 = commandpointsblu1 - DUWSMP_CP_death_cost; publicVariable "commandpointsblu1"}];
	"support_specialized_training_available" addPublicVariableEventHandler {lbSetColor [2103, 11, [0, 1, 0, 1]];};
	"commandpointsblu1" addPublicVariableEventHandler {ctrlSetText [1000, format["%1",commandpointsblu1]];}; // change the shown CP for request dialog


	// each time there is a new FOB
	"Array_of_FOBS" addPublicVariableEventHandler {

	if (!fobSwitch) then
	{
		[] execVM "support\FOBreceiveaction.sqf";
	};
		fobSwitch = false;
		//Add the FoB to the list of revive locations.
		_fobAmount = count Array_of_FOBS;
		_fobIndex = _fobAmount - 1;
		_createdFOB = Array_of_FOBS select _fobIndex;

		[missionNamespace, _createdFOB] call BIS_fnc_addRespawnPosition;
	};

	if (!isServer) then {
	"savegameNumber" addPublicVariableEventHandler {[] execVM "savegameClient.sqf";};
	};
	if (!isServer) then {
	"capturedZonesNumber" addPublicVariableEventHandler {[] execVM "persistent\persistent_stats_zones_add.sqf";}; // change the shown CP for request dialog
	};
	if (!isServer) then {
	"finishedMissionsNumber" addPublicVariableEventHandler {[] execVM "persistent\persistent_stats_missions_total.sqf";}; // change the shown CP for request dialog
	};


    if (isServer) then { // SERVER INIT
	DUWS_host_start = false;
	publicVariable "DUWS_host_start";
	waitUntil {time > 0.1};
	getsize_script = [player] execVM "mapsize.sqf";
	DUWS_host_start = true;
	publicVariable "DUWS_host_start";




	// init High Command
	_handle = [] execVM "dialog\hc_init.sqf";
	waitUntil {scriptDone getsize_script};
	};


};





if (isServer) then
{

_null = [] execVM "dialog\startup\hq_placement\placement.sqf";
waitUntil {chosen_hq_placement};



	// create random HQ
	if (!hq_manually_placed && !player_is_choosing_hqpos) then {
	hq_create = [20, 0.015] execVM "initHQ\locatorHQ.sqf";
	waitUntil {scriptDone hq_create};
	};

};




// group cleaning script
if (isServer) then {
clean = [
		5*60, // seconds to delete dead bodies (0 means don't delete)
		5*60, // seconds to delete dead vehicles (0 means don't delete)
		0, // seconds to delete immobile vehicles (0 means don't delete)
		5*60, // seconds to delete dropped weapons (0 means don't delete)
		0, // seconds to deleted planted explosives (0 means don't delete)
		10*60 // seconds to delete dropped smokes/chemlights (0 means don't delete)
] execVM 'repetitive_cleanup.sqf';
};


///////////////////////////FOR JIP////////////////////////////////////////////////////////




if (!isServer) then { // WHEN CLIENT CONNECTS INIT (might need sleep)
//	waitUntil {isPlayer Player};
    waitUntil {!isNull player};
	hintsilent "Waiting for the host to find an HQ...";
	waitUntil {HQ_pos_found_generated && time > 0.1};
	sleep 1;
//	player setpos [(getpos hq_blu1 select 0),(getpos hq_blu1 select 1)+10];
	player setpos [(getmarkerpos str blu_hq_markername select 0),(getmarkerpos str blu_hq_markername select 1)+10];
	_drawicon = [] execVM "inithq\drawIcon.sqf";
	hintsilent "Waiting for the host to select the campaign parameters...";
	waitUntil {chosen_settings};
	[hq_blu1] execVM "initHQ\HQaddactions.sqf";
	sleep 1;
	player setdamage 0;
	player allowDamage true;
	hintsilent format["Joined game, welcome to %1, %2",worldName,profileName];
	// init High Command
	_handle = [] execVM "dialog\hc_init.sqf";
	[] execVM "dialog\startup\weather_client.sqf";

};

/////////////////////////////////////////////////////////////////////////////////////////////////


if (!isMultiplayer) then {
	_handle = [] execVM "dialog\hc_init.sqf";
	};

if (isServer) then {
// initialise the ressources per zone bonus
_basepoint = [] execVM "zonesundercontrol.sqf";
};

// init the bonuses you get when capturing zones
_basepoint = [] execVM "zones_bonus.sqf";

// INIT the operative list
execVM "dialog\operative\operator_init.sqf";


// Create help for DUWS
// Revive
_index = player createDiarySubject ["revivehelp","AI Revive"];
player createDiaryRecord ["revivehelp",["Known Issues", "- AI will sometimes stop responding to your commands. To avoid this you should always use the ""return to formation"" command on your entire group right after any revive has been performed by anyone in your group. If this does not work then simply delete the offending unit/s using the squad manager in your action menu.<br/><br/>- When using AI revive with other human players joined in your group, the  group leader position will change back and forth between the human players.<br/><br/> - AI may not ALWAYS revive the player 100% of the time. This is normal behavior and is to be expected sometimes, especially if the fighting gets very intense or the situation is too unsafe.<br/><br/>Injury script by: [TcB]-Psycho- many thanks for this!<br/>...special thanks must also go out to the coding skills of ""MDCCLXXVI"" from the Bohemia forums for fixing the command-loss issue"]];
player createDiaryRecord ["revivehelp",["Overview", "Enabled/Disabled in the Parameters Menu:<br/>When enabled, the AI units that you purchase for your group will be able to revive you if you get injured and fall unconscious (you can use your 'H' key to call for help faster, but not necessary...but be patient with the AI they sometimes take a long time to reach you). All human players will also be able to revive.<br/><br/>Purchased High command groups cannot revive you, ONLY the 'Single Units', 'Special Operatives' AND Paradrop AI can revive.<br/><br/>NOTE:<br/><br/>If sometimes you need to respawn instead of waiting to be revived then hit escape/respawn.<br/><br/>This script is not 100% reliable and you may notice some odd happenings within your group units from time to time. It is being used here as an experimental addition to DUWS.<br/><br/>Injury script by: [TcB]-Psycho- many thanks for this!<br/>...and a thousand special thanks must also go out to the coding skills of ""MDCCLXXVI"" from the Bohemia forums for fixing the command-loss issue"]];
// IED's
_index = player createDiarySubject ["iedhelp","Random IED's"];
player createDiaryRecord ["iedhelp",["Overview", "Enabled/Disabled in the Parameters Menu:<br/>When enabled there will be randomly placed IED explosives in villages, cities and along or near roads. The IED's can be any normal appearing object such as cars, wrecks, trash, almost anything really.<br/><br/>If you suspect an object may be an IED you can either stay away from it completely OR you can attempt to disarm it. All players can disarm an IED by very carefully approaching it. Once you get within 20m of it get down and crawl the rest of the way on your belly until you get to see the 'disarm' in your action menu.<br/><br/>NOTE:<br/>It is normal to have some bad lag at the very start of the mission when the IED's are first initalized. This lag will subside once the mission has fully completed all of it's initialization routines which can take a minute or so.<br/><br/>IED script by: Brian Sweeney - Thank you for all your hard work in releasing this to the public!"]];
// Operatives
_index = player createDiarySubject ["operativehelp","Special Operatives"];
player createDiaryRecord ["operativehelp", ["Skills", "<font color='#FF0000'>Aiming:</font color><br/>Pretty self explanatory, how well the operative can aim, lead a target, compensante for bullet drop and manage recoil.<br/><br/><font color='#FF0000'>Reflexes:</font color><br/>How fast the operator can react to a new threat and stabilize its aim.<br/><br/><font color='#FF0000'>Spotting:</font color><br/>The operative ability to spot targets within it's visual or audible range, and how accurately he can spot targets.<br/><br/><font color='#FF0000'>Courage:</font color><br/>Affects the morale of subordinates units of the operative, how likely they will flee, depending on what is in front of them and the squad status.<br/><br/><font color='#FF0000'>Communications:</font color><br/>How quickly recognized targets are shared with the squad.<br/><br/><font color='#FF0000'>Reload speed:</font color><br/>The operator's ability to switch weapon or reload quickly."]];
player createDiaryRecord ["operativehelp", ["Recruiting operatives", "Operatives can be recruited at the HQ, inside the ""request unit"" menu. When you recruit someone for the first time you'll have to spend 10 CP. However, once an operative has been ""injured""(killed) in battle, you can recruit it again at NO COST after a delay of 60 seconds.<br/><br/>So then, the idea with recruiting Operatives is that you pay only once to have use of them for the entire mission!"]];
player createDiaryRecord ["operativehelp", ["Overview", "You can recruit special operatives that will stay and progress with you for all the duration of the campaign. Some of these mens have special equipment, specialities and skills. Their skills will increase each time a zone is captured or a mission is accomplished, whether they're in your squad or not. However, when an operative is actually purchased, he will have 50 spendable points which you can assigned freely in any skill at the operative menu and will continue to earn an extra 20 pts each time you capture an enemy zone or complete a side mission."]];
// Weather
_index = player createDiarySubject ["weatherhelp","Weather"];
player createDiaryRecord ["weatherhelp",["Known Issues", "The 'Dynamic and Variable' changing weather setting can take up to 60 minutes or even longer to go back and forth between extreme conditions such as from completely sunny to completely stormy.<br/><br/>This is just how the game engine works in Arma3 and is considered normal. The only other option would be to have the weather change instantly (which I've only chosen to do at mission start).<br/><br/>Weather conditions while using this new default option should be properly updated for both clients and JIP players alike."]];

// Duws Manual
_index = player createDiarySubject ["help","DUWS Manual"];
player createDiaryRecord ["help", ["Feedback/bug report", "Please report any bug you see REGARDING THE MISSION by contacting me (BigShot) on the BIS forums, or on the Steam Workshop page for DUWS Modified.<br/><br/>** Due to the vast amount of scripts in DUWS Modified you must be VERY careful what type of mods or addons you try to use with it. The only known safe type of mods to use with this mission are generally mods for sound, weapon sway/recoil, ShakTac HUD, CBA. Any mods or addons that inject AI and/or that modify behavior will break DUWS.<br/><br/>If you are experiencing unexpected behavior or results in DUWS while you are running it with mods enabled then please do not report these. Only report issues that can be reproduced with no mods/addons enabled.<br/>Please keep in mind that this mission is still in development. Suggestions/feedbacks are welcome."]];
player createDiaryRecord ["help", ["Credits", "Original Version by Kibot. Modified Version by BigShot.<br/>VAS script and TAW view distance by Tonic.<br/>ATM Airdrop HALO script by PokerTour.<br/>Group HALO was implemented via an original script by cobra4v320.<br/>Defuse Bomb script by Cobra4v320.<br/>Thanks to Kempco for the mapsize script.<br/>Thanks to FrankHH for correcting the typos.<br/>Thanks to FunkDooBiesT for his help and his time.<br/>Thanks to WolfFlight[TZW] and Amarak[TZW] for their help.<br/>Repetitive Cleanup, SET/GET loadout and Player Marker scripts by aeroson.<br/>Thanks to timsk.<br/>Thanks to Dolemite and Rukus for all their patience in testing."]];
player createDiaryRecord ["help", ["Taking the Island", "At the beginning of the game, you are alone with your officer and only a few command points available, but as the war escalates, the BLUFOR HQ will start to launch attacks on enemy zone and will try to retake the island. You can help the main forces by assisting them in capturing the island, or you can also achieve side missions to boost the available assets of your army. It's up to you on how you want to play this campaign."]];
player createDiaryRecord ["help", ["Support Unlocks", "During the campaign you may unlock several support options at your HQ. You can access the available support in the radio menu (0-8). Note that calling for support cost CP.<br/><br/>If you run out of CP to buy things with you can re-Lock some of the supports which you've previously un-Locked and receive a 50% refund. You can then use those refunded points to unlock other supports if you wish."]];
player createDiaryRecord ["help", ["Squad Manager", "This screen can be used to either disband/delete your AI group members OR to move them into 'High Command'.<br/><br/>Select which units you want using your F# keys and then place them onto team yellow (9-4), then access the 'Squad Manager' screen in your action menu and choose to either 'disband/delete' or 'move to high command'."]];
player createDiaryRecord ["help", ["Side Missions", "You can request a side mission at the officer in the base. Successful side missions will not give any army power to the enemy, but will give you CP and increase your army power."]];
player createDiaryRecord ["help", ["Selectable Win/Lose Conditions", "- SELECTABLE MISSION WIN|LOSE CONDITIONS (found in the MP Parameters menu) -<br/>Cap All Zones | Officer Killed:This is the default mission mode where you WIN (mission ends) by capturing all the enemy zones by turning them greeen, or you LOSE if your HQ commanding officer gets killed (mission ends).<br/><br/>Cap All Zones | Officer + Players Killed:<br/><br/>For players who wish they had ONE LAST CHANCE to continue playing and win the mission after the HQ Officer is killed. If you select this new mode in the mission lobby's Parameters menu here is how it works:<br/><br/>1. If officer dies you still get one more chance to try and win (mission does not end yet).<br/>2. You still have to finish capping all the zones to ""win"".<br/>3. If you fall injured you still have ability to use Revive(if it was enabled at mission start params menu).<br/>4. If officer gets killed you lose all services and menus at the HQ. Fob services/menus stay intact, and you also get to retain all your previous unlocks that youve earned and requested earlier.<br/>5. If officer gets killed then you lose the ability to respawn, so if YOU die after he gets killed the mission is over for you and you will be given a free-roam spectator's camera to watch your friends continue to play and try to win.<br/><br/>Enemy team earns +50AP(army power) for killing your commanding officer and friendly team LOSES the 50AP.Mission will end  when either your team caps all the zones (win) or all human players are dead (lose), AFTER the officer has been killed.<br/><br/>*-FREE-ROAMING SPECTATOR CAMERA-*<br/>Hit your spacebar key to activate the camera system after you've died, and then use your H key to view the help menu and see all the camera control keys. You can use either your Q/Z or PageUp/PageDown keys to float up/down, your kaypad's asterick key (*) to invoke mouselook, and your move forward key to move around. **You can also click anywhere on your map to quickly move your viewpoint to that location. This is a great way to watch the action after you have been illiminated from the mission.<br/><br/>**Camera System is only available in this new game mode, and NOT in the default game mode where the mission ends after the officer is killed."]];
player createDiaryRecord ["help", ["Saving the game", "You can save the game either by using SITREP in your Comms Menu(keystrokes 0-8-1) or resting at the base. Just go near the officer and select the action ""Rest"". Note that 6 hours will ellapse during that time. You can also save at any time by giving a SITREP in the support menu (0-8-1). Giving a SITREP does not make you wait, but it will cost you 1 CP for each save."]];
player createDiaryRecord ["help", ["Requests Menu->", "To access the ""Requests"" menu, go to the officer at the Main Base or up close up to a FOB structure you've built and select the action ""Requests Menu"".<br/><br/>Here you can purchase individual AI units, High Command AI Squads and Special Operatives AI units. This is also where you must unlock/purchase any vehicles and ""Support Services"" you wish to have access to use when out in the field and away from base or a FOB.<br/><br/>Side-missions which offer you the chance at earning more spendable CP and special vehicles can also be accessed here"]];
player createDiaryRecord ["help", ["Repairing/Rearming", "To repair, refuel or rearm a vehicle you need to unlock the ""vehicle refit"" support. Once you have it, you can call the support and your vehicle will be rearmed, repaired and refueled. Note that you must be within 50m of the baseHQ or an FOB to be able to use the vehicle refit."]];
player createDiaryRecord ["help", ["Recon Camera System", "The Recon Camera System is a Support Service available in the ""Requests"" menu(newly added as of 11/2014).<br/><br/>After you unlock/purchase it you will have access to it in your 0-8 menu where you can select to use it ONLY if your Army Power is at least 175ap. It is basically a free-roam type of camera system that will stay active for only 60 seconds per use and will allow your camera to quickly view any location on the map by first hitting your Spacebar key and then clicking anywhere on your map screen.<br/><br/>Unlocking this feature costs a certain amount of CP plus additional CP each time you use it/call it from your 0-8 menu. After each use there is a 5 minute wait period before you're allowed to use it again.<br/><br/>*KNOWN ISSUES* - if you're viewing the map screen when the timer runs out you will be stuck on the map screen with no way out. If this happens you must wait 5 minutes for the camera system to reappear on the 0-8 menu and then call it again to remove yourself from the map screen. This is a game bug and cannot be fixed by the mission maker.<br/><br/>Another issue is that the ""H"" for help key will not unbind itself from bringing up the camera's help menu even after the camera has been removed. This can interfere with other scripts or addons that use the ""H"" key. This is a game bug and cannot be fixed by the mission maker since the camera system used here is hard coded and built into Arma3."]];

if (isMultiplayer) then {
player createDiaryRecord ["help", ["MP notes", "The CP pool is common for everyone.<br/><br/>While most support unlocks are indivdual, the Specialized infantry training is common, and needs to be unlocked only once by a single player.<br/><br/>While everybody can rest to heal, only the host can save and skip the time.<br/><br/>Only the host can request side mission and finish them. However, everyone receive the persistent stats and xp bonuses."]];
};
player createDiaryRecord ["help", ["FOB's", "After you have captured your first zone, you'll get the ability to establish a FOB for 10 CP. A FOB allows you to rest(save) at remote locations outside the base. Establishing a FOB will also spawn some BLUFOR patrols around it and if there are enemies around it, you will be notified. To establish a FOB, you must be within 250 meters of a friendly green zone's CENTER and also make sure the zone around you is mostly clear of enemy in a radius of 500 meters. Just go to the support menu and select 'Establish FOB'. An FOB will be deployed to your location."]];
player createDiaryRecord ["help", ["Export to another island", "<font color='#FF0000'>How to export to another island:</font color><br/>You just need to take the .pbo file and rename it, replacing the name of the current island to the name of the island you want to export the mission to. You don't have anything else to do<br/><br/>Example:<br/>SP_DUWS.stratis.pbo >>> SP_DUWS.chernarus.pbo<br/><br/>You can download the 'pbo' file of this mission using the link provided in the 'Common Questions' forum area at the Steam Workshop page."]];
player createDiaryRecord ["help", ["Experience", "By accomplishing side missions, capturing zones and islands, you will increase your experience. With experience, you will automatically unlock new abilties. Once you have an ability, a description of this ability will be available in the 'ability' tab in the briefing.<br/>Capturing an island gives you <font color='#FF0000'>5 XP</font color><br/>Achieving a side mission: <font color='#FF0000'>2 XP</font color><br/>Capturing a zone: <font color='#FF0000'>1 XP</font color>"]];
player createDiaryRecord ["help", ["Command Points (CP)", "Command points are used to purchase vehicles, units and ask for support (like artillery or save the game outside the base). To obtain Command points, you must capture the enemy controlled zones (red zones on the map) or execute side missions. You also receive 3 command points for each zone you have under your control every 30 minutes."]];
player createDiaryRecord ["help", ["Attack Aircraft", "Disabled by default, this feature can be enabled in the mission lobby/unit selection screen's Parameters menu.<br/><br/>When enabled, the mission will auto-spawn both friendly and enemy AI controlled aircraft patrols. Be aware that each side's aircraft will only auto-spawn if a minimum of 150AP (army power) is maintained. If one of the side's AP falls below this level then the AP will need to be increased again back up to at least 150 before more aircraft can continue to spawn in (this has nothing to do with and does not effect player requested aircraft).<br/><br/>For FPS purposes, no more than 4 auto-spawned AI aircraft will be on the map at the same time."]];
player createDiaryRecord ["help", ["Army Power (AP)", "Army power represent the strenght of the BLUFOR forces present on the island. By capturing enemy positions and accomplishing side missions, you will add Army Power to your army. The attack waves of the BLUFOR army will become stronger."]];



// MP notification
if (isMultiplayer) then {
	[] spawn {
		waitUntil {time > 5};
		["info",["MP Mechanics","Check the manual for the specifics of the DUWS in MP"]] call bis_fnc_showNotification;
	};
};



		// create mission victory script //SPAWN BEGIN
		[] spawn {

		// CREATE MAIN OBJECTIVE
		capture_island_obj = player createSimpleTask ["taskIsland"];
		capture_island_obj setSimpleTaskDescription ["The ennemy is controlling the island, we must take it back! Capture every zone under enemy control and the mission will succeed.<br/>You can let your BLUFOR forces take the island by themselves and help them getting a bigger army by accomplishing side missions. Or you can capture the zones yourself and do all the big work. As the campaign progress, the war will escalate and the armies will get stronger and start to use bigger guns.<br/>To capture a zone, you need to have more units inside the zone than the enemy.<br/><br/>It's up to you on how you want to play this.<br/>Good luck, soldier!","Take the island",""];

		// WAIT UNTIL ALL ZONES ARE CAPTURED
		waitUntil {sleep 1; amount_zones_created > 0};
		waitUntil {sleep 3; (zoneundercontrolblu >= amount_zones_created);}; // Toutes les zones sont captur?es
		persistent_stat_script_win = [] execVM "persistent\persistent_stats_win.sqf";
		["TaskSucceeded",["","Island captured!"]] call bis_fnc_showNotification;
		capture_island_obj setTaskState "Succeeded";
		sleep 3;
		["island_captured_win",true,true] call BIS_fnc_endMission;

		};  // -- END OF SPAWN




if (zones_manually_placed) then {
waitUntil {!isNil ("Array_of_OPFOR_zones")};
sleep 1;
_warcom_init = [Array_of_OPFOR_zones, getpos hq_blu1, [0,0,0], blufor_ap, opfor_ap, 900,blufor_ai_skill,opfor_ai_skill, 900] execVM "WARCOM\WARCOM_init.sqf";
};



if (mission_DUWS_firstlaunch) then {
waitUntil {chosen_settings};
sleep 8;
["info",["Buying troops","Go talk to your commander to buy troops and vehicles with CP"]] call bis_fnc_showNotification;
sleep 2.5;
["info",["Command points","Acquire more CP by capturing enemy areas or accomplishing side missions"]] call bis_fnc_showNotification;

sleep 15;
["info",["RESTING AND HEALING","Save the game and heal by resting at the base"]] call bis_fnc_showNotification;

sleep 15;
// SITREP
["sitrepinfo",["SITREP","You can also save the game by giving a SITREP"]] call bis_fnc_showNotification;
sleep 2;

sleep 20;
["info",["DUWS Manual","Check the manual in the briefing for more info"]] call bis_fnc_showNotification;

profileNamespace setVariable ["profile_DUWS_firstlaunch", false];
saveProfileNamespace;
};

//Cleanup unused players.
for[{_x = 2},{_x <= 12},{_x = _x + 1}] do
{
	_thePlayer = missionNamespace getVariable format["player%1", _x];
	if(!isNil("_thePlayer")) then
	{
		if(!isPlayer _thePlayer) then
		{
			deleteVehicle _thePlayer;
		};
	};
};

trk = ["player"] execVM 'player_markers.sqf';

BOMBCODE1 = [];
[] call compile preprocessfilelinenumbers "cp_ehkilled.sqf";
[] call compile preprocessfilelinenumbers "protectofficer.sqf";
[] call compile preprocessfilelinenumbers "missions\missions\roulette\deathhint.sqf";


waitUntil {!isNil "hq_blu1"};
waitUntil {!isNil "protect_officer"};
hq_blu1 addeventhandler ["firednear", {_this call protect_officer}];
execVM "grenadeStop.sqf";

_satcom1 = [] execVM "pxs_satcom_a3\init_satellite.sqf";
execVM "R3F_LOG\init.sqf";

if (isServer) then {
supportreinit = addMissionEventHandler ["loaded",{[] execVM "supports_reinit.sqf"}];
};

////////////////INIT NO MOVING WITH FASTTRAVEL///////////////////////////////////////
fn_enableSimulation = {(_this select 0) enableSimulation (_this select 1)};

////////////////////////////////////////////////////////////////////////////////////
