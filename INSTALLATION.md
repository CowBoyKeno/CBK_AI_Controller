# Installation Guide

## Quick Start

### 1. Download and Install
1. Download the latest release or clone this repository
2. Place the `FiveM_AI_Controller` folder in your FiveM server's `resources` folder
3. Add `ensure FiveM_AI_Controller` to your `server.cfg` file
4. Restart your server

### 2. Basic Configuration

Open `config.lua` and adjust the basic settings:

```lua
-- Enable/Disable all NPCs
Config.EnableNPCs = true

-- Adjust population density (0.0 to 1.0)
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.5,       -- Pedestrians
    vehicleDensity = 0.5,   -- Vehicles
}
```

### 3. Framework Integration (Optional)

If you're using ESX, QBCore, Qbox, vRP, or ND-core, enable the appropriate framework:

```lua
Config.Compatibility = {
    ESX = true,      -- Set to true if using ESX
    QBCore = false,  -- Set to true if using QBCore
    Qbox = false,    -- Set to true if using Qbox
    vRP = false,     -- Set to true if using vRP
    NDCore = false,  -- Set to true if using ND-core
}
```

### 4. Configure Job-Based Behavior (For RP Servers)

```lua
Config.JobRespect = {
    enabled = true,  -- Enable job-based NPC behavior
    
    -- Add your police job names
    policeJobs = {
        'police',
        'sheriff',
        'state',
    },
    
    -- Configure how NPCs react to police
    policeSettings = {
        npcsRespectPolice = true,
        npcsStopForPolice = true,
        npcsFearPolice = true,
    },
}
```

### 5. Set Admin Permissions

By default, admin commands require ACE permissions. Add to your `server.cfg`:

```
add_ace group.admin command.npccontrol allow
```

Or disable permission checks in `config.lua`:

```lua
Config.Commands = {
    enabled = true,
    requirePermission = false,  -- Allow all players to use commands
}
```

## Common Configurations

### Configuration for Racing Servers
```lua
Config.EnableNPCs = true
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.1,        -- Very few peds
    vehicleDensity = 0.2,    -- Light traffic
    parkedVehicleDensity = 0.1,
}
Config.WantedSystem.disableWantedLevel = true
```

### Configuration for RP Servers
```lua
Config.EnableNPCs = true
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.6,        -- Moderate peds
    vehicleDensity = 0.6,    -- Moderate traffic
}
Config.JobRespect.enabled = true  -- Enable job-based behavior
Config.Compatibility.ESX = true   -- Or QBCore/Qbox/vRP/NDCore
```

### Configuration for PvP Servers
```lua
Config.EnableNPCs = false  -- Completely disable NPCs
```

### Configuration for Drift/Stunt Servers
```lua
Config.EnableNPCs = true
Config.PopulationDensity = {
    enabled = true,
    pedDensity = 0.0,        -- No peds
    vehicleDensity = 0.0,    -- No vehicles
}
Config.SpawnControl = {
    enabled = true,
    disablePedSpawn = true,
    disableVehicleSpawn = true,
}
```

## Commands

After installation, these commands are available (with admin permission):

- `/npcreload` - Reload the configuration without restarting
- `/npctoggle` - Toggle NPCs on/off quickly
- `/npcclear` - Remove all NPCs from the world
- `/npccount` - Show current NPC count

## Troubleshooting

### NPCs are not spawning
- Check that `Config.EnableNPCs = true`
- Verify density values are greater than 0.0
- Make sure the resource is started: `ensure FiveM_AI_Controller` in server.cfg

### Commands don't work
- Check admin permissions in server.cfg
- Or disable permission check: `Config.Commands.requirePermission = false`

### Job-based behavior not working
- Ensure framework integration is enabled in Config.Compatibility
- Verify job names match your framework's job names
- Check server console for any errors

### Performance issues
- Lower density values in `Config.PopulationDensity`
- Reduce `Config.Advanced.maxNPCDistance`
- Enable auto-cleanup: `Config.Advanced.autoCleanupEnabled = true`
- Increase cleanup interval: `Config.Advanced.cleanupInterval = 60000`

## Advanced Configuration

### Time-Based Settings
Make NPCs appear/disappear based on time of day:

```lua
Config.TimeBasedSettings = {
    enabled = true,
    daySettings = {
        pedDensity = 0.7,      -- More people during day
        vehicleDensity = 0.7,
    },
    nightSettings = {
        pedDensity = 0.3,      -- Fewer people at night
        vehicleDensity = 0.4,
    },
}
```

### Zone-Based Settings
Different NPC density in different areas:

```lua
Config.ZoneSettings = {
    enabled = true,
    zones = {
        {
            name = "Downtown",
            coords = vector3(-234.14, -877.87, 30.49),
            radius = 500.0,
            pedDensity = 0.9,    -- Busy downtown
            vehicleDensity = 0.9,
        },
        {
            name = "Desert",
            coords = vector3(1859.26, 3700.87, 33.57),
            radius = 1000.0,
            pedDensity = 0.0,    -- Empty desert
            vehicleDensity = 0.1,
        },
    },
}
```

### Custom Relationship Settings
Control how NPCs interact with players and each other:

```lua
Config.Relationships = {
    enabled = true,
    playerToNPC = 3,     -- 0=Companion, 3=Neutral, 5=Hate
    npcToPlayer = 3,
    copsToPlayer = 3,
}
```

## Support

For issues, questions, or feature requests, please visit:
https://github.com/ArmA3Cowboy/FiveM_AI_Controller/issues

## Performance Tips

1. **Start with default settings** - They're optimized for most servers
2. **Adjust density gradually** - Small changes can have big impacts
3. **Use zone-based settings** - Different density in different areas
4. **Enable auto-cleanup** - Prevents NPC buildup over time
5. **Monitor server performance** - Use `/npccount` to check NPC levels

## Next Steps

1. Test the basic installation with default settings
2. Adjust population density to your preference
3. Configure job-based behavior if using an RP framework
4. Fine-tune specific settings based on your server type
5. Set up admin commands and permissions

Enjoy your fully customized NPC experience!
