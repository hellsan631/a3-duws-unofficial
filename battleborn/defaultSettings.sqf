//BATTLEBORN Damage Modeling System
//Enables Battleborn's Damage modeling system
BATTLE_DAMAGE_MODENABLE = 1;
BATTLE_DAMAGE_MODENABLEAI = 2; 		//2 means a stablization of damage instead of using the damage system overhaul
BATTLE_DAMAGE_AGMSUPPORT = 1;
BATTLE_DAMAGE_AGMSUPPORTAI = 0;
BATTLE_DAMAGE_AGMHPENABLE = 35;		//HP to enable AGM support/effects

//Damage System Settings
BATTLE_DAMAGE_MULTIPLIER_PLAYER = 3;  //Amount of damage a unit takes per bullet
BATTLE_DAMAGE_MULTIPLIER_AI = 3;
BATTLE_DAMAGE_HP_PLAYER = 100;		//Amount of HP a player has in the system
BATTLE_DAMAGE_HP_AI = 100;
BATTLE_DAMAGE_MISS_PLAYER = 25;		//A chance for a bullet that hits to be dodged
BATTLE_DAMAGE_MISS_AI = 0;
BATTLE_DAMAGE_HITCURVE_PLAYER = 1;	//Curves the damage for players based on number of hits. Less hits = less damage.
BATTLE_DAMAGE_HEADSHOTSOUND = 1;
/////////////////////////////////////////////////////


//BATTLEBORN NightVision Effect System
//Adds some visual effects when NVG's are enabled.
BATTLE_NV_MODENABLE = 1;
BATTLE_NV_ADVANCEDEFFECTS = 0; //0 = none, 1 = film gain only, 2 = film gain and blur
BATTLE_NV_ENABLESOUND = 1;
/////////////////////////////////////////////////////


//BATTLEBORN Misc Items
//Random Settings
BATTLE_INSIGNIA = 1; //places praxus insignia on player units on spawn
BATTLE_KNIFE = 1;
BATTLE_KNIFEDISTANCE = 3;
BATTLE_FATIGUE = 1;
BATTLE_FATIGUEDECAY = 0.15; //higher numbers means fatigue decays more. this represents decay every 5 seconds
BATTLE_MEDICAL = 1;
BATTLE_DELETERESPAWNCORPSE = 1;
BATTLE_SAVERESPAWNLOADOUT = 1;
BATTLE_REMOVENVG_AI = 1;
BATTLE_FORCEFLASHLIGHTUSE_AI = 1;
BATTLE_CLEANUP = 0;
BATTLE_FLIPVEHICLE = 1;
BATTLE_MAPMARKERS = 1;
BATTLE_JUMP = 1;
BATTLE_FASTROPE = 1;
BATTLE_FIELDREPAIR = 1;
BATTLE_DYNAMIC_WEATHER = 1;
BATTLE_TIMEACCELERATION = 1;
BATTLE_TIMEACCELERATION_FACTOR = 24;
/////////////////////////////////////////////////////
