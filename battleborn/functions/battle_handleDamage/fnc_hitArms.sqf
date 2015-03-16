private ["_dm"];

_dm = _this select 0; //dmg

call {
	if (_dm <= 25) exitWith {	_dm = _dm / 1.2;	};
	if (_dm <= 50) exitWith {	_dm = _dm / 1.25;	};
	if (_dm <= 75) exitWith {	_dm = _dm / 1.3;	};
	if (_dm <= 100) exitWith {	_dm = _dm / 1.33;	};
	if (_dm <= 150) exitWith {	_dm = _dm / 3;		};
	if (_dm <= 200) exitWith {	_dm = _dm / 3.5;	};
	if (_dm <= 300) exitWith {	_dm = _dm / 4.0;	};
	if (_dm <= 400) exitWith {	_dm = _dm / 4.5;	};
	if (_dm <= 500) exitWith {	_dm = _dm / 5.0;	};
	if (_dm <= 600) exitWith {	_dm = _dm / 6.0;	};
};

_dm = _dm / 1.5;

_dm