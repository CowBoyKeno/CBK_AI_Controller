# Example Configurations

This file contains ready-to-use configuration examples for different types of FiveM servers. Copy the relevant section into your `config.lua` file.

## Table of Contents
1. [RP Server Configuration](#rp-server-configuration)
2. [Racing Server Configuration](#racing-server-configuration)
3. [PvP/Deathmatch Server](#pvpdeathmatch-server)
4. [Drift/Stunt Server](#driftstunt-server)
5. [Roleplay - Heavy Traffic](#roleplay-heavy-traffic)
6. [Minimal NPCs (Performance)](#minimal-npcs-performance)
7. [Realistic City Life](#realistic-city-life)
8. [Empty Server (No NPCs)](#empty-server-no-npcs)
9. [Emergency Vehicle Behavior Example](#emergency-vehicle-behavior-example)

---

## RP Server Configuration

Balanced settings for roleplay servers with job-based NPC behavior.

```lua
-- General Settings
Config.EnableNPCs = true

-- Population Density
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.6,
    vehicleDensity = 0.6,
    parkedVehicleDensity = 0.5,
    scenarioPedDensity = 0.5,
}

-- Job Respect System (Enable for RP)
Config.JobRespect = {
    enabled = true,
    policeJobs = {'police', 'sheriff', 'state'},
    policeSettings = {
        npcsRespectPolice = true,
        npcsStopForPolice = true,
        npcsFearPolice = true,
        reducedAggression = true,
        npcsCallPolice = true,
    },
    medicalJobs = {'ambulance', 'ems', 'doctor'},
    medicalSettings = {
        npcsRespectMedical = true,
        npcsStopForMedical = true,
        npcsSeekHelp = true,
    },
}

-- Framework Integration
Config.Compatibility = {
    ESX = true,  -- or QBCore = true, Qbox = true, vRP = true, or NDCore = true
}

-- Wanted System
Config.WantedSystem = {
    disableWantedLevel = true,  -- Disable default wanted system
    disablePoliceResponse = true,  -- Use custom police scripts
}

-- Emergency Vehicle Behavior (Recommended for RP servers)
Config.VehicleSettings.emergencyVehicleBehavior = {
    enabled = true,
    slowPassEnabled = true,      -- NPCs pass stopped emergency vehicles slowly
    slowPassRadius = 30.0,
    slowPassSpeed = 5.0,
    pullOverEnabled = true,      -- NPCs pull over for emergency vehicles
    pullOverDistance = 50.0,
    pullOverDuration = 8000,
    disableHornNearEmergency = true,
    disableSpeechNearEmergency = true,
    detectPolice = true,
    detectAmbulance = true,
    detectFiretruck = true,
    requireSiren = true,
}
```

---

## Racing Server Configuration

Minimal NPCs for clear racing roads.

```lua
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.1,           -- Very few pedestrians
    vehicleDensity = 0.2,       -- Light traffic
    parkedVehicleDensity = 0.1, -- Few parked cars
    scenarioPedDensity = 0.0,   -- No scenario peds
}

Config.SpawnControl = {
    enabled = true,
    disableScenarioPeds = true,
    disableAmbientPeds = true,
}

Config.WantedSystem = {
    disableWantedLevel = true,
    disablePoliceResponse = true,
    disablePoliceHelicopters = true,
}

Config.NPCBehavior = {
    npcDrivingStyle = 'careful',  -- NPCs drive carefully
    respectTrafficLights = true,
}
```

---

## PvP/Deathmatch Server

Completely disable NPCs for pure PvP combat.

```lua
Config.EnableNPCs = false

-- All other settings are ignored when EnableNPCs = false
-- NPCs will be completely disabled
```

---

## Drift/Stunt Server

No NPCs at all for clean roads and parking lots.

```lua
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.0,
    vehicleDensity = 0.0,
    parkedVehicleDensity = 0.0,
    scenarioPedDensity = 0.0,
}

Config.SpawnControl = {
    enabled = true,
    disablePedSpawn = true,
    disableVehicleSpawn = true,
    disableParkedVehicles = true,
    disableScenarioPeds = true,
}
```

---

## Roleplay - Heavy Traffic

Busy city atmosphere with lots of NPCs and vehicles.

```lua
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.9,           -- Lots of pedestrians
    vehicleDensity = 0.9,       -- Heavy traffic
    parkedVehicleDensity = 0.8, -- Many parked cars
    scenarioPedDensity = 0.8,   -- Busy scenarios
}

Config.JobRespect = {
    enabled = true,
    -- Configure your job names here
}

Config.TimeBasedSettings = {
    enabled = true,
    daySettings = {
        pedDensity = 0.9,
        vehicleDensity = 0.9,
        enableScenarios = true,
    },
    nightSettings = {
        pedDensity = 0.4,      -- Less people at night
        vehicleDensity = 0.5,  -- Less traffic at night
        enableScenarios = false,
    },
}
```

---

## Minimal NPCs (Performance)

Low NPC count for servers with performance concerns.

```lua
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.2,
    vehicleDensity = 0.2,
    parkedVehicleDensity = 0.1,
    scenarioPedDensity = 0.1,
}

Config.Advanced = {
    updateInterval = 1000,
    maxNPCDistance = 300.0,      -- Reduced distance
    autoCleanupEnabled = true,
    cleanupDistance = 500.0,     -- More aggressive cleanup
    cleanupInterval = 30000,     -- Cleanup more frequently
}

Config.ScenarioSettings = {
    disableAllScenarios = true,  -- Disable all scenarios
}
```

---

## Realistic City Life

Balanced settings for immersive city roleplay with zone-based density.

```lua
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.7,
    vehicleDensity = 0.7,
    parkedVehicleDensity = 0.6,
    scenarioPedDensity = 0.6,
}

Config.ZoneSettings = {
    enabled = true,
    zones = {
        -- Downtown Los Santos - Busy
        {
            name = "Downtown",
            coords = vector3(-234.14, -877.87, 30.49),
            radius = 500.0,
            pedDensity = 0.9,
            vehicleDensity = 0.9,
        },
        -- Sandy Shores - Moderate
        {
            name = "Sandy Shores",
            coords = vector3(1859.26, 3700.87, 33.57),
            radius = 800.0,
            pedDensity = 0.3,
            vehicleDensity = 0.4,
        },
        -- Paleto Bay - Light
        {
            name = "Paleto Bay",
            coords = vector3(-246.72, 6333.86, 32.42),
            radius = 600.0,
            pedDensity = 0.4,
            vehicleDensity = 0.5,
        },
        -- Mount Chiliad - Minimal
        {
            name = "Mount Chiliad",
            coords = vector3(501.76, 5604.85, 797.91),
            radius = 1000.0,
            pedDensity = 0.0,
            vehicleDensity = 0.1,
        },
    },
}

Config.TimeBasedSettings = {
    enabled = true,
    daySettings = {
        pedDensity = 0.7,
        vehicleDensity = 0.7,
        enableScenarios = true,
    },
    nightSettings = {
        pedDensity = 0.3,
        vehicleDensity = 0.4,
        enableScenarios = true,
    },
}

Config.JobRespect = {
    enabled = true,
    policeJobs = {'police', 'sheriff', 'state'},
    policeSettings = {
        npcsRespectPolice = true,
        npcsStopForPolice = true,
        npcsFearPolice = true,
    },
    medicalJobs = {'ambulance', 'ems'},
    medicalSettings = {
        npcsRespectMedical = true,
        npcsStopForMedical = true,
    },
    firefighterJobs = {'fire'},
    firefighterSettings = {
        npcsRespectFire = true,
        npcsEvacuate = true,
    },
}
```

---

## Empty Server (No NPCs)

Completely empty world for screenshots, videos, or specific events.

```lua
Config.EnableNPCs = false

-- Alternative method (if you want more control):
Config.EnableNPCs = true

Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.0,
    vehicleDensity = 0.0,
    parkedVehicleDensity = 0.0,
    scenarioPedDensity = 0.0,
}

Config.SpawnControl = {
    enabled = true,
    disablePedSpawn = true,
    disableVehicleSpawn = true,
    disableParkedVehicles = true,
    disableScenarioPeds = true,
    disableAmbientPeds = true,
    disableRandomPeds = true,
}

Config.ScenarioSettings = {
    disableAllScenarios = true,
    disableAnimals = true,
    disableBirds = true,
}

Config.VehicleSettings = {
    enableTraffic = false,
    disablePoliceVehicles = true,
    disableAmbulanceVehicles = true,
    disableFiretruckVehicles = true,
}
```

---

## Emergency Vehicle Behavior Example

Enhanced realism for police, fire, and EMS roleplay with realistic traffic response.

```lua
-- Enable realistic emergency vehicle behavior
Config.VehicleSettings.emergencyVehicleBehavior = {
    enabled = true,
    
    -- Slow Pass Behavior
    -- NPCs will slow down to 5mph when passing stopped emergency vehicles
    slowPassEnabled = true,
    slowPassRadius = 30.0,       -- Detect stopped emergency vehicles within 30 meters
    slowPassSpeed = 5.0,         -- Pass at 5 mph (very slow and cautious)
    
    -- Pull Over Behavior
    -- NPCs will pull over when emergency vehicles approach with lights on
    pullOverEnabled = true,
    pullOverDistance = 50.0,     -- Detect approaching emergency vehicles 50 meters away
    pullOverDuration = 8000,     -- Stay pulled over for 8 seconds
    checkBehind = true,          -- Check for emergency vehicles behind
    checkFront = true,           -- Check for emergency vehicles in front
    
    -- Courtesy Behavior
    -- NPCs won't honk or talk near emergency vehicles
    disableHornNearEmergency = true,
    disableSpeechNearEmergency = true,
    courtesyRadius = 40.0,       -- Apply courtesy within 40 meters
    
    -- Detection Settings
    detectPolice = true,         -- Respond to police vehicles
    detectAmbulance = true,      -- Respond to ambulances
    detectFiretruck = true,      -- Respond to fire trucks
    requireSiren = true,         -- Only respond when lights are on
    responseDelay = 500,         -- Half-second realistic reaction time
}

-- Note: This works when YOU are driving an emergency vehicle with lights on
-- NPCs will automatically respond to your emergency vehicle
```

**How it works:**
1. Get in any emergency vehicle (police, ambulance, fire truck)
2. Turn on your emergency lights (default: E key)
3. NPCs will automatically:
   - Pull over when you approach from behind or in front
   - Pass you slowly and cautiously if you're stopped
   - Stop honking and talking when near you

**Perfect for:**
- Police roleplay servers
- EMS/medical roleplay
- Fire department roleplay
- Realistic traffic response scenarios

---

## How to Use These Examples

1. Open your `config.lua` file
2. Find the section you want to modify (e.g., `Config.PopulationDensity`)
3. Copy the corresponding section from the example above
4. Paste it into your `config.lua`, replacing the existing section
5. Save the file
6. Use `/npcreload` in-game or restart the resource

## Mixing Configurations

You can mix and match settings from different examples. For instance:
- Use the RP Server job settings
- Combined with Racing Server traffic density
- And add Time-Based Settings from Realistic City Life

The configuration is fully modular and all settings work together!

## Testing Your Configuration

After applying a new configuration:
1. Use `/npccount` to check the current NPC count
2. Observe if the density feels right for your server
3. Adjust the values up or down in increments of 0.1
4. Use `/npcreload` to test changes without restarting

## Need Help?

- Start with the closest example to your server type
- Make small adjustments (0.1-0.2 changes)
- Test thoroughly with your player base
- Check server performance with different settings

For more details, see the main [README.md](README.md) and [INSTALLATION.md](INSTALLATION.md) files.
