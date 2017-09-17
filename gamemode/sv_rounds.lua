//Round states
WAITING_FOR_PLAYERS = 0;
STANDBY = 1;
IN_PROGRESS = 2;
LAST_SURVIVOR = 3;
ENDING = 4;

ROUND_STATE = WAITING_FOR_PLAYERS;

module("Round", package.seeall);

function GetState()
    return ROUND_STATE
end

//Start the round in standby mode.
function Start()
    //Check if the game is in a state where it's logical to start a new round
    if(ROUND_STATE == WAITING_FOR_PLAYERS || ROUND_STATE == ENDING) then
        PrintDebug("Round started, standby mode.", 1);
        //Start the round here
        //Silently killing everyone and respawning them as a neutral player.
        PrintDebug("Setting everyone as neutral, killing them, and respawning them. Loop starting", 1)
        for k,v in pairs(player.GetAll()) do
            player_manager.SetPlayerClass(v, "player_neutral");
            v:KillSilent();
            v:Spawn();
            PrintDebug(v:Name() .. " done.", 2)
        end
        PrintDebug("Loop done", 1);

        //Letting players walk around until standby mode is over
        timer.Simple(VIRUS.StandbyTime, function()
            PrintDebug("Beginning new round", 1);
            Begin();
        end)
    else
        print("WARNING : A round start has been triggered while the current state was in standby or progress. Check your code!")
    end
end

//Begin the round with a random infected
function Begin()
    //Pick a random neutral as our first infect.
    local neutrals = {};
    PrintDebug("Retrieving neutrals. Starting loop.", 1)
    for k,v in pairs(player.GetAll()) do
        PrintDebug("Checking " .. v:Name() .. "...", 2)
        if(player_manager.GetPlayerClass(v) == "player_neutral") then
            PrintDebug("Adding " .. v:Name(), 2)
            table.insert(neutrals, v);
        end
    end
    PrintDebug("Loop over. " .. table.Count(neutrals) .. " found.", 1)

    local firstInfected = table.Random(neutrals);
    PrintDebug(firstInfected:Name() .. " is the first infected. Setting to infected class.", 1);
end