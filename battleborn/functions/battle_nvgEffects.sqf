if (isDedicated) exitWith {};
if (player != player) then {waitUntil {player == player};};

private ["_zoomintensity", "_ppBlur", "_ppRim", "_ppFilm", "_ppColor", "_nvOn", "_nvOff", "_halogen"];

// Figures out how zoomed in you are (KillzoneKid is Awesome)
KK_fnc_getZoom  = compile preprocessFileLineNumbers (functionLocation + "battle_nvgEffects\fnc_getZoom.sqf");

_nvOn = soundLocation + "nv_on.ogg";
_nvOff = soundLocation + "nv_off.ogg";
_halogen = soundLocation + "halogen.ogg";

while {true} do {

     // Adds Effects When NV Enabled
    waitUntil {((vehicle player) == player) && ((currentVisionMode player) == 1)};

    // Effects below. If you wanna know what this stuff means so you can change the effects, go to https://community.bistudio.com/wiki/Post_process_effects
    // Effect modifiers that change based on range like overall blur and film grain size are further down

    playSound3D [_nvOn, player, false, getPosATL player, 1, 1, 10];

    if(BATTLE_NV_ADVANCEDEFFECTS == 2) then {
        // Dynamic Blur
        _ppBlur = ppEffectCreate ["dynamicBlur", 500];
        _ppBlur ppEffectAdjust [0.2];
        _ppBlur ppEffectCommit 0;
        _ppBlur ppEffectEnable true;
        _ppBlur ppEffectForceInNVG true;

        // Edge Blur
        _ppRim = ppEffectCreate ["RadialBlur", 250];
        _ppRim ppEffectAdjust [0.05, 0.05, 0.20, 0.28];
        _ppRim ppEffectCommit 0;
        _ppRim ppEffectEnable false;
        _ppRim ppEffectForceInNVG true;

    };

    if(BATTLE_NV_ADVANCEDEFFECTS >= 1) then {
        // Film Grain
        _ppFilm = ppEffectCreate ["FilmGrain", 2501];
        _ppFilm ppEffectAdjust [0.18, 1, 1, 0.4, 0.2, false];
        _ppFilm ppEffectEnable true;
        _ppFilm ppEffectForceInNVG true;
    };

    // Color and Contrast
    _ppColor = ppEffectCreate ["ColorCorrections", 1500];
    _ppColor ppEffectEnable true;
    _ppColor ppEffectAdjust [0.8, 0.8, -0.05, [0.4, 0.1, 0.4, 0.1], [0.3, 0.6, 0.5, 1], [0, 0, 0, 0]];
    _ppColor ppEffectCommit 0;
    _ppColor ppEffectForceInNVG true;

    //Forces the light from the sky to be a consistant value
    //setApertureNew [50, 10, 100, 750];
    setAperture 17;

    // Halogen-Sound
    if(BATTLE_NV_ENABLESOUND == 1) then {
        [] spawn {
            while {((currentVisionMode player) == 1)} do {
                playSound3D [_halogen, player, false, getPosATL player, 0.5, 1, 5];
                sleep 2;
            };
        };
    };


    waitUntil {
        // Scaling effects during Zooming
         _zoomintensity = (call KK_fnc_getZoom * 10) /30;

        if(BATTLE_NV_ADVANCEDEFFECTS > 1) then {
            _ppBlur ppEffectAdjust [0.05 + (_zoomIntensity * 0.045)];
            _ppBlur ppEffectCommit 0;
        };

        if(BATTLE_NV_ADVANCEDEFFECTS >= 1) then {
            _ppFilm ppEffectAdjust [0.18, 1, _zoomIntensity, 0.4, 0.2, false];
            _ppFilm ppEffectCommit 0;
        };

        //Removes Effects When NV Disabled
        ((vehicle player) != player) || ((currentVisionMode player) != 1)

    };

    playSound3D [_nvOff, player, false, getPosATL player, 1, 1, 110];

    if(BATTLE_NV_ADVANCEDEFFECTS > 1) then {
        ppEffectDestroy _ppBlur;
        ppEffectDestroy _ppRim;
    };

    if(BATTLE_NV_ADVANCEDEFFECTS >= 1) then {
        ppEffectDestroy _ppFilm;
    };

    ppEffectDestroy _ppColor;

    setAperture -1;
    //setApertureNew [-1, -1, -1, -1];
};
