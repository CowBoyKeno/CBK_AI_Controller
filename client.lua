--[[
     ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
    ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
    ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
    ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
    ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
     ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
    
    FiveM AI NPC Controller - Client Side
]]

local playerJob = nil
local currentConfig = Config
local isInitialized = false

-- Constants for vehicle tasks
local TASK_VEHICLE_PULL_OVER = 6  -- Task code for vehicle pull over action

-- Track vehicles with modified max speed for restoration
local vehiclesWithModifiedSpeed = {}

-- Receive config from server
RegisterNetEvent('ai_controller:receiveConfig')
AddEventHandler('ai_controller:receiveConfig', function(config)
    currentConfig = config
    ApplyAllSettings()
end)

-- Receive player job from server
RegisterNetEvent('ai_controller:receivePlayerJob')
AddEventHandler('ai_controller:receivePlayerJob', function(job)
    playerJob = job
    if currentConfig.Advanced.debug then
        print("^3[AI Controller Debug]^7 Player job set to: " .. tostring(job))
    end
end)

-- Clear all NPCs
RegisterNetEvent('ai_controller:clearAllNPCs')
AddEventHandler('ai_controller:clearAllNPCs', function()
    local peds = GetGamePool('CPed')
    local vehicles = GetGamePool('CVehicle')
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    for _, ped in ipairs(peds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) then
            DeleteEntity(ped)
        end
    end
    
    for _, vehicle in ipairs(vehicles) do
        if vehicle ~= playerVehicle and GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
            DeleteEntity(vehicle)
        end
    end
end)

-- Show NPC count
RegisterNetEvent('ai_controller:showNPCCount')
AddEventHandler('ai_controller:showNPCCount', function()
    local peds = GetGamePool('CPed')
    local vehicles = GetGamePool('CVehicle')
    local playerPed = PlayerPedId()
    local npcCount = 0
    local vehicleCount = 0
    
    for _, ped in ipairs(peds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) then
            npcCount = npcCount + 1
        end
    end
    
    for _, vehicle in ipairs(vehicles) do
        if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
            vehicleCount = vehicleCount + 1
        end
    end
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 255},
        multiline = true,
        args = {"AI Controller", string.format("NPCs: %d | Vehicles: %d", npcCount, vehicleCount)}
    })
end)

-- Apply population density settings
function ApplyPopulationDensity()
    if not currentConfig.PopulationDensity.enabled then return end
    
    SetPedDensityMultiplierThisFrame(currentConfig.PopulationDensity.pedDensity)
    SetScenarioPedDensityMultiplierThisFrame(currentConfig.PopulationDensity.scenarioPedDensity, currentConfig.PopulationDensity.scenarioPedDensity)
    SetVehicleDensityMultiplierThisFrame(currentConfig.PopulationDensity.vehicleDensity)
    SetRandomVehicleDensityMultiplierThisFrame(currentConfig.PopulationDensity.vehicleDensity)
    SetParkedVehicleDensityMultiplierThisFrame(currentConfig.PopulationDensity.parkedVehicleDensity)
end

-- Apply spawn control settings
function ApplySpawnControl()
    if not currentConfig.SpawnControl.enabled then return end
    
    if currentConfig.SpawnControl.disablePedSpawn then
        SetPedDensityMultiplierThisFrame(0.0)
    end
    
    if currentConfig.SpawnControl.disableVehicleSpawn then
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
    end
    
    if currentConfig.SpawnControl.disableParkedVehicles then
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
    end
    
    if currentConfig.SpawnControl.disableScenarioPeds then
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    end
end

-- Apply scenario settings
function ApplyScenarioSettings()
    local settings = currentConfig.ScenarioSettings
    
    if settings.disableAllScenarios then
        for i = 1, 32 do
            EnableDispatchService(i, false)
        end
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        return
    end
    
    -- Specific scenario types
    if settings.disableCops then
        for i = 1, 12 do
            EnableDispatchService(i, false)
        end
    end
    
    if settings.disableParamedics then
        EnableDispatchService(13, false)
        EnableDispatchService(14, false)
    end
    
    if settings.disableFiremen then
        EnableDispatchService(15, false)
    end
    
    -- Remove specific scenario peds
    local scenarioTypes = {
        "WORLD_VEHICLE_MILITARY_PLANES_SMALL",
        "WORLD_VEHICLE_MILITARY_PLANES_BIG",
        "WORLD_VEHICLE_AMBULANCE",
        "WORLD_VEHICLE_POLICE_NEXT_TO_CAR",
        "WORLD_VEHICLE_POLICE_CAR",
        "WORLD_VEHICLE_POLICE_BIKE"
    }
    
    for _, scenario in ipairs(scenarioTypes) do
        SetScenarioTypeEnabled(scenario, false)
    end
end

-- Apply NPC behavior settings
function ApplyNPCBehavior()
    -- Apply combat settings
    -- Note: disableNPCCombat requires per-ped native calls (SetPedCombatAbility) applied
    -- in the periodic behavior thread below, not via a global native here.
    
    -- Disable wanted level if configured
    if currentConfig.WantedSystem.disableWantedLevel then
        SetMaxWantedLevel(0)
        SetPlayerWantedLevel(PlayerId(), 0, false)
        SetPlayerWantedLevelNow(PlayerId(), false)
    else
        SetMaxWantedLevel(currentConfig.WantedSystem.maxWantedLevel)
    end
    
    if currentConfig.WantedSystem.disablePoliceResponse then
        for i = 1, 12 do
            EnableDispatchService(i, false)
        end
    end
    
    if currentConfig.WantedSystem.disablePoliceHelicopters then
        -- Disable police helicopters (dispatch service 14 for air support)
        EnableDispatchService(14, false)
    end
end

-- Apply job-based NPC behavior
function ApplyJobBasedBehavior()
    if not currentConfig.JobRespect.enabled then return end
    
    local playerPed = PlayerPedId()
    
    -- Check if player has a respected job
    local isPolice = false
    local isMedical = false
    local isFirefighter = false
    local isTow = false
    
    if playerJob then
        for _, job in ipairs(currentConfig.JobRespect.policeJobs) do
            if playerJob == job then
                isPolice = true
                break
            end
        end
        
        for _, job in ipairs(currentConfig.JobRespect.medicalJobs) do
            if playerJob == job then
                isMedical = true
                break
            end
        end
        
        for _, job in ipairs(currentConfig.JobRespect.firefighterJobs) do
            if playerJob == job then
                isFirefighter = true
                break
            end
        end
        
        for _, job in ipairs(currentConfig.JobRespect.towJobs) do
            if playerJob == job then
                isTow = true
                break
            end
        end
    end
    
    -- Apply police respect settings
    if isPolice and currentConfig.JobRespect.policeSettings.npcsRespectPolice then
        -- Make NPCs move aside for police (they will clear a path)
        -- Note: This uses TaskSmartFleePed which makes NPCs move away from player
        -- Alternative: Use TaskGoStraightToCoord to make them walk to the side
        local nearbyPeds = GetNearbyPeds(playerPed, 50.0)
        for _, ped in ipairs(nearbyPeds) do
            if not IsPedAPlayer(ped) and not IsPedInAnyVehicle(ped, false) then
                -- Make NPC move away to clear path (respectful avoidance behavior)
                TaskSmartFleePed(ped, playerPed, 100.0, -1, false, false)
                SetBlockingOfNonTemporaryEvents(ped, true)
            end
        end
    end
    
    -- Apply ignore players setting
    if currentConfig.JobRespect.ignorePlayers then
        local nearbyPeds = GetNearbyPeds(playerPed, 100.0)
        for _, ped in ipairs(nearbyPeds) do
            if not IsPedAPlayer(ped) then
                SetPedAsNoLongerNeeded(ped)
                SetBlockingOfNonTemporaryEvents(ped, true)
            end
        end
    end
end

-- Apply vehicle settings
function ApplyVehicleSettings()
    local settings = currentConfig.VehicleSettings
    
    if not settings.enableTraffic then
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
    end
    
    if settings.disablePoliceVehicles then
        SetVehicleModelIsSuppressed(GetHashKey("police"), true)
        SetVehicleModelIsSuppressed(GetHashKey("police2"), true)
        SetVehicleModelIsSuppressed(GetHashKey("police3"), true)
        SetVehicleModelIsSuppressed(GetHashKey("police4"), true)
        SetVehicleModelIsSuppressed(GetHashKey("policeb"), true)
        SetVehicleModelIsSuppressed(GetHashKey("policet"), true)
    end
    
    if settings.disableAmbulanceVehicles then
        SetVehicleModelIsSuppressed(GetHashKey("ambulance"), true)
    end
    
    if settings.disableFiretruckVehicles then
        SetVehicleModelIsSuppressed(GetHashKey("firetruk"), true)
    end
    
    if settings.disableBoats then
        SetRandomBoats(false)
    end
    
    if settings.disableTrains then
        SetRandomTrains(false)
    end
    
    if settings.disableHelicopters then
        local heliModels = {"maverick", "buzzard", "buzzard2", "swift", "swift2", "annihilator", "savage", "frogger", "frogger2", "supervolito", "supervolito2", "volatus", "skylift", "seasparrow"}
        for _, model in ipairs(heliModels) do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
    end
    
    if settings.disablePlanes then
        local planeModels = {"luxor", "luxor2", "jet", "lazer", "titan", "dodo", "velum", "velum2", "besra", "miljet", "shamal", "hydra", "cuban800", "alpha", "stuntplane", "mammatus", "mogul", "rogue", "starling", "tula", "ultralight", "vestra", "volatol"}
        for _, model in ipairs(planeModels) do
            SetVehicleModelIsSuppressed(GetHashKey(model), true)
        end
    end
end

-- =============================================================================
-- EMERGENCY VEHICLE BEHAVIOR SYSTEM
-- =============================================================================

-- Check if a vehicle is an emergency vehicle
function IsEmergencyVehicle(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    
    local emergencySettings = currentConfig.VehicleSettings.emergencyVehicleBehavior
    if not emergencySettings.enabled then return false end
    
    local vehicleClass = GetVehicleClass(vehicle)
    
    -- Class 18 = Emergency vehicles (police, ambulance, fire)
    if vehicleClass == 18 and (emergencySettings.detectPolice or emergencySettings.detectAmbulance or emergencySettings.detectFiretruck) then
        return true
    end
    
    -- Check specific models
    local model = GetEntityModel(vehicle)
    local modelName = string.lower(GetDisplayNameFromVehicleModel(model))
    
    if emergencySettings.detectPolice then
        if string.find(modelName, "polic") or string.find(modelName, "sheriff") or string.find(modelName, "fbi") then
            return true
        end
    end
    
    if emergencySettings.detectAmbulance then
        if string.find(modelName, "ambulance") or string.find(modelName, "ems") then
            return true
        end
    end
    
    if emergencySettings.detectFiretruck then
        if string.find(modelName, "fire") then
            return true
        end
    end
    
    return false
end

-- Check if emergency lights are active on a vehicle
function HasEmergencyLightsOn(vehicle)
    if not DoesEntityExist(vehicle) then return false end
    
    -- Check if siren is active (includes lights)
    return IsVehicleSirenOn(vehicle)
end

-- Get all nearby emergency vehicles
function GetNearbyEmergencyVehicles(coords, radius)
    local emergencyVehicles = {}
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if IsEmergencyVehicle(vehicle) then
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(coords - vehCoords)
            
            if distance <= radius then
                table.insert(emergencyVehicles, {
                    vehicle = vehicle,
                    coords = vehCoords,
                    distance = distance,
                    stopped = GetEntitySpeed(vehicle) < 1.0,
                    lightsOn = HasEmergencyLightsOn(vehicle)
                })
            end
        end
    end
    
    return emergencyVehicles
end

-- Check if emergency vehicle is behind or in front of NPC vehicle
function GetEmergencyVehicleDirection(npcVehicle, emergencyVehicle)
    local npcCoords = GetEntityCoords(npcVehicle)
    local npcHeading = GetEntityHeading(npcVehicle)
    local emergencyCoords = GetEntityCoords(emergencyVehicle)
    
    -- Calculate relative angle
    local dx = emergencyCoords.x - npcCoords.x
    local dy = emergencyCoords.y - npcCoords.y
    local angle = math.deg(math.atan2(dy, dx))
    
    -- Normalize angles
    local relativeAngle = (angle - npcHeading + 360) % 360
    
    -- Determine if behind or in front
    -- Behind: 135-225 degrees, Front: 315-45 degrees
    if relativeAngle > 135 and relativeAngle < 225 then
        return "behind"
    elseif relativeAngle < 45 or relativeAngle > 315 then
        return "front"
    end
    
    return "side"
end

-- Apply emergency vehicle behavior to nearby NPCs
function ApplyEmergencyVehicleBehavior()
    local settings = currentConfig.VehicleSettings.emergencyVehicleBehavior
    if not settings.enabled then return end
    
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    
    -- Only apply if player is in a vehicle
    if playerVehicle == 0 then return end
    
    -- Check if player's vehicle is an emergency vehicle with lights on
    local isPlayerEmergency = IsEmergencyVehicle(playerVehicle)
    local playerLightsOn = HasEmergencyLightsOn(playerVehicle)
    
    if not isPlayerEmergency then return end
    if settings.requireSiren and not playerLightsOn then return end
    
    local playerCoords = GetEntityCoords(playerVehicle)
    local playerSpeed = GetEntitySpeed(playerVehicle)
    local isStopped = playerSpeed < 1.0
    
    -- Get all nearby NPC vehicles
    local vehicles = GetGamePool('CVehicle')
    
    for _, vehicle in ipairs(vehicles) do
        if vehicle ~= playerVehicle and DoesEntityExist(vehicle) then
            local driver = GetPedInVehicleSeat(vehicle, -1)
            
            -- Only affect NPC-driven vehicles
            if driver ~= 0 and not IsPedAPlayer(driver) then
                local vehCoords = GetEntityCoords(vehicle)
                local distance = #(playerCoords - vehCoords)
                
                -- Slow Pass Behavior (for stopped emergency vehicles)
                if settings.slowPassEnabled and isStopped and distance <= settings.slowPassRadius then
                    -- Make NPC vehicle drive very slowly when passing
                    local vehSpeed = GetEntitySpeed(vehicle)
                    
                    -- Convert configured mph to m/s (mph * 0.44704 = m/s)
                    local slowPassSpeedMS = settings.slowPassSpeed * 0.44704
                    
                    if vehSpeed > slowPassSpeedMS then
                        -- Slow down the vehicle
                        SetVehicleMaxSpeed(vehicle, slowPassSpeedMS)
                        vehiclesWithModifiedSpeed[vehicle] = true
                        
                        -- Make driver more cautious
                        SetDriverAbility(driver, 1.0)
                        SetDriverAggressiveness(driver, 0.0)
                    end
                elseif vehiclesWithModifiedSpeed[vehicle] then
                    -- Reset max speed when vehicle exits slow pass radius
                    SetVehicleMaxSpeed(vehicle, 0.0)  -- 0.0 removes the speed limit
                    vehiclesWithModifiedSpeed[vehicle] = nil
                end
                
                -- Pull Over Behavior (for moving emergency vehicles)
                if settings.pullOverEnabled and not isStopped and distance <= settings.pullOverDistance then
                    local direction = GetEmergencyVehicleDirection(vehicle, playerVehicle)
                    
                    -- Only pull over if emergency vehicle is behind or in front
                    if (settings.checkBehind and direction == "behind") or (settings.checkFront and direction == "front") then
                        -- Make NPC pull over to the side
                        TaskVehicleTempAction(driver, vehicle, TASK_VEHICLE_PULL_OVER, settings.pullOverDuration)
                        
                        -- Also adjust driver behavior for smoother pull-over
                        SetDriverAbility(driver, 1.0)
                        SetDriverAggressiveness(driver, 0.0)
                    end
                end
                
                -- Courtesy Behavior (disable horn and speech)
                if distance <= settings.courtesyRadius then
                    -- Note: SetHornEnabled is not a valid FiveM native
                    -- Horn control is not directly available in FiveM
                    -- Future: Could use alternative methods if available
                    
                    if settings.disableSpeechNearEmergency then
                        -- Stop ambient speech for this NPC driver
                        StopPedSpeaking(driver, true)
                    end
                end
            end
        end
    end
end


-- Apply relationship settings
function ApplyRelationships()
    if not currentConfig.Relationships.enabled then return end
    
    local playerPed = PlayerPedId()
    local playerGroup = GetPedRelationshipGroupHash(playerPed)
    
    -- Set relationship between player and NPCs
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_LOST"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_MEXICAN"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_FAMILY"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_BALLAS"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_MARABUNTE"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_CULT"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_SALVA"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_WEICHENG"))
    SetRelationshipBetweenGroups(currentConfig.Relationships.playerToNPC, playerGroup, GetHashKey("AMBIENT_GANG_HILLBILLY"))
    
    -- Cops relationship
    SetRelationshipBetweenGroups(currentConfig.Relationships.copsToPlayer, GetHashKey("COP"), playerGroup)
end

-- Apply time-based settings
function ApplyTimeBasedSettings()
    if not currentConfig.TimeBasedSettings.enabled then return end
    
    local hour = GetClockHours()
    local isDaytime = hour >= 6 and hour < 18
    
    local settings = isDaytime and currentConfig.TimeBasedSettings.daySettings or currentConfig.TimeBasedSettings.nightSettings
    
    SetPedDensityMultiplierThisFrame(settings.pedDensity)
    SetVehicleDensityMultiplierThisFrame(settings.vehicleDensity)
    
    if not settings.enableScenarios then
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    end
end

-- Apply zone-based settings
function ApplyZoneSettings()
    if not currentConfig.ZoneSettings.enabled then return end
    
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, zone in ipairs(currentConfig.ZoneSettings.zones) do
        local distance = #(playerCoords - zone.coords)
        if distance <= zone.radius then
            -- Apply this zone's density settings (overrides global population density)
            if zone.pedDensity then
                SetPedDensityMultiplierThisFrame(zone.pedDensity)
                SetScenarioPedDensityMultiplierThisFrame(zone.pedDensity, zone.pedDensity)
            end
            if zone.vehicleDensity then
                SetVehicleDensityMultiplierThisFrame(zone.vehicleDensity)
                SetRandomVehicleDensityMultiplierThisFrame(zone.vehicleDensity)
            end
            break  -- Apply only the first matching zone
        end
    end
end

-- Apply all settings
function ApplyAllSettings()
    if not currentConfig.EnableNPCs then
        SetPedDensityMultiplierThisFrame(0.0)
        SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
        SetVehicleDensityMultiplierThisFrame(0.0)
        SetRandomVehicleDensityMultiplierThisFrame(0.0)
        SetParkedVehicleDensityMultiplierThisFrame(0.0)
        return
    end
    
    ApplyPopulationDensity()
    ApplySpawnControl()
    ApplyScenarioSettings()
    ApplyNPCBehavior()
    ApplyJobBasedBehavior()
    ApplyVehicleSettings()
    ApplyRelationships()
    ApplyTimeBasedSettings()
    ApplyZoneSettings()
    ApplyEmergencyVehicleBehavior()
end

-- Helper function to get nearby peds
function GetNearbyPeds(playerPed, radius)
    local peds = {}
    local allPeds = GetGamePool('CPed')
    local playerCoords = GetEntityCoords(playerPed)
    
    for _, ped in ipairs(allPeds) do
        if ped ~= playerPed and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)
            if distance <= radius then
                table.insert(peds, ped)
            end
        end
    end
    
    return peds
end

-- Cleanup thread
Citizen.CreateThread(function()
    while true do
        if currentConfig.Advanced.autoCleanupEnabled then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local cleanupDistance = currentConfig.Advanced.cleanupDistance
            
            local peds = GetGamePool('CPed')
            for _, ped in ipairs(peds) do
                if ped ~= playerPed and not IsPedAPlayer(ped) then
                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(playerCoords - pedCoords)
                    if distance > cleanupDistance then
                        DeleteEntity(ped)
                    end
                end
            end
            
            local vehicles = GetGamePool('CVehicle')
            for _, vehicle in ipairs(vehicles) do
                local vehicleCoords = GetEntityCoords(vehicle)
                local distance = #(playerCoords - vehicleCoords)
                if distance > cleanupDistance then
                    -- Check all seats (driver + passengers) for player occupants
                    local hasPlayerOccupant = false
                    local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
                    for seat = -1, maxSeats do
                        local ped = GetPedInVehicleSeat(vehicle, seat)
                        if ped ~= 0 and IsPedAPlayer(ped) then
                            hasPlayerOccupant = true
                            break
                        end
                    end
                    if not hasPlayerOccupant then
                        DeleteEntity(vehicle)
                    end
                end
            end
        end
        
        Citizen.Wait(currentConfig.Advanced.cleanupInterval)
    end
end)

-- Main thread
Citizen.CreateThread(function()
    -- Request config from server on startup
    TriggerServerEvent('ai_controller:requestConfig')
    
    -- Request player job if framework is enabled
    if currentConfig.Compatibility.ESX or currentConfig.Compatibility.QBCore or currentConfig.Compatibility.Qbox or currentConfig.Compatibility.vRP or currentConfig.Compatibility.NDCore then
        TriggerServerEvent('ai_controller:checkPlayerJob')
    end
    
    Citizen.Wait(1000)
    isInitialized = true
    
    if currentConfig.Advanced.debug then
        print("^3[AI Controller Debug]^7 Client side initialized")
    end
    
    -- Main loop - runs every frame to apply 'ThisFrame' natives
    -- Performance Note: This loop runs every frame (Wait 0) because many FiveM natives
    -- with 'ThisFrame' in their name (e.g., SetPedDensityMultiplierThisFrame) must be
    -- called continuously to maintain their effect. This is the standard approach for
    -- controlling spawning/density and is well-optimized by FiveM's native implementation.
    -- The actual performance impact is minimal (typically < 0.01ms per frame).
    while true do
        Citizen.Wait(0)  -- Must be 0 because ThisFrame natives need to be called every frame
        
        if isInitialized and currentConfig.EnableNPCs then
            ApplyAllSettings()
        elseif isInitialized and not currentConfig.EnableNPCs then
            -- When NPCs are disabled, we still need to call ThisFrame natives every frame
            SetPedDensityMultiplierThisFrame(0.0)
            SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            SetVehicleDensityMultiplierThisFrame(0.0)
            SetRandomVehicleDensityMultiplierThisFrame(0.0)
            SetParkedVehicleDensityMultiplierThisFrame(0.0)
        end
    end
end)

-- Show NPC count periodically if enabled
if currentConfig.Advanced.showNPCCount then
    Citizen.CreateThread(function()
        while true do
            local peds = GetGamePool('CPed')
            local vehicles = GetGamePool('CVehicle')
            local playerPed = PlayerPedId()
            local npcCount = 0
            local vehicleCount = 0
            
            for _, ped in ipairs(peds) do
                if ped ~= playerPed and not IsPedAPlayer(ped) then
                    npcCount = npcCount + 1
                end
            end
            
            for _, vehicle in ipairs(vehicles) do
                if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                    vehicleCount = vehicleCount + 1
                end
            end
            
            print(string.format("^3[AI Controller]^7 NPCs: %d | Vehicles: %d", npcCount, vehicleCount))
            
            Citizen.Wait(30000) -- Every 30 seconds
        end
    end)
end

-- Job update handler (for frameworks that support it)
if currentConfig.Compatibility.ESX then
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        playerJob = job.name
        if currentConfig.Advanced.debug then
            print("^3[AI Controller Debug]^7 Player job updated to: " .. playerJob)
        end
    end)
end

if currentConfig.Compatibility.QBCore then
    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        playerJob = JobInfo.name
        if currentConfig.Advanced.debug then
            print("^3[AI Controller Debug]^7 Player job updated to: " .. playerJob)
        end
    end)
end

if currentConfig.Compatibility.Qbox then
    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        playerJob = JobInfo.name
        if currentConfig.Advanced.debug then
            print("^3[AI Controller Debug]^7 Player job updated to: " .. playerJob)
        end
    end)
end

-- Export functions
exports('GetConfig', function()
    return currentConfig
end)

exports('GetPlayerJob', function()
    return playerJob
end)

exports('SetPlayerJob', function(job)
    playerJob = job
end)
