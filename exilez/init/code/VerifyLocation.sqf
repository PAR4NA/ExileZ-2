// ExileZ 2.0 by Patrix87 of http:\\multi-jeux.quebec
// modified by second_coming 

// Verify validity of spawning location
//_validLocation = [_triggerPosition,_avoidTerritory,false] call VerifyLocation;
// Return True if valid

_ignorePlayer 		= false;
_position 			= _this select 0;
_avoidTerritory 	= _this select 1;
_safeDistance 		= 500;
_validLocation 		= true;

if (count _this == 3) then {
	_ignorePlayer = _this select 2;
};



if(_validLocation) then
{
	// Check if empty
	if ((count _position) == 0) exitwith { _validLocation = false; };
	
    // is position in range of a trader zone?
    if([_position, _safeDistance] call ExileClient_util_world_isTraderZoneInRange) exitwith { _validLocation = false; };
	
	// Check for water	
	if (surfaceIsWater _position) exitwith {_validLocation = false;};

    //Check if near player territory
    private _nearBase = (nearestObjects [_position,["Exile_Construction_Flag_Static"],_safeDistance]) select 0;
    if (!isNil "_nearBase" && _avoidTerritory) exitwith { _validLocation = false;  };	
	
    // is position in range of a player?
    if([_position, MaxSpawnDistance] call ExileClient_util_world_isAlivePlayerInRange) exitwith { _validLocation = true; }; 

	// are other non zombie AI in range?
	private _nearEASTAI 	= { side _x == EAST AND _x distance _position < MaxSpawnDistance } count allUnits;
	private _nearCIVAI 		= { side _x == CIVILIAN AND _x distance _position < MaxSpawnDistance } count allUnits;
	private _nearAICount 	= _nearEASTAI + _nearCIVAI;
	if(_nearAICount > 0) exitwith { _validLocation = true; }; 
			
};

// return
_validLocation;