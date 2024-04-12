---------------------------------------------------------------
------------- data Set
---------------------------------------------------------------
local stashesTable = {}

RegisterNetEvent("insertStashesData", function(input, loc)
    stashesTable[#stashesTable + 1] = {
        id = math.random(100000,999999),
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
        loc = loc or nil,
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
    RegisterStashData()
end

function LoadStashesData()
    local loadFile = LoadResourceFile(GetCurrentResourceName(), "./data.json")
    if loadFile then
        stashesTable = json.decode(loadFile)
    end
    RegisterStashData()
end

function RegisterStashData()
    for k, v in pairs (stashesTable) do 
        local stash = {
        id = "mri_Qstashes"..v.id,
        label = v.name,
        slots = v.slotSize,
        weight = tonumber(v.weight),
        }
        exports.ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight)
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
        Wait(1000)
        TriggerClientEvent('mri_Qstashes:start', -1, stashesTable)
        print("[mri_Qstashes] - Loaded database.")
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
    restricted = 'group.admin',
}, function(source, args, raw)
    local src = source
    TriggerClientEvent('mri_Qstashes:openAdm', src)
end)
