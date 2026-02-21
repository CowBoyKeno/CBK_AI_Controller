# FiveM AI NPC Controller

A comprehensive AI/NPC controller for FiveM servers that gives server owners complete control over all NPC behavior, spawning, and interactions. Perfect for RP servers and all server types.

## 🌟 Features

### Complete NPC Control
- **Population Density Control**: Adjust pedestrian, vehicle, and parked vehicle density independently
- **Spawn Management**: Enable/disable specific NPC types (peds, vehicles, scenarios, etc.)
- **Behavior Settings**: Control how NPCs react to players, gunfire, explosions, and more
- **Combat Control**: Adjust NPC weapon accuracy, combat ability, and aggression

### Job-Based NPC Behavior (Perfect for RP Servers)
NPCs will respect and interact differently with players based on their job:

- **Police Jobs**: NPCs move aside, stop when signaled, fear police presence, report crimes
- **Medical Jobs**: NPCs cooperate, stop for ambulances, seek medical help when injured
- **Fire Department**: NPCs evacuate from fires, panic appropriately, move aside for fire trucks
- **Tow Truck Operators**: NPCs respect tow trucks and stop when tow is working

### Emergency Vehicle Behavior (NEW!)
Realistic traffic response to emergency vehicles with lights activated:

- **Slow Pass**: NPCs pass stopped emergency vehicles slowly and cautiously
- **Pull Over**: NPCs pull over when emergency vehicles approach from behind or in front
- **Courtesy Behavior**: NPCs stop talking when near emergency vehicles with lights on (horn control not available in FiveM)
- **Configurable Detection**: Set detection radius, response speeds, and pull-over duration

### Advanced Features
- **Vehicle-Specific Controls**: Manage police cars, ambulances, fire trucks, boats, planes, helicopters
- **Scenario Management**: Control vendors, beggars, gang members, and all ambient scenarios
- **Time-Based Settings**: Different NPC density for day/night cycles
- **Zone-Based Settings**: Customize NPC behavior in specific areas
- **Wanted System Control**: Full control over police response and wanted levels
- **Relationship System**: Define how NPCs interact with each other and players
- **Auto-Cleanup**: Automatically remove distant NPCs for performance
- **Framework Integration**: Built-in support for ESX, QBCore, Qbox, vRP, and ND-core

## 📦 Installation

1. Download the resource
2. Place it in your server's `resources` folder
3. Add `ensure FiveM_AI_Controller` to your `server.cfg`
4. Configure the settings in `config.lua`
5. Restart your server

## ⚙️ Configuration

All settings are in `config.lua` with detailed descriptions. Here are the main sections:

### General NPC Settings
```lua
Config.EnableNPCs = true -- Master toggle for all NPCs
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.5,          -- 0.0 = no peds, 1.0 = maximum
    vehicleDensity = 0.5,      -- 0.0 = no vehicles, 1.0 = maximum
    parkedVehicleDensity = 0.5,
    scenarioPedDensity = 0.5,
}
```

### Job-Based Behavior
```lua
Config.JobRespect = {
    enabled = true,
    policeJobs = {'police', 'sheriff', 'state', 'trooper'},
    policeSettings = {
        npcsRespectPolice = true,
        npcsStopForPolice = true,
        npcsFearPolice = true,
        reducedAggression = true,
        npcsCallPolice = true,
    },
    -- Similar settings for medical, firefighter, and tow jobs
}
```

### NPC Behavior
```lua
Config.NPCBehavior = {
    ignorePlayer = false,           -- NPCs ignore player completely
    fleeFromPlayer = false,         -- NPCs run away from player
    panicFromGunfire = true,       -- NPCs panic when shots fired
    disableNPCWeapons = false,     -- Prevent NPCs from using weapons
    npcDrivingStyle = 'normal',    -- 'normal', 'careful', 'reckless'
    respectTrafficLights = true,   -- NPCs obey traffic lights
}
```

### Emergency Vehicle Behavior
```lua
Config.VehicleSettings.emergencyVehicleBehavior = {
    enabled = true,              -- Enable emergency vehicle response behavior
    
    -- Slow Pass (stopped emergency vehicles)
    slowPassEnabled = true,      -- NPCs pass stopped emergency vehicles slowly
    slowPassRadius = 30.0,       -- Detection radius (meters)
    slowPassSpeed = 5.0,         -- Speed limit when passing (mph)
    
    -- Pull Over (moving emergency vehicles)
    pullOverEnabled = true,      -- NPCs pull over for approaching emergency vehicles
    pullOverDistance = 50.0,     -- Detection distance (meters)
    pullOverDuration = 8000,     -- How long to stay pulled over (ms)
    checkBehind = true,          -- Check for emergency vehicles behind
    checkFront = true,           -- Check for emergency vehicles in front
    
    -- Courtesy Behavior
    disableHornNearEmergency = true,  -- NPCs don't honk near emergency vehicles (Not implemented - FiveM limitation)
    disableSpeechNearEmergency = true, -- NPCs stay quiet near emergency vehicles
    courtesyRadius = 40.0,       -- Radius for courtesy behavior (meters)
    
    -- Detection Settings
    detectPolice = true,         -- Respond to police vehicles
    detectAmbulance = true,      -- Respond to ambulances
    detectFiretruck = true,      -- Respond to fire trucks
    requireSiren = true,         -- Only respond if emergency lights are on
}
```

### Vehicle Settings
```lua
Config.VehicleSettings = {
    disablePoliceVehicles = false,
    disableAmbulanceVehicles = false,
    disableFiretruckVehicles = false,
    disableBoats = false,
    disablePlanes = false,
    disableHelicopters = false,
    enableTraffic = true,
    trafficDensity = 0.5,
}
```

### Wanted System
```lua
Config.WantedSystem = {
    disableWantedLevel = true,      -- Disable player wanted level
    disablePoliceResponse = false,   -- Disable police chasing player
    disablePoliceHelicopters = true, -- No police helis
    maxWantedLevel = 5,             -- Maximum wanted level (0-5)
}
```

## 🎮 Commands

All commands require admin permission by default (configurable in `config.lua`):

- `/npcreload` - Reload the configuration
- `/npctoggle` - Toggle NPCs on/off
- `/npcclear` - Clear all NPCs from the world
- `/npccount` - Show current NPC and vehicle count

## 🔌 Framework Integration

### ESX
```lua
Config.Compatibility.ESX = true
```

### QBCore
```lua
Config.Compatibility.QBCore = true
```

### Qbox
```lua
Config.Compatibility.Qbox = true
```

### vRP
```lua
Config.Compatibility.vRP = true

-- Customize vRP group to job mapping
Config.Compatibility.vRPGroupMapping = {
    ["police"] = "police",
    ["ambulance"] = "ambulance",
    ["ems"] = "ambulance",
    ["fire"] = "fire",
    ["firefighter"] = "fire",
    ["mechanic"] = "mechanic",
}
```

### ND-core
```lua
Config.Compatibility.NDCore = true
```

The script will automatically detect player jobs from your framework and apply appropriate NPC behaviors.

## 🔧 Exports

### Client-Side Exports
```lua
-- Get current configuration
local config = exports['FiveM_AI_Controller']:GetConfig()

-- Get player's current job
local job = exports['FiveM_AI_Controller']:GetPlayerJob()

-- Set player job manually
exports['FiveM_AI_Controller']:SetPlayerJob('police')
```

### Server-Side Exports
```lua
-- Get current configuration
local config = exports['FiveM_AI_Controller']:GetConfig()

-- Update configuration
exports['FiveM_AI_Controller']:SetConfig(newConfig)

-- Get player's job
local job = exports['FiveM_AI_Controller']:GetPlayerJob(source)
```

## 📊 Performance

The script is optimized for performance with:
- Configurable update intervals
- Auto-cleanup of distant NPCs
- Efficient distance checks
- Minimal resource usage

Default settings provide good performance on most servers. Adjust `Config.Advanced` settings for your specific needs:

```lua
Config.Advanced = {
    updateInterval = 1000,      -- Update frequency (ms)
    maxNPCDistance = 500.0,    -- Max distance to manage NPCs
    autoCleanupEnabled = true,  -- Auto cleanup distant NPCs
    cleanupDistance = 1000.0,   -- Cleanup distance
    cleanupInterval = 60000,    -- Cleanup check interval (ms)
}
```

## 🎯 Use Cases

### RP Server Setup
- Enable job-based NPC behavior for realistic interactions
- Reduce NPC density for better performance
- Configure NPCs to respect emergency services
- Disable wanted system for custom police scripts

### Racing Server
- Disable all NPCs for clear roads
- Or reduce density to 0.2 for light traffic

### Freeroam Server
- Enable all NPCs for populated world
- Disable wanted system
- Configure NPCs to ignore players

### PvP Server
- Disable NPCs completely for pure PvP
- Or enable them with hostile settings

## 🛠️ Customization

Every aspect of NPC behavior is customizable through `config.lua`. All settings include descriptions and can be toggled on/off independently.

### Example: Disable All NPCs at Night
```lua
Config.TimeBasedSettings = {
    enabled = true,
    nightSettings = {
        pedDensity = 0.0,      -- No peds at night
        vehicleDensity = 0.2,   -- Light traffic
        enableScenarios = false,
    },
}
```

### Example: High Density City Center
```lua
Config.ZoneSettings = {
    enabled = true,
    zones = {
        {
            name = "Downtown",
            coords = vector3(-234.14, -877.87, 30.49),
            radius = 500.0,
            pedDensity = 0.9,    -- Lots of people
            vehicleDensity = 0.9, -- Heavy traffic
        },
    },
}
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

If you encounter any issues or have questions, please open an issue on GitHub.

## 🔄 Updates

### Version 1.0.0
- Initial release
- Complete NPC control system
- Job-based NPC behavior
- Framework integration (ESX, QBCore, Qbox, vRP, ND-core)
- Comprehensive configuration options
- Admin commands
- Performance optimization

## ⭐ Credits

Created by ArmA3Cowboy

---

**Note**: This is a standalone resource and does not require any dependencies, though it integrates seamlessly with popular frameworks when enabled.
