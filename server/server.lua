---------------------------------------------------------------
------------- data Set
---------------------------------------------------------------
local stashesTable = {}
RegisterNetEvent("insertStashesData", function(input, loc)
    stashesTable[#stashesTable + 1] = {
        id = math.random(100000, 999999),
        name = input[1] or nil,
        job = input[2] or nil,
        gang = input[3] or nil,
        rank = input[4] or nil,
        item = input[5] or nil,
        slotSize = input[6],
        weight = input[7],
        password = input[8] or nil,
        citizenID = input[9] or nil,
        targetlabel = input[10] or nil,
        webhookURL = input[11] or nil,
        loc = loc or nil
    }
    SaveStashesData()
end)

RegisterNetEvent("deleteStashesData", function(id)
    for i = #stashesTable, 1, -1 do
        if stashesTable[i].id == id then
            table.remove(stashesTable, i)
            SaveStashesData()
            break
        end
    end
    TriggerClientEvent("mri_Qstashes:delete", -1, stashesTable)
end)

---------------------------------------------------------------
------------- core Functions
---------------------------------------------------------------

function SaveStashesData()
    TriggerClientEvent("mri_Qstashes:delete", -1, stashesTable)
    local jsonData = json.encode(stashesTable)
    SaveResourceFile(GetCurrentResourceName(), "data.json", jsonData, -1)
    TriggerClientEvent('mri_Qstashes:start', -1, stashesTable)
    LoadStashesData()
end

function LoadStashesData()
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data.json")
    if loadFile then
        stashesTable = json.decode(loadFile)
    end
    RegisterStashData()
end

local function RegisterHookData(stash)
    local webhookURL = ""
    local inventory = ""
    exports.ox_inventory:registerHook('swapItems', function(payload)
            if payload.fromInventory == stash.id then
                webhookURL = stash.webhookURL
                inventory = stash.label
                WebhookPlayer(payload, webhookURL, inventory)
            elseif payload.toInventory == stash.id and payload.action == "move"then
                webhookURL = stash.webhookURL
                inventory = stash.label
                WebhookPlayer(payload, webhookURL, inventory)
            end
    end, options)
end

function RegisterStashData()
    for k, v in pairs(stashesTable) do
        local stash = {
            id = "mri_Qstashes" .. v.id,
            label = v.name,
            slots = v.slotSize,
            webhookURL = v.webhookURL,
            weight = tonumber(v.weight)
        }
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
        RegisterHookData(stash)
    end
end

---------------------------------------------------------------
------------- core Events
---------------------------------------------------------------
lib.callback.register('stashesGetAll', function()
    return stashesTable
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        LoadStashesData()
        if GetResourceState('ox_inventory') ~= 'started' then
            return print("[mri_Qstashes] - ox_inventory não encontrado.")
        end
        Wait(1000)
        TriggerClientEvent('mri_Qstashes:start', -1, stashesTable)
    end
end)

RegisterNetEvent("mri_Qstashes:server:Load", function()
    local src = source
    LoadStashesData()
    Wait(1000)
    TriggerClientEvent('mri_Qstashes:start', src, stashesTable)
end)

RegisterNetEvent("mri_Qstashes:server:Unload", function()
    local src = source
    LoadStashesData()
    Wait(1000)
    TriggerClientEvent("mri_Qstashes:delete", src, stashesTable)
end)

---------------------------------------------------------------
------------- addCommand
---------------------------------------------------------------
lib.addCommand(Config.Command, {
    help = locale("command.help"),
    restricted = 'group.admin'
}, function(source, args, raw)
    local src = source
    TriggerClientEvent('mri_Qstashes:openAdm', src)
end)

---------------------------------------------------------------
------------- Webhook Discord
---------------------------------------------------------------

local function sendWebhook(webhook, data)
    if webhook == nil then
        print('^1[logs] ^0Webhook ' .. webhook .. ' does not exist.')
        return
    end

    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = data
    }), {
        ['Content-Type'] = 'application/json'
    })
end

function WebhookPlayer(payload, webhookURL, inventory)
    local webhookURL = webhookURL
    local description = ""
    if not webhookURL then
        return
    end
    local playerName = GetPlayerName(payload.source)
    local playerdiscord = GetPlayerIdentifierByType(payload.source, 'discord'):match("%d+")
    local playerIdentifier = GetPlayerIdentifiers(payload.source)[1]
    local playerCoords = GetEntityCoords(GetPlayerPed(payload.source))

    if payload.fromType == "player" and payload.toType == "stash" then
        description =
            ('**Cidadão: %s \n **Discord:** <@%s> \n **ID: %s** \n **Colocou** **Item:** %s \n **Quantidade:** %s \n **Metadata:** %s \n **Bau:** %s \n **coordenadas** %s.')
    elseif payload.fromType == "stash" and payload.toType == "player" then
        description =
            ('**Cidadão: %s \n **Discord:** <@%s> \n **ID: %s** \n **Pegou** **Item:** %s \n **Quantidade:** %s \n **Metadata:** %s \n **Bau:** %s \n **coordenadas** %s.')
    end

    sendWebhook(webhookURL, {{
        title = 'Bau',
        description = description:format(playerName, playerdiscord, payload.source, payload.fromSlot.name,
            payload.fromSlot.count, json.encode(payload.fromSlot.metadata), inventory,
            ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z)),
        color = Config.Color
    }})
end

