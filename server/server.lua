local stashesTable = {}

---------------------------------------------------------------
------------- Permissão Admin
---------------------------------------------------------------
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

---------------------------------------------------------------
------------- banco de Dados & Migração Automática
---------------------------------------------------------------
MySQL.ready(function()
    -- Garante que a tabela existe
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `mri_qstashes` (
            `id` INT NOT NULL PRIMARY KEY,
            `name` VARCHAR(100) NOT NULL,
            `job` VARCHAR(50) DEFAULT '',
            `gang` VARCHAR(50) DEFAULT '',
            `rank` VARCHAR(50) DEFAULT '',
            `item` VARCHAR(50) DEFAULT '',
            `slotSize` INT DEFAULT 50,
            `weight` INT DEFAULT 1000000,
            `password` INT DEFAULT 0,
            `citizenID` VARCHAR(50) DEFAULT '',
            `targetlabel` VARCHAR(100) DEFAULT '',
            `webhookURL` TEXT DEFAULT NULL,
            `loc` TEXT NOT NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]], {}, function()
        -- Verifica se existe data.json local para migrar dados
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "data.json")
        if loadFile and loadFile ~= "" and loadFile ~= "[]" then
            local stashes = json.decode(loadFile)
            if stashes and #stashes > 0 then
                print("^2[mri_Qstashes] Encontrado data.json com " .. #stashes .. " baús. Migrando dados para o banco de dados...^0")
                local count = 0
                for i = 1, #stashes do
                    local v = stashes[i]
                    MySQL.insert([[
                        INSERT IGNORE INTO `mri_qstashes` 
                        (id, name, job, gang, rank, item, slotSize, weight, password, citizenID, targetlabel, webhookURL, loc)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    ]], {
                        v.id, v.name, v.job or "", v.gang or "", tostring(v.rank or ""), v.item or "",
                        v.slotSize or 50, v.weight or 1000000, v.password or 0, v.citizenID or "",
                        v.targetlabel or "", v.webhookURL or "", json.encode(v.loc)
                    }, function()
                        count = count + 1
                        if count == #stashes then
                            print("^2[mri_Qstashes] Migração concluída com sucesso! Backup de segurança criado como data.json.bak^0")
                            SaveResourceFile(GetCurrentResourceName(), "data.json.bak", loadFile, -1)
                            SaveResourceFile(GetCurrentResourceName(), "data.json", "[]", -1) -- limpa o arquivo local
                            LoadStashesData()
                        end
                    end)
                end
            else
                LoadStashesData()
            end
        else
            LoadStashesData()
        end
    end)
end)

---------------------------------------------------------------
------------- data Set (MySQL CRUD)
---------------------------------------------------------------
RegisterNetEvent("insertStashesData", function(input, loc)
    local src = source
    if not isAdmin(src) then return end
    
    local id = math.random(100000, 999999)
    local name = input[1] or ""
    local job = input[2] or ""
    local gang = input[3] or ""
    local rank = input[4] or ""
    local item = input[5] or ""
    local slotSize = tonumber(input[6]) or Config.Defaultslot
    local weight = tonumber(input[7]) or (Config.Defaultweight * 1000)
    local password = tonumber(input[8]) or 0
    local citizenID = input[9] or ""
    local targetlabel = input[10] or locale("createmenu.default10")
    local webhookURL = input[11] or ""

    MySQL.insert([[
        INSERT INTO `mri_qstashes` 
        (id, name, job, gang, rank, item, slotSize, weight, password, citizenID, targetlabel, webhookURL, loc)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        id, name, job, gang, rank, item, slotSize, weight, password, citizenID, targetlabel, webhookURL, json.encode(loc)
    }, function()
        SyncStashes()
    end)
end)

RegisterNetEvent("deleteStashesData", function(id)
    local src = source
    if not isAdmin(src) then return end
    MySQL.query('DELETE FROM `mri_qstashes` WHERE id = ?', { id }, function()
        SyncStashes()
    end)
end)

-- Evento para atualizar formulário completo
RegisterNetEvent("updateStashesData", function(id, input)
    local src = source
    if not isAdmin(src) then return end
    
    local name = input[1]
    local job = input[2] or ""
    local gang = input[3] or ""
    local rank = input[4] or ""
    local item = input[5] or ""
    local slotSize = tonumber(input[6]) or Config.Defaultslot
    local weight = tonumber(input[7]) or (Config.Defaultweight * 1000)
    local password = tonumber(input[8]) or 0
    local citizenID = input[9] or ""
    local targetlabel = input[10] or ""
    local webhookURL = input[11] or ""

    MySQL.query([[
        UPDATE `mri_qstashes` 
        SET name = ?, job = ?, gang = ?, rank = ?, item = ?, slotSize = ?, weight = ?, password = ?, citizenID = ?, targetlabel = ?, webhookURL = ?
        WHERE id = ?
    ]], {
        name, job, gang, rank, item, slotSize, weight, password, citizenID, targetlabel, webhookURL, id
    }, function()
        SyncStashes()
    end)
end)

-- Evento para atualizar localização (Mover)
RegisterNetEvent("updateStashLocation", function(id, newLoc)
    local src = source
    if not isAdmin(src) then return end
    MySQL.query('UPDATE `mri_qstashes` SET loc = ? WHERE id = ?', { json.encode(newLoc), id }, function()
        SyncStashes()
    end)
end)

-- Nosso evento flexível (atualiza campos individuais)
RegisterNetEvent("mri_Qstashes:server:updateStash", function(id, fields)
    local src = source
    if not isAdmin(src) then return end
    
    local queryParts = {}
    local params = {}
    for k, v in pairs(fields) do
        if k == "loc" then
            table.insert(queryParts, "`loc` = ?")
            table.insert(params, json.encode(v))
        else
            table.insert(queryParts, "`" .. k .. "` = ?")
            table.insert(params, v)
        end
    end
    
    if #queryParts > 0 then
        table.insert(params, id)
        local sql = "UPDATE `mri_qstashes` SET " .. table.concat(queryParts, ", ") .. " WHERE id = ?"
        MySQL.query(sql, params, function()
            SyncStashes()
        end)
    end
end)

---------------------------------------------------------------
------------- core Functions
---------------------------------------------------------------
function SyncStashes()
    MySQL.query('SELECT * FROM `mri_qstashes`', {}, function(results)
        if results then
            local oldStashesTable = stashesTable
            stashesTable = {}
            for i = 1, #results do
                local row = results[i]
                stashesTable[#stashesTable + 1] = {
                    id = row.id,
                    name = row.name,
                    job = row.job,
                    gang = row.gang,
                    rank = row.rank,
                    item = row.item,
                    slotSize = row.slotSize,
                    weight = row.weight,
                    password = row.password,
                    citizenID = row.citizenID,
                    targetlabel = row.targetlabel,
                    webhookURL = row.webhookURL,
                    loc = json.decode(row.loc)
                }
            end
            
            -- Sincroniza clientes
            TriggerClientEvent("mri_Qstashes:delete", -1, oldStashesTable)
            TriggerClientEvent('mri_Qstashes:start', -1, stashesTable)
            
            -- Registra baús no inventário
            RegisterStashData()
        end
    end)
end

function LoadStashesData()
    SyncStashes()
end

local hooksRegistered = false
local function RegisterHookData()
    if hooksRegistered then return end
    hooksRegistered = true
    
    -- Registra apenas 1 hook global inteligente no ox_inventory
    exports.ox_inventory:registerHook('swapItems', function(payload)
        local stashId = nil
        if payload.fromInventory and string.find(payload.fromInventory, "^mri_Qstashes") then
            stashId = payload.fromInventory
        elseif payload.toInventory and string.find(payload.toInventory, "^mri_Qstashes") and payload.action == "move" then
            stashId = payload.toInventory
        end

        if stashId then
            local numericId = tonumber(string.match(stashId, "%d+"))
            local stash = nil
            for i = 1, #stashesTable do
                if stashesTable[i].id == numericId then
                    stash = stashesTable[i]
                    break
                end
            end

            if stash and stash.webhookURL and stash.webhookURL ~= "" then
                local label = stash.name or stashId
                WebhookPlayer(payload, stash.webhookURL, label)
            end
        end
    end, {})
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
    end
    RegisterHookData()
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
------------- Webhook Discord
---------------------------------------------------------------
local function sendWebhook(webhook, data)
    if webhook == nil then
        print('^1[logs] ^0Webhook ' .. tostring(webhook) .. ' does not exist.')
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
            { name = "Usuário",     value = "<@" .. (playerdiscord or "0") .. ">",                                      inline = true },
            { name = "Item",        value = payload.fromSlot and payload.fromSlot.name or "Desconhecido",               inline = true },
            { name = "Quantidade",  value = tostring(payload.fromSlot and payload.fromSlot.count or "?"),               inline = true },
            { name = "Metadata",    value = payload.fromSlot and json.encode(payload.fromSlot.metadata) or "{}",        inline = false },
            { name = "Baú",         value = inventory or "Desconhecido",                                                inline = true },
            { name = "CitizenID",   value = playerIdentifier or "N/A",                                                 inline = true },
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

---------------------------------------------------------------
------------- Comando Admin
---------------------------------------------------------------
lib.addCommand(Config.Command, {
    help = locale("command.help"),
    restricted = 'group.admin'
}, function(source, args, raw)
    local src = source
    TriggerClientEvent('mri_Qstashes:openAdm', src)
end)
