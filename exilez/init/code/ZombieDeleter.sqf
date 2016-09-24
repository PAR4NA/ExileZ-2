// ExileZ 2.0 by Patrix87 of http:\\multi-jeux.quebec //

private ["_device","_zombie","_zombiePos","_zombieClass","_distanceDeath","_distance","_radius","_avoidTerritory","_flags"];

_zombie = _this select 0;
_avoidTerritory = _this select 1;
_zombieClass = typeOf _zombie;
_distanceDeath = false;

while {alive _zombie} do {
	sleep MaxTime;
	_zombiePos = getPos _zombie;

    // is position in range of a player?
    if!([_zombiePos, MaxSpawnDistance] call ExileClient_util_world_isAlivePlayerInRange) then
	{
		// are other non zombie AI in range?
		_nearEASTAI 	= { side _x == EAST AND _x distance _zombiePos < MaxSpawnDistance } count allUnits;
		_nearCIVAI 		= { side _x == CIVILIAN AND _x distance _zombiePos < MaxSpawnDistance } count allUnits;
		_nearAICount 	= _nearEASTAI + _nearCIVAI;
		if(_nearAICount == 0) then
		{ 
			_zombie setdamage 1;
			sleep 5;
			deleteVehicle _zombie;
			_distanceDeath = true;			
		}; 			
	};

	//check for flags
	if (RemoveZfromTerritory && _avoidTerritory && alive _zombie)then
	{
		//Check if near player territory
		_nearBase = (nearestObjects [_zombiePos,["Exile_Construction_Flag_Static"],MaxTerritoryRange]) select 0;
		if (!isNil "_nearBase" && _avoidTerritory) then
		{
			_zombie setdamage 1;
			sleep 5;
			deleteVehicle _zombie;
			_distanceDeath = true;
		};
	};
	//Check for the device
	if (alive _zombie)then
	{
		_device = _zombiePos nearObjects ["Land_Device_assembled_F", 30];
		{
			_distance = (getPosATL _x) distance _zombiePos;
			if (_distance <= 30) exitWith 
			{
				_zombie setdamage 1;
				sleep 10;
				deleteVehicle _zombie;
				_distanceDeath = true;
			};
		}forEach _device;
	};
	//Check for the Donkey punched device
	if (alive _zombie)then
	{
		_device = _zombiePos nearObjects ["DP_Land_Device_assembled_F", 30];
		{
			_distance = (getPosATL _x) distance _zombiePos;
			if (_distance <= 30) exitWith 
			{
				_zombie setdamage 1;
				sleep 10;
				deleteVehicle _zombie;
				_distanceDeath = true;
			};
		}forEach _device;
	};
	//Check for the mobile device
	if (alive _zombie)then
	{
		_device = _zombiePos nearObjects ["O_Truck_03_device_F", 30];
		{
			_distance = (getPosATL _x) distance _zombiePos;
			if (_distance <= 30) exitWith 
			{
				_zombie setdamage 1;
				sleep 10;
				deleteVehicle _zombie;
				_distanceDeath = true;
			};
		}forEach _device;
	};
};

if !(_distanceDeath) then 
{
	sleep CorpseDeleteDelay;
	deleteVehicle _zombie;
};

if (Debug) then {
	diag_log format["ExileZ 2.0: Removing 1 Zombie	|	Position : %1	|	Class : %2",_zombiePos,_zombieClass];
};
