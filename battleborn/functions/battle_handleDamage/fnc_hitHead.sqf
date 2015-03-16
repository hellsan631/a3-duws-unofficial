private ["_dm"];

_dm = _this select 0; //dmg

call {
	if (_dm <= 50) exitWith {	_dm = _dm / 1.15;	};
	if (_dm <= 75) exitWith {	_dm = _dm / 1.2;	};
	if (_dm <= 100) exitWith {	_dm = _dm / 1.25;	};
	if (_dm <= 150) exitWith {	_dm = _dm / 1.4;	};
	if (_dm <= 200) exitWith {	_dm = _dm / 1.5;	};
};

_dm = _dm * 1.1;

_dm