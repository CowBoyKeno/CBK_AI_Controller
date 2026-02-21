Config = {}

--[[
    ███████╗██╗██╗   ██╗███████╗███╗   ███╗     █████╗ ██╗    ███╗   ██╗██████╗  ██████╗
    ██╔════╝██║██║   ██║██╔════╝████╗ ████║    ██╔══██╗██║    ████╗  ██║██╔══██╗██╔════╝
    █████╗  ██║██║   ██║█████╗  ██╔████╔██║    ███████║██║    ██╔██╗ ██║██████╔╝██║     
    ██╔══╝  ██║╚██╗ ██╔╝██╔══╝  ██║╚██╔╝██║    ██╔══██║██║    ██║╚██╗██║██╔═══╝ ██║     
    ██║     ██║ ╚████╔╝ ███████╗██║ ╚═╝ ██║    ██║  ██║██║    ██║ ╚████║██║     ╚██████╗
    ╚═╝     ╚═╝  ╚═══╝  ╚══════╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚═╝    ╚═╝  ╚═══╝╚═╝      ╚═════╝
    
    Complete AI/NPC Controller Configuration
    Full control over all NPC behavior on your FiveM server
    Perfect for RP servers and all server types
]]

-- =============================================================================
-- GENERAL NPC SETTINGS
-- =============================================================================

-- Enable/Disable all AI NPCs
Config.EnableNPCs = true -- Enable or disable all NPCs on the server

-- NPC Population Density (0.0 = no NPCs, 1.0 = maximum NPCs)
Config.PopulationDensity = {
    enabled = true,             -- Enable population density control
    pedDensity = 0.5,          -- Pedestrian density (0.0-1.0) - Lower = fewer peds
    vehicleDensity = 0.5,      -- Vehicle density (0.0-1.0) - Lower = fewer vehicles
    parkedVehicleDensity = 0.5, -- Parked vehicle density (0.0-1.0)
    scenarioPedDensity = 0.5,   -- Scenario peds (e.g., vendors, homeless) density (0.0-1.0)
}

-- =============================================================================
-- NPC SPAWN CONTROL
-- =============================================================================

Config.SpawnControl = {
    enabled = true,                    -- Enable spawn control
    disablePedSpawn = false,          -- Completely disable ped spawning
    disableVehicleSpawn = false,      -- Completely disable vehicle spawning
    disableParkedVehicles = false,    -- Disable parked vehicles
    disableScenarioPeds = false,      -- Disable scenario peds (vendors, etc.)
    disableAmbientPeds = false,       -- Disable ambient peds
    disableRandomPeds = false,        -- Disable random peds
}

-- =============================================================================
-- NPC BEHAVIOR SETTINGS
-- =============================================================================

Config.NPCBehavior = {
    -- NPC Reactions to Player
    ignorePlayer = false,              -- NPCs completely ignore player presence
    fleeFromPlayer = false,            -- NPCs flee when player approaches
    panicFromGunfire = true,          -- NPCs panic when they hear gunfire
    reactToExplosions = true,         -- NPCs react to explosions
    
    -- NPC Combat Behavior
    disableNPCWeapons = false,        -- Prevent NPCs from using weapons
    disableNPCCombat = false,         -- Disable all NPC combat ability
    npcAccuracy = 0.1,                -- NPC weapon accuracy (0.0-1.0)
    npcShootRate = 100,               -- NPC shoot rate (lower = faster)
    
    -- NPC Driving Behavior
    disableNPCDriving = false,        -- Prevent NPCs from driving
    npcDrivingStyle = 'normal',       -- Options: 'normal', 'careful', 'reckless', 'ignored'
    respectTrafficLights = true,      -- NPCs respect traffic lights
    useHorn = true,                   -- NPCs use vehicle horn
    avoidTraffic = true,             -- NPCs try to avoid traffic
    
    -- NPC Interaction
    allowPlayerMelee = true,          -- Allow player to melee NPCs
    npcCanRagdoll = true,            -- NPCs can ragdoll when hit
    npcCanBeKnockedOffBike = true,   -- NPCs can be knocked off bikes
}

-- =============================================================================
-- JOB-BASED NPC BEHAVIOR (RP SERVER FEATURES)
-- =============================================================================

Config.JobRespect = {
    enabled = true,                   -- Enable job-based NPC behavior
    
    -- Police Jobs - NPCs respect and cooperate with police
    policeJobs = {
        'police',
        'sheriff',
        'state',
        'trooper',
    },
    policeSettings = {
        npcsRespectPolice = true,     -- NPCs move aside for police
        npcsStopForPolice = true,     -- NPCs stop when police signal
        npcsFearPolice = true,        -- NPCs fear police presence
        reducedAggression = true,     -- NPCs less aggressive near police
        npcsCallPolice = true,        -- NPCs call police when witnessing crimes
    },
    
    -- Medical Jobs - NPCs cooperate with medical personnel
    medicalJobs = {
        'ambulance',
        'ems',
        'medic',
        'doctor',
    },
    medicalSettings = {
        npcsRespectMedical = true,    -- NPCs move aside for medical
        npcsStopForMedical = true,    -- NPCs stop for medical vehicles
        npcsSeekHelp = true,          -- Injured NPCs seek medical help
    },
    
    -- Fire Department - NPCs react to firefighters
    firefighterJobs = {
        'fire',
        'firefighter',
    },
    firefighterSettings = {
        npcsRespectFire = true,       -- NPCs move aside for fire dept
        npcsEvacuate = true,          -- NPCs evacuate from fires
        npcsPanic = true,             -- NPCs panic near fires
    },
    
    -- Tow Truck Operators - NPCs interact with tow trucks
    towJobs = {
        'mechanic',
        'tow',
        'towtruck',
    },
    towSettings = {
        npcsRespectTow = true,        -- NPCs move aside for tow trucks
        npcsStopForTow = true,        -- NPCs stop when tow is working
    },
    
    -- Ignore Players (opposite of respect)
    ignorePlayers = false,            -- NPCs ignore all players regardless of job
    ignorePlayerJobs = {              -- Specific jobs that NPCs ignore
        -- 'civilian',
    },
}

-- =============================================================================
-- VEHICLE-SPECIFIC NPC SETTINGS
-- =============================================================================

Config.VehicleSettings = {
    -- Emergency Vehicles
    disablePoliceVehicles = false,    -- Disable police vehicle spawns
    disableAmbulanceVehicles = false, -- Disable ambulance spawns
    disableFiretruckVehicles = false, -- Disable fire truck spawns
    
    -- Vehicle Types
    disableBoats = false,             -- Disable boat spawns
    disablePlanes = false,            -- Disable plane spawns
    disableHelicopters = false,       -- Disable helicopter spawns
    disableTrains = false,            -- Disable trains
    
    -- Traffic Settings
    enableTraffic = true,             -- Enable vehicle traffic
    trafficDensity = 0.5,            -- Traffic density (0.0-1.0)
    maxVehicles = 100,               -- Maximum vehicles in world
    
    -- Vehicle Behavior
    vehiclesRespectLights = true,    -- Vehicles respect traffic lights
    vehiclesUseIndicators = true,    -- Vehicles use turn signals
    enableVehicleDamage = true,      -- Enable vehicle damage
    vehiclesAvoidPlayer = false,     -- Vehicles try to avoid player
    
    -- Emergency Vehicle Behavior (Realistic Traffic Response)
    emergencyVehicleBehavior = {
        enabled = true,              -- Enable emergency vehicle response behavior
        
        -- Slow Pass Behavior (for stopped emergency vehicles)
        slowPassEnabled = true,      -- NPCs pass stopped emergency vehicles slowly
        slowPassRadius = 30.0,       -- Detection radius for stopped emergency vehicles (meters)
        slowPassSpeed = 5.0,         -- Speed limit when passing (mph) - very slow and cautious
        
        -- Pull Over Behavior (for moving emergency vehicles)
        pullOverEnabled = true,      -- NPCs pull over for approaching emergency vehicles
        pullOverDistance = 50.0,     -- Distance to detect approaching emergency vehicles (meters)
        pullOverDuration = 8000,     -- How long NPCs stay pulled over (milliseconds)
        checkBehind = true,          -- Check for emergency vehicles behind
        checkFront = true,           -- Check for emergency vehicles in front
        
        -- Courtesy Behavior
        disableHornNearEmergency = true,  -- NPCs don't honk near emergency vehicles (Note: Not fully implemented - FiveM lacks horn control native)
        disableSpeechNearEmergency = true, -- NPCs stay quiet near emergency vehicles
        courtesyRadius = 40.0,       -- Radius for courtesy behavior (meters)
        
        -- Emergency Vehicle Detection
        detectPolice = true,         -- Respond to police vehicles
        detectAmbulance = true,      -- Respond to ambulances
        detectFiretruck = true,      -- Respond to fire trucks
        
        -- Advanced Settings
        requireSiren = true,         -- Only respond if emergency lights are on
        responseDelay = 500,         -- Delay before NPCs react (milliseconds) - realistic reaction time
    },
}

-- =============================================================================
-- SCENARIO AND AMBIENT SETTINGS
-- =============================================================================

Config.ScenarioSettings = {
    -- Ambient Scenarios (NPCs performing actions)
    disableAllScenarios = false,      -- Disable all ambient scenarios
    
    -- Specific Scenarios
    disableCops = false,              -- Disable cop scenarios
    disableParamedics = false,        -- Disable paramedic scenarios
    disableFiremen = false,           -- Disable fireman scenarios
    disableVendors = false,           -- Disable vendor scenarios
    disableBeggars = false,           -- Disable beggar scenarios
    disableBuskers = false,           -- Disable street performer scenarios
    disableHookers = false,           -- Disable prostitute scenarios
    disableDealer = false,            -- Disable drug dealer scenarios
    
    -- Gang/Crime Scenarios
    disableGangMembers = false,       -- Disable gang member spawns
    disableCrimeScenarios = false,    -- Disable crime scenarios
    
    -- Animal Spawns
    disableAnimals = false,           -- Disable all animal spawns
    disableBirds = false,            -- Disable birds
    disableFish = false,             -- Disable fish
    disableSeagulls = false,         -- Disable seagulls
}

-- =============================================================================
-- TIME-BASED SETTINGS
-- =============================================================================

Config.TimeBasedSettings = {
    enabled = false,                  -- Enable time-based NPC control
    
    -- Daytime settings (6:00 AM - 6:00 PM)
    daySettings = {
        pedDensity = 0.7,
        vehicleDensity = 0.7,
        enableScenarios = true,
    },
    
    -- Nighttime settings (6:00 PM - 6:00 AM)
    nightSettings = {
        pedDensity = 0.3,
        vehicleDensity = 0.4,
        enableScenarios = false,
    },
}

-- =============================================================================
-- ZONE-BASED SETTINGS
-- =============================================================================

Config.ZoneSettings = {
    enabled = false,                  -- Enable zone-based NPC control
    
    zones = {
        -- Example: City center with high density
        {
            name = "City Center",
            coords = vector3(-234.14, -877.87, 30.49),
            radius = 500.0,
            pedDensity = 0.8,
            vehicleDensity = 0.8,
        },
        -- Example: Industrial area with low density
        {
            name = "Industrial",
            coords = vector3(1010.84, -2402.28, 30.50),
            radius = 400.0,
            pedDensity = 0.2,
            vehicleDensity = 0.3,
        },
    },
}

-- =============================================================================
-- WANTED SYSTEM INTERACTION
-- =============================================================================

Config.WantedSystem = {
    disableWantedLevel = true,        -- Disable player wanted level
    disablePoliceResponse = false,    -- Disable police response to crimes
    disablePoliceScanner = false,     -- Disable police scanner/dispatch
    disablePoliceHelicopters = true,  -- Disable police helicopters
    disablePoliceChase = false,       -- Disable police chasing player
    maxWantedLevel = 5,              -- Maximum wanted level (0-5)
    
    -- Crime Detection
    npcReportCrimes = true,          -- NPCs report crimes they witness
    npcReportVehicleTheft = true,    -- NPCs report stolen vehicles
    npcReportAssault = true,         -- NPCs report assault
    npcReportShooting = true,        -- NPCs report shootings
}

-- =============================================================================
-- RELATIONSHIP SETTINGS
-- =============================================================================

Config.Relationships = {
    -- Define how NPCs interact with each other
    enabled = true,
    
    -- Relationship types:
    -- 0 = Companion, 1 = Respect, 2 = Like, 3 = Neutral, 4 = Dislike, 5 = Hate
    
    playerToNPC = 3,                 -- How NPCs see player (default: neutral)
    npcToPlayer = 3,                 -- How player is seen by NPCs (default: neutral)
    npcToNPC = 3,                    -- How NPCs see each other (default: neutral)
    
    -- Specific group relationships
    copsToPlayer = 3,                -- Police relationship to player
    gangsToPlayer = 4,               -- Gang relationship to player
    copsToGangs = 5,                 -- Police relationship to gangs
}

-- =============================================================================
-- ADVANCED SETTINGS
-- =============================================================================

Config.Advanced = {
    -- Performance
    updateInterval = 1000,           -- How often to update NPC settings (ms)
    maxNPCDistance = 500.0,         -- Maximum distance to manage NPCs (meters)
    
    -- Cleanup
    autoCleanupEnabled = true,       -- Auto cleanup distant NPCs
    cleanupDistance = 1000.0,        -- Distance to cleanup NPCs (meters)
    cleanupInterval = 60000,         -- Cleanup check interval (ms)
    
    -- Suppression (prevent specific spawn types)
    suppressionLevel = 'medium',     -- Options: 'none', 'low', 'medium', 'high', 'maximum'
    
    -- Debug
    debug = false,                   -- Enable debug logging
    showNPCCount = false,           -- Show NPC count in console
}

-- =============================================================================
-- BLACKLIST/WHITELIST
-- =============================================================================

Config.Blacklist = {
    enabled = false,                 -- Enable model blacklist
    models = {
        -- Add ped model hashes to blacklist from spawning
        -- Example: `a_m_y_business_01`
    },
}

Config.Whitelist = {
    enabled = false,                 -- Enable model whitelist (only these spawn)
    models = {
        -- Add ped model hashes to whitelist
        -- Only these models will spawn when enabled
    },
}

-- =============================================================================
-- CUSTOM EVENTS
-- =============================================================================

Config.Events = {
    enabled = true,                  -- Enable custom event triggers
    
    -- Triggers when player enters vehicle
    onPlayerEnterVehicle = true,     -- Trigger custom behavior
    
    -- Triggers when player exits vehicle
    onPlayerExitVehicle = true,      -- Trigger custom behavior
    
    -- Triggers when NPC spawns near player
    onNPCSpawn = true,               -- Trigger custom behavior
}

-- =============================================================================
-- COMPATIBILITY
-- =============================================================================

Config.Compatibility = {
    -- Enable compatibility with popular frameworks
    ESX = false,                     -- Enable ESX framework integration
    QBCore = false,                  -- Enable QBCore framework integration
    Qbox = false,                    -- Enable Qbox framework integration (QBCore fork)
    vRP = false,                     -- Enable vRP framework integration
    NDCore = false,                  -- Enable ND-core framework integration
    
    -- vRP Group to Job Mapping (customize for your server)
    vRPGroupMapping = {
        ["police"] = "police",
        ["ambulance"] = "ambulance",
        ["ems"] = "ambulance",
        ["fire"] = "fire",
        ["firefighter"] = "fire",
        ["mechanic"] = "mechanic",
    },
    
    -- Custom job detection
    customJobCheck = false,          -- Enable custom job detection function
}

-- =============================================================================
-- LOCALIZATION
-- =============================================================================

Config.Locale = {
    ['npc_controller_started'] = 'AI NPC Controller has been started',
    ['npc_controller_stopped'] = 'AI NPC Controller has been stopped',
    ['settings_updated'] = 'NPC settings have been updated',
    ['invalid_permission'] = 'You do not have permission to use this command',
}

-- =============================================================================
-- COMMANDS
-- =============================================================================

Config.Commands = {
    enabled = true,                  -- Enable admin commands
    
    -- Command to reload config
    reloadCommand = 'npcreload',     -- Command: /npcreload
    
    -- Command to toggle NPCs
    toggleCommand = 'npctoggle',     -- Command: /npctoggle
    
    -- Command to check NPC count
    countCommand = 'npccount',       -- Command: /npccount
    
    -- Command to clear NPCs
    clearCommand = 'npcclear',       -- Command: /npcclear
    
    -- Permission required (set to false for no permission check)
    requirePermission = true,
    -- Permission level can be:
    -- 'admin' - checks for any admin permission
    -- 'group.admin' - checks for admin group
    -- 'command.npccontrol' - checks for specific npccontrol permission
    -- Or any custom ACE permission string
    permissionLevel = 'admin',       -- Default permission level
}
