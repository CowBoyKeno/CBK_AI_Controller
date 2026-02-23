--[[
    ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗ 
    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
    ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
    ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
    ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
    ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
    
    FiveM AI NPC Controller - Server Side
]]

-- Server startup message
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
    print("^2========================================^7")
    print("^2  FiveM AI NPC Controller Started^7")
    print("^2  Version: 1.3.0^7")
    print("^2  Author: ArmA3Cowboy^7")
    print("^2========================================^7")
    print("^3Configuration Status:^7")
    print("  - NPCs Enabled: ^5" .. tostring(Config.EnableNPCs) .. "^7")
    print("  - Job Respect System: ^5" .. tostring(Config.JobRespect.enabled) .. "^7")
    print("  - Population Density: ^5" .. tostring(Config.PopulationDensity.enabled) .. "^7")
    print("  - Commands Enabled: ^5" .. tostring(Config.Commands.enabled) .. "^7")
    print("^2========================================^7")
end)

-- Function to check if player has admin permission
local function HasPermission(source)
    if not Config.Commands.requirePermission then
        return true
    end
    
    -- Check if player is server admin/has ace permission based on configured permission level
    local permLevel = Config.Commands.permissionLevel or "admin"
    
    -- Always check for specific npccontrol permission first
    if IsPlayerAceAllowed(source, "command.npccontrol") then
        return true
    end
    
    -- Then check configured permission level
    -- Common values: "admin", "group.admin", "moderator", "group.moderator", etc.
    return IsPlayerAceAllowed(source, permLevel)
end

-- Function to get player job (framework integration)
function GetPlayerJob(source)
    local job = nil
    
    -- ESX Integration
    if Config.Compatibility.ESX then
        local success, ESX = pcall(function()
            return exports["es_extended"]:getSharedObject()
        end)
        if success and ESX then
            local xPlayer = ESX.GetPlayerFromId(source)
            if xPlayer then
                job = xPlayer.job.name
            end
        end
    end
    
    -- QBCore Integration
    if Config.Compatibility.QBCore and not job then
        local success, QBCore = pcall(function()
            return exports['qb-core']:GetCoreObject()
        end)
        if success and QBCore then
            local Player = QBCore.Functions.GetPlayer(source)
            if Player then
                job = Player.PlayerData.job.name
            end
        end
    end
    
    -- Qbox Integration (QBCore fork)
    if Config.Compatibility.Qbox and not job then
        local success, Qbox = pcall(function()
            return exports['qbx_core']:GetCoreObject()
        end)
        if success and Qbox then
            local Player = Qbox.Functions.GetPlayer(source)
            if Player then
                job = Player.PlayerData.job.name
            end
        end
    end
    
    -- vRP Integration
    if Config.Compatibility.vRP and not job then
        local success, vRP = pcall(function()
            return Proxy.getInterface("vRP")
        end)
        if success and vRP then
            local user_id = vRP.getUserId({source})
            if user_id then
                -- vRP uses different job system, get user groups
                local groups = vRP.getUserGroups({user_id})
                if groups then
                    -- Check for job groups using configurable mapping
                    local groupMapping = Config.Compatibility.vRPGroupMapping or {}
                    for groupName, jobName in pairs(groupMapping) do
                        if groups[groupName] then
                            job = jobName
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- ND-core Integration
    if Config.Compatibility.NDCore and not job then
        local success, NDCore = pcall(function()
            return exports["ND_Core"]:getPlayer(source)
        end)
        if success and NDCore then
            -- ND-core can return job as string or nested object
            if type(NDCore.job) == "string" then
                job = NDCore.job
            elseif type(NDCore.job) == "table" and NDCore.job.name then
                job = NDCore.job.name
            end
        end
    end
    
    return job
end

-- Send config to client
RegisterServerEvent('ai_controller:requestConfig')
AddEventHandler('ai_controller:requestConfig', function()
    local source = source
    TriggerClientEvent('ai_controller:receiveConfig', source, Config)
end)

-- Update config from client
RegisterServerEvent('ai_controller:updateConfig')
AddEventHandler('ai_controller:updateConfig', function(newConfig)
    local source = source
    
    if HasPermission(source) then
        Config = newConfig
        TriggerClientEvent('ai_controller:receiveConfig', -1, Config)
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            multiline = true,
            args = {"AI Controller", Config.Locale['settings_updated']}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"AI Controller", Config.Locale['invalid_permission']}
        })
    end
end)

-- Check player job and send to client
RegisterServerEvent('ai_controller:checkPlayerJob')
AddEventHandler('ai_controller:checkPlayerJob', function()
    local source = source
    local job = GetPlayerJob(source)
    TriggerClientEvent('ai_controller:receivePlayerJob', source, job)
end)

-- Commands
if Config.Commands.enabled then
    
    -- Reload configuration command
    RegisterCommand(Config.Commands.reloadCommand, function(source, args, rawCommand)
        if source == 0 or HasPermission(source) then
            TriggerClientEvent('ai_controller:receiveConfig', -1, Config)
            
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"AI Controller", "Configuration reloaded successfully!"}
                })
            else
                print("^2[AI Controller]^7 Configuration reloaded successfully!")
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"AI Controller", Config.Locale['invalid_permission']}
            })
        end
    end, false)
    
    -- Toggle NPCs command
    RegisterCommand(Config.Commands.toggleCommand, function(source, args, rawCommand)
        if source == 0 or HasPermission(source) then
            Config.EnableNPCs = not Config.EnableNPCs
            TriggerClientEvent('ai_controller:receiveConfig', -1, Config)
            
            local status = Config.EnableNPCs and "enabled" or "disabled"
            
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"AI Controller", "NPCs have been " .. status}
                })
            else
                print("^2[AI Controller]^7 NPCs have been " .. status)
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"AI Controller", Config.Locale['invalid_permission']}
            })
        end
    end, false)
    
    -- Clear NPCs command
    RegisterCommand(Config.Commands.clearCommand, function(source, args, rawCommand)
        if source == 0 or HasPermission(source) then
            TriggerClientEvent('ai_controller:clearAllNPCs', -1)
            
            if source ~= 0 then
                TriggerClientEvent('chat:addMessage', source, {
                    color = {0, 255, 0},
                    multiline = true,
                    args = {"AI Controller", "All NPCs have been cleared!"}
                })
            else
                print("^2[AI Controller]^7 All NPCs have been cleared!")
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"AI Controller", Config.Locale['invalid_permission']}
            })
        end
    end, false)
    
    -- NPC count command
    RegisterCommand(Config.Commands.countCommand, function(source, args, rawCommand)
        if source == 0 or HasPermission(source) then
            TriggerClientEvent('ai_controller:showNPCCount', source)
        else
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"AI Controller", Config.Locale['invalid_permission']}
            })
        end
    end, false)
end

-- Export functions for other resources
exports('GetConfig', function()
    return Config
end)

exports('SetConfig', function(newConfig)
    Config = newConfig
    TriggerClientEvent('ai_controller:receiveConfig', -1, Config)
end)

exports('GetPlayerJob', function(source)
    return GetPlayerJob(source)
end)

-- Server-side logging
if Config.Advanced.debug then
    print("^3[AI Controller Debug]^7 Server side initialized with debug mode enabled")
end
