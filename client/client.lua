RegisterNetEvent("mri_Qstashes:openAdm", function()
    if not lib.callback.await('mri_Qstashes:isAdmin', false) then
        lib.notify({ type = 'error', description = 'Acesso negado: apenas administradores.' })
        return
    end
    local stashes = lib.callback.await('stashesGetAll', false)
    local options = {
        {
            title = locale("openadm.options_title") or 'Criar novo baú',
            icon = 'hand',
            description = locale("openadm.options_description") or 'Clique para criar um novo baú',
            onSelect = function()
                TriggerEvent('mri_Qstashes:client:doray')
            end
        }
    }
    for i = 1, #stashes do
        options[#options + 1] = {
            title = stashes[i].name,
            icon = 'box',
            description = "Clique para gerenciar este baú",
            onSelect = function()
                local stash = stashes[i]
                lib.registerContext({
                    id = 'stash_manage_' .. stash.id,
                    title = stash.name .. ' - Gerenciar',
                    options = {
                        {
                            title = 'Editar',
                            icon = 'edit',
                            description = 'Editar este baú',
                            onSelect = function()
                                local input = lib.inputDialog(locale("createmenu.title"), {{
                                    type = 'input',
                                    label = locale("createmenu.input1"),
                                    description = locale("createmenu.description1"),
                                    default = stash.name or ""
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input2"),
                                    description = locale("createmenu.description2"),
                                    default = stash.job or ""
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input3"),
                                    description = locale("createmenu.description3"),
                                    default = stash.gang or ""
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input4"),
                                    description = locale("createmenu.description4"),
                                    default = stash.rank or ""
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input5"),
                                    description = locale("createmenu.description5"),
                                    default = stash.item or ""
                                }, {
                                    type = 'number',
                                    label = locale("createmenu.input6"),
                                    description = locale("createmenu.description6"),
                                    default = stash.slotSize or Config.Defaultslot
                                }, {
                                    type = 'number',
                                    label = locale("createmenu.input7"),
                                    description = locale("createmenu.description7"),
                                    default = (stash.weight and math.floor(tonumber(stash.weight)/1000)) or Config.Defaultweight
                                }, {
                                    type = 'number',
                                    label = locale("createmenu.input8"),
                                    description = locale("createmenu.description8"),
                                    default = stash.password or 0
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input9"),
                                    description = locale("createmenu.description9"),
                                    default = stash.citizenID or ""
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input10"),
                                    description = locale("createmenu.description10"),
                                    default = stash.targetlabel or Config.DefaultMessage
                                }, {
                                    type = 'input',
                                    label = locale("createmenu.input11"),
                                    description = locale("createmenu.description11"),
                                    default = stash.webhookURL or ""
                                }})
                                if input and input[1] ~= "" then
                                    if input[6] == nil then input[6] = Config.Defaultslot end
                                    if input[7] == nil then input[7] = Config.Defaultweight * 1000 else input[7] = input[7] * 1000 end
                                    TriggerServerEvent("updateStashesData", stash.id, input)
                                    lib.notify({
                                        type = 'success',
                                        description = locale("createmenu.notify_sucess")
                                    })
                                else
                                    lib.notify({
                                        type = 'error',
                                        description = locale("createmenu.notify_error")
                                    })
                                end
                            end
                        },
                        {
                            title = 'Teleportar',
                            icon = 'fa-solid fa-location-dot',
                            description = 'Teleportar para este baú',
                            onSelect = function()
                                SetEntityCoords(cache.ped, stash.loc.x, stash.loc.y, stash.loc.z)
                                lib.notify({
                                    title = 'Teleportado',
                                    description = 'Você foi teleportado para o baú ' .. stash.name,
                                    type = 'success'
                                })
                            end
                        },
                        {
                            title = 'Mover',
                            icon = 'fa-solid fa-arrows-up-down-left-right',
                            description = 'Alterar a localização deste baú',
                            onSelect = function()
                                local newLoc = StartRay()
                                if newLoc then
                                    TriggerServerEvent('updateStashLocation', stash.id, newLoc)
                                    lib.notify({
                                        type = 'success',
                                        description = 'Localização do baú atualizada!'
                                    })
                                else
                                    lib.notify({
                                        type = 'error',
                                        description = 'Ação cancelada.'
                                    })
                                end
                            end
                        },
                        {
                            title = 'Excluir',
                            icon = 'trash',
                            description = 'Excluir este baú',
                            onSelect = function()
                                local deleted = TriggerServerEvent("deleteStashesData", stash.id)
                                if not deleted then
                                    lib.notify({
                                        title = locale("openadm.title"),
                                        description = locale("openadm.options3_description3"),
                                        type = 'success'
                                    })
                                else
                                    lib.notify({
                                        title = locale("openadm.title"),
                                        description = locale("openadm.options3_description4"),
                                        type = 'error'
                                    })
                                end
                            end
                        }
                    }
                })
                lib.showContext('stash_manage_' .. stash.id)
            end
        }
    end
    lib.registerContext({
        id = 'stashes_manage',
        title = locale("openadm.title") or 'Gerenciar Baús',
        options = options
    })
    lib.showContext('stashes_manage')
end)

stashes = {}
RegisterNetEvent('mri_Qstashes:start', function(stashesTable)
    Citizen.Wait(500)
    for k, v in pairs(stashesTable) do
        if v.job == nil then
            v.job = ""
        end
        if v.gang == nil then
            v.gang = ""
        end
        if v.targetlabel == "" then
            v.targetlabel = Config.DefaultMessage
        end
        if v.weight == nil or "" then
            v.weight = Config.Defaultweight * 1000
        end
        if v.weight then
            v.weight = tonumber(v.weight) * 1000
        end
        if v.slots == nil or "" then
            v.slots = Config.Defaultslot
        end
        if v.item == nil or "" then
            v.item = 1
        end
        if v.cid == nil or "" then
            v.cid = 2
        end
        if v.rank then
            v.rank = tonumber(v.rank)
        end
        if v.rank == nil then
            v.rank = 0
        end
        if v.password == nil then
            v.password = 0
        end
        if v.webhook == nil then
            v.webhook = ""
        end
        stashes[k] = exports.ox_target:addBoxZone({
            coords = v.loc,
            size = vec(1, 1, 5),
            rotation = 0,
            debug = Config.Debug,
            options = {{
                name = 'openstashes',
                icon = "fa-solid fa-box-open",
                label = v.targetlabel,
                distance = 4.5,
                onSelect = function()
                    if v.password ~= 0 then
                        local input = lib.inputDialog(locale("target.input"), {{
                            type = 'number',
                            label = locale("target.label"),
                            description = locale("target.description"),
                            min = 1,
                            max = 99999,
                            required = true
                        }})
                        if input == nil then
                            return
                        end
                        local combo = tonumber(input[1]) or 0
                        if v.password == combo then
                            exports.ox_inventory:openInventory('stash', {
                                id = "mri_Qstashes" .. v.id
                            })
                        end
                    else
                        exports.ox_inventory:openInventory('stash', {
                            id = "mri_Qstashes" .. v.id
                        })
                    end
                end,
                canInteract = function()
                    if QBX.PlayerData.job.name == v.job or v.job == "" then
                        if QBX.PlayerData.job.grade.level >= v.rank or v.job == "" then
                            if QBX.PlayerData.gang.name == v.gang and QBX.PlayerData.gang.grade.level >= v.rank or
                                v.gang == "" then
                                if v.item == 1 or QBX.HasItem(v.item) then
                                    if QBX.PlayerData.citizenid == v.cid or v.cid == 2 then
                                        return true
                                    end
                                end
                            end
                        end
                    end
                end
            }}
        })
    end
    print("[mri_Qstashes] - Loaded database.")
end)

RegisterNetEvent('mri_Qstashes:delete', function(stashesTable)
    if stashes == {} or nil then
        return
    end
    local table = stashesTable
    for i = 1, #table + 1 do
        if stashes[i] ~= nil then
            exports.ox_target:removeZone(stashes[i])
        end
    end
    stashes = {}
end)

function StartRay()
    local run = true
    while run do
        local hit, entity, endCoords = lib.raycast.cam(1 | 16)
        lib.showTextUI(locale("raycast.title") .. '  \n X:  ' .. endCoords.x .. ',  \n Y:  ' .. endCoords.y ..
                           ',  \n Z:  ' .. endCoords.z .. '  \n ' .. locale("raycast.e_button") .. '  \n  ' ..
                           locale("raycast.del_button"))
        DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 42, 24,
            100, false, false, 0, true, false, false, false)
        if IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            run = false
            return endCoords
        end
        if IsControlJustReleased(0, 178) then
            lib.hideTextUI()
            run = false
            return nil
        end
    end
end

RegisterNetEvent('mri_Qstashes:client:doray', function()
    if not lib.callback.await('mri_Qstashes:isAdmin', false) then
        lib.notify({ type = 'error', description = 'Acesso negado: apenas administradores.' })
        return
    end
    local stashmake = StartRay()
    if stashmake ~= nil then
        local input = lib.inputDialog(locale("createmenu.title"), {{
            type = 'input',
            label = locale("createmenu.input1"),
            description = locale("createmenu.description1"),
            required = true
        }, {
            type = 'input',
            label = locale("createmenu.input2"),
            description = locale("createmenu.description2")
        }, {
            type = 'input',
            label = locale("createmenu.input3"),
            description = locale("createmenu.description3")
        }, {
            type = 'input',
            label = locale("createmenu.input4"),
            description = locale("createmenu.description4")
        }, {
            type = 'input',
            label = locale("createmenu.input5"),
            description = locale("createmenu.description5")
        }, {
            type = 'number',
            label = locale("createmenu.input6"),
            description = locale("createmenu.description6") .. ' - default: ' .. Config.Defaultslot .. ' Slots)'
        }, {
            type = 'number',
            label = locale("createmenu.input7"),
            description = locale("createmenu.description7") .. ' - default: ' .. Config.Defaultweight .. ' Kg)',
            min = 1,
            max = 999999999
        }, {
            type = 'number',
            label = locale("createmenu.input8"),
            description = locale("createmenu.description8"),
            min = 1,
            max = 99999
        }, {
            type = 'input',
            label = locale("createmenu.input9"),
            description = locale("createmenu.description9")
        }, {
            type = 'input',
            label = locale("createmenu.input10"),
            description = locale("createmenu.")
        }, {
            type = 'input',
            label = locale("createmenu.input11"),
            description = locale("createmenu.description11")
        }})
        if input and input[1] ~= "" then
            if input[6] == nil then
                input[6] = Config.Defaultslot
            end
            if input[7] == nil then
                input[7] = Config.Defaultweight * 1000
            else
                input[7] = input[7] * 1000
            end
            TriggerServerEvent("insertStashesData", input, stashmake)
            lib.notify({
                type = 'success',
                description = locale("createmenu.notify_sucess")
            })
            
        else
            lib.notify({
                type = 'error',
                description = locale("createmenu.notify_error")
            })
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("mri_Qstashes:server:Load")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    TriggerServerEvent("mri_Qstashes:server:Unload")
end)


