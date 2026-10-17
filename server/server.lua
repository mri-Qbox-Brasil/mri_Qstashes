local stashesTable = {}

<<<<<<< fork
function isAdmin(src)
    if not Config or not Config.AdminPerms then return false end
    for _, perm in ipairs(Config.AdminPerms) do
        if IsPlayerAceAllowed(src, perm) then
            return true
        end
    end
    return false
end

lib.callback.register('mri_Qstashes:isAdmin', function(src)
    return isAdmin(src)
end)

RegisterNetEvent("insertStashesData", function(input, loc)
    local src = source
    if not isAdmin(src) then return end
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
        targetlabel = input[10] or locale("createmenu.default10"),
        webhookURL = input[11] or nil,
        loc = loc or nil
    }
    SaveStashesData()
end)

RegisterNetEvent("deleteStashesData", function(id)
    local src = source
    if not isAdmin(src) then return end
    for i = #stashesTable, 1, -1 do
        if stashesTable[i].id == id then
            table.remove(stashesTable, i)
            SaveStashesData()
            break
        end
    end
    TriggerClientEvent("mri_Qstashes:delete", -1, stashesTable)
end)

RegisterNetEvent("updateStashesData", function(id, input)
    local src = source
    if not isAdmin(src) then return end
    for i = 1, #stashesTable do
        if stashesTable[i].id == id then
            stashesTable[i].name = input[1] or stashesTable[i].name
            stashesTable[i].job = input[2] or stashesTable[i].job
            stashesTable[i].gang = input[3] or stashesTable[i].gang
            stashesTable[i].rank = input[4] or stashesTable[i].rank
            stashesTable[i].item = input[5] or stashesTable[i].item
            stashesTable[i].slotSize = input[6] or stashesTable[i].slotSize
            stashesTable[i].weight = input[7] or stashesTable[i].weight
            stashesTable[i].password = input[8] or stashesTable[i].password
            stashesTable[i].citizenID = input[9] or stashesTable[i].citizenID
            stashesTable[i].targetlabel = input[10] or stashesTable[i].targetlabel
            stashesTable[i].webhookURL = input[11] or stashesTable[i].webhookURL
            break
        end
    end
    SaveStashesData()
end)

RegisterNetEvent("updateStashLocation", function(id, newLoc)
    local src = source
    if not isAdmin(src) then return end
    for i = 1, #stashesTable do
        if stashesTable[i].id == id then
            stashesTable[i].loc = newLoc
            break
        end
    end
    SaveStashesData()
end)

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

lib.callback.register('stashesGetAll', function()
    return stashesTable
||||||| base
CreateThread(function()
if Config.OxInv then
    for k, v in pairs (Config.stash) do 
        if v.weight == nil then v.weight = Config.Defaultweight end
	if v.slots == nil then v.slots = Config.Defaultslot end
        local stash = {
        id = k,
        label = v.name,
        slots = v.slots,
        weight = v.weight,
        }
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
    end
end    
=======
local stashes = MySQL.query.await('SELECT * FROM mdstashes',{})

-- Callbacks
ps.registerCallback('md-stashes:server:verifyKey', function(source)
    if not IsPlayerAceAllowed(source, 'command') then return false end
    return true
>>>>>>> upstream
end)

<<<<<<< fork
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

lib.addCommand(Config.Command, {
    help = locale("command.help"),
    restricted = 'group.admin'
}, function(source, args, raw)
||||||| base
lib.addCommand('newstash', {
    help = "Make A New Stash",
    restricted = 'group.admin',
}, function(source, args, raw)
=======
ps.registerCallback('md-stashes:server:getStashes', function(source)
    return stashes
end)

ps.registerCallback('md-stashes:server:passwordCheck', function(source, pass, id)
>>>>>>> upstream
    local src = source
<<<<<<< fork
    TriggerClientEvent('mri_Qstashes:openAdm', src)
||||||| base
    TriggerClientEvent('md-stashes:client:doray', src)
=======
    local passWord = MySQL.query.await('SELECT * FROM mdstashes WHERE id = ?', {id})
    if passWord and not passWord[1] then return false end
    passWord = passWord[1]
    local loc = json.decode(passWord.loc)
    local location = vector3(loc.x, loc.y, loc.z)
    if not ps.checkDistance(src, location, 3) then
        ps.warn(ps.lang('Fail.tooFar', ps.getPlayerName(src), 'md-stashes:server:passwordCheck'))
        return
    end
    local data = json.decode(passWord.data)
    return data.password == pass
>>>>>>> upstream
end)

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
    if type(webhookURL) ~= "string" or webhookURL:match("^%s*$") or not webhookURL:match("^https?://") then
        return
    end
    local playerName = payload.source and GetPlayerName(payload.source) or "Desconhecido"
    local playerdiscord = payload.source and GetPlayerIdentifierByType(payload.source, 'discord')
    playerdiscord = playerdiscord and playerdiscord:match("%d+") or "N/A"
    local playerIdentifier = payload.source and GetPlayerIdentifiers(payload.source) and GetPlayerIdentifiers(payload.source)[1] or "N/A"
    local playerCoords = payload.source and GetPlayerPed(payload.source) and GetEntityCoords(GetPlayerPed(payload.source)) or {x = 0, y = 0, z = 0}
    local color = 0x00ff00
    local actionTitle = "Item depositado no baú"
    if payload.fromType == "player" and payload.toType == "stash" then
        color = 0x00ff00
        actionTitle = "Item depositado no baú"
    elseif payload.fromType == "stash" and payload.toType == "player" then
        color = 0xff0000
        actionTitle = "Item retirado do baú"
    end
    local embed = {
        title = actionTitle .. (inventory and (" - " .. inventory) or ""),
        author = {
            name = playerName .. " (" .. (playerdiscord or "N/A") .. ")",
            icon_url = "https://cdn.discordapp.com/embed/avatars/0.png"
        },
        fields = {
            { name = "Usuário", value = "<@" .. (playerdiscord or "0") .. ">", inline = true },
            { name = "Item", value = payload.fromSlot and payload.fromSlot.name or "Desconhecido", inline = true },
            { name = "Quantidade", value = tostring(payload.fromSlot and payload.fromSlot.count or "?"), inline = true },
            { name = "Metadata", value = payload.fromSlot and json.encode(payload.fromSlot.metadata) or "{}", inline = false },
            { name = "Baú", value = inventory or "Desconhecido", inline = true },
            { name = "CitizenID", value = playerIdentifier or "N/A", inline = true },
            { name = "Coordenadas", value = (playerCoords.x and ('%s, %s, %s'):format(playerCoords.x, playerCoords.y, playerCoords.z) or "0, 0, 0"), inline = false }
        },
        footer = {
            text = "ID: " .. (payload.source or "N/A") .. " | " .. os.date("%d/%m/%Y %H:%M:%S")
        },
        color = color,
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }
    sendWebhook(webhookURL, {embed})
end

ps.registerCallback('md-stashes:server:gotoLoc', function(source, data)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    local loc = json.decode(data.loc)
    local location = vector3(loc.x, loc.y, loc.z)

    SetEntityCoords(GetPlayerPed(src), location.x, location.y, location.z, false, false, false, false)
    return true
end)

-- Events
RegisterNetEvent('md-stashes:server:createStash', function(data)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end

    MySQL.insert('INSERT INTO mdstashes SET loc = ?, name = ?, data = ?', {json.encode(data.coords), data.data.name, json.encode(data.data)})
    Wait(100)
    stashes = MySQL.query.await('SELECT * FROM mdstashes',{})
    TriggerClientEvent('md-stashes:client:newstash', -1)
end)

RegisterNetEvent('md-stashes:server:saveEdit', function(data)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    local formData = data.form

    local oldData = data.id
    oldData.data = json.decode(oldData.data)
    if oldData.data.object then
        formData.object = oldData.data.object
    end

    MySQL.update('UPDATE mdstashes SET name = ?, data = ? WHERE id = ?', {formData.name, json.encode(formData), oldData.id})
    Wait(100)
    stashes = MySQL.query.await('SELECT * FROM mdstashes',{})
    TriggerClientEvent('md-stashes:client:newstash', -1)
end)

ps.versionCheck('md-stashes', 'https://raw.githubusercontent.com/Mustachedom/md-stashes/refs/heads/main/changelog.txt','https://github.com/Mustachedom/md-stashes/')

RegisterNetEvent('md-stashes:server:changeLocation', function(data)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    local id = data.id.id
    local loc = data.loc.coords
    MySQL.update('UPDATE mdstashes SET loc = ? WHERE id = ?', {json.encode(loc), id})
    Wait(100)
    stashes = MySQL.query.await('SELECT * FROM mdstashes',{})
    TriggerClientEvent('md-stashes:client:newstash', -1)
end)

RegisterNetEvent('md-stashes:server:deleteStash', function(data)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    local id = data.id
    MySQL.update('DELETE FROM mdstashes WHERE id = ?', {id})
    Wait(100)
    stashes = MySQL.query.await('SELECT * FROM mdstashes',{})
    TriggerClientEvent('md-stashes:client:newstash', -1)
end)

local function handleRCOREGangs(gangName, gangRank)
    local gangs = exports['rcore_gang']:GetPlayerGang()
    if not gangs then return false end
    if gangs.name ~= gangName then return false end
    for k, v in pairs(gangs.members) do
        if v.identifier == ps.getIdentifier() then
            if v.rankIndex >= gangRank then
                return true
            end
        end
    end
    return false
end

local function checkAllowance(src, data)
    local checks, has = 0, 0
    if not data.gang then
        checks = checks + 1
        has = has + 1
    else
        checks = checks + 1
        if GetResourceState('rcore_gangs') == 'started' then
            if handleRCOREGangs(data.gang, data.gangRank) then
                has = has + 1
            end
        else
            if ps.tableContains(data.gang, ps.getGangName(src)) and ps.getGangData(src, 'grade').level >= data.gangRank then
                has = has + 1
            end
        end
    end
    if not data.job then
        checks = checks + 1
        has = has + 1
    else
        checks = checks + 1
        if ps.tableContains(data.job, ps.getJobName(src)) and ps.getJobData(src, 'grade').level >= data.jobRank then
            has = has + 1
        end
    end
    if not data.item then
        checks = checks + 1
        has = has + 1
    else
        checks = checks + 1
        local need, have = 0, 0
        for k, v in pairs(data.item) do
            need = need + 1
            if ps.hasItem(src, v, 1) then
                have = have + 1
            end
        end
        if need == have then
            has = has + 1
        end
    end
    if not data.identifier then
        checks = checks + 1
        has = has + 1
    else
        checks = checks + 1
        if ps.tableContains(data.identifier, ps.getIdentifier(src)) then
            has = has + 1
        end
    end
    return checks == has
end

RegisterNetEvent('md-stashes:server:openStash', function(id)
    local src = source
    local stashData = stashes[id]
    if not stashData then return end

    local loc = json.decode(stashData.loc)
    local location = vector3(loc.x, loc.y, loc.z)
    if not ps.checkDistance(src, location, 3) then
        ps.warn(ps.lang('Fail.tooFar', ps.getPlayerName(src), 'md-stashes:server:openStash'))
        return
    end

    if not checkAllowance(src, stashData.data) then
        ps.notify(src, ps.lang('Notify.noAccess'), 'error')
        return
    end

    local data = json.decode(stashData.data)
    ps.openStash(src, stashData.name, {
        label = stashData.name,
        slots = data.slots,
        maxweight = data.maxWeight,
    })
end)

-- Commands
if Config.OldData then
    ps.registerCommand('ADjustStashes', {admin = true}, function(source, args, raw)
        local src = source
        if not IsPlayerAceAllowed(src, 'command') then return false end
        local originalData = MySQL.query.await('SELECT * FROM mdstashes',{})
        for i = 1, #originalData do
            local data = json.decode(originalData[i].data)
            local slots = tonumber(data.slots) or Config.Defaults.slots
            local weight = tonumber(data.weight) or Config.Defaults.maxWeight
            local job, gang, citizenid, item = {}, {}, {}, {}
            data.slots = slots
            data.maxWeight = weight
            if data.password == 0 or data.password == '0' or not data.password then
                data.password = false
            end
            if data.citizenid then
                if type(data.citizenid) == 'string' then
                    table.insert(citizenid, data.citizenid)
                    data.identifier = citizenid
                    data.citizenid = nil
                end
            end
            if data.job then
                if type(data.job) == 'string' then
                    table.insert(job, data.job)
                    data.job = job
                    if data.rank then
                        data.jobRank = data.rank
                    else
                        data.jobRank = 0
                    end
                end
            end
            if data.gang then
                if type(data.gang) == 'string' then
                    table.insert(gang, data.gang)
                    data.gang = gang
                    if data.rank then
                        data.gangRank = data.rank
                    else
                        data.gangRank = 0
                    end
                end
            end
            if data.item then
                if type(data.item) == 'string' then
                    table.insert(item, data.item)
                    data.item = item
                end
            end
            data.targetlabel = nil
            data.rank = nil
            data.name = originalData[i].name
            MySQL.update('UPDATE mdstashes SET data = ? WHERE id = ?', {json.encode(data), originalData[i].id})
            Wait(10)
        end
    end)
end

ps.registerCommand('newStash',{admin = true}, function(source, args, raw)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    TriggerClientEvent('md-stashes:client:startNew', src)
end)

ps.registerCommand('editStash', {admin = true}, function(source, args, raw)
    local src = source
    if not IsPlayerAceAllowed(source, 'command') then return false end
    TriggerClientEvent('md-stashes:client:editStash', src)
end)
