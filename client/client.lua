local isAdminCache = false

<<<<<<< fork
local function updateAdminStatus()
    isAdminCache = lib.callback.await('mri_Qstashes:isAdmin', false)
||||||| base

CreateThread(function()
    for k, v in pairs (Config.stash) do 
		if v.job == nil then v.job = 1 end
		if v.gang == nil then v.gang = 1 end
		if v.targetlabel == nil then v.targetlabel = "Open Stash" end
		if v.weight == nil then v.weight = Config.Defaultweight end
		if v.slots == nil then v.slots = Config.Defaultslot end
		if v.item == nil then v.item = 1 end
		if v.cid == nil then v.cid = 2 end
		if v.rank == nil then v.rank = 0 end
		if v.password == nil then v.password = 0 end
		if Config.OxTarget then
			stashes = exports.ox_target:addBoxZone({
				coords = v.loc,
				size = vec(1,1,2),
				rotation = 0,
				debug = false,
				options = {
					{
						name = 'openstashes',
						icon = "fas fa-sign-in-alt",
						label = v.targetlabel,
						distance = 2.5,
						onSelect = function()
							if v.password ~= 0 then
								local input = lib.inputDialog('Password', {
									 {type = 'input', label = 'Password', description = 'What Is The Password', required = true},
								})
								local combo = input[1]
								if v.password == combo then
									if Config.OxInv then
										exports.ox_inventory:openInventory('stash', {id = k})
									else	
										Wait(100)
										TriggerEvent("inventory:client:SetCurrentStash", k)
										TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
											maxweight = v.weight,
											slots = v.slots,
										})
									end	
								end	
							else
								if Config.OxInv then
									exports.ox_inventory:openInventory('stash', {id = k})
								else	
									Wait(100)
									TriggerEvent("inventory:client:SetCurrentStash", k)
									TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
										maxweight = v.weight,
										slots = v.slots,
									})
								end	
							end
						end,
						 canInteract = function()
							if QBCore.Functions.GetPlayerData().job.name == v.job and QBCore.Functions.GetPlayerData().job.grade.level >= v.rank or v.job == 1 then
								if QBCore.Functions.GetPlayerData().gang.name == v.gang and QBCore.Functions.GetPlayerData().gang.grade.level >= v.rank or v.gang == 1 then
									if v.item == 1 or QBCore.Functions.HasItem(v.item) then
										if QBCore.Functions.GetPlayerData().citizenid == v.cid or v.cid == 2 then
										return true end
									end	
								end	
							end	
						end
			
					},
				},
			})
		elseif Config.interact then
			exports.interact:AddInteraction({
				coords = v.loc,
				distance = 8.0, -- optional
				interactDst = 2.0, -- optional
				id = 'mdstashes'..k, -- needed for removing interactions
				name = 'mdstashes'..k, -- optional
				options = {
					{
						label = v.targetlabel,
						action = function()
							if v.password ~= 0 then
								local input = lib.inputDialog('Password', {
									 {type = 'input', label = 'Password', description = 'What Is The Password', required = true},
								})
								local combo = input[1]
								if v.password == combo then
									if Config.OxInv then
										exports.ox_inventory:openInventory('stash', {id = k})
									else	
										Wait(100)
										TriggerEvent("inventory:client:SetCurrentStash", k)
										TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
											maxweight = v.weight,
											slots = v.slots,
										})
									end	
								end	
							else
								if Config.OxInv then
									exports.ox_inventory:openInventory('stash', {id = k})
								else	
									Wait(100)
									TriggerEvent("inventory:client:SetCurrentStash", k)
									TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
										maxweight = v.weight,
										slots = v.slots,
									})
								end	
							end
						end,
						 canInteract = function()
							if QBCore.Functions.GetPlayerData().job.name == v.job and QBCore.Functions.GetPlayerData().job.grade.level >= v.rank or v.job == 1 then
								if QBCore.Functions.GetPlayerData().gang.name == v.gang and QBCore.Functions.GetPlayerData().gang.grade.level >= v.rank or v.gang == 1 then
									if v.item == 1 or QBCore.Functions.HasItem(v.item) then
										if QBCore.Functions.GetPlayerData().citizenid == v.cid or v.cid == 2 then
										return true end
									end	
								end	
							end	
						end
					},
				}
			})
		else
    	    exports['qb-target']:AddBoxZone('mdstashes'..k, v.loc, 1.5, 1.75, { -- 963.37, -2122.95, 31.47
			name = 'mdstashes'..k,
			minZ = v.loc.z-2,
			maxZ = v.loc.z+2,
			}, {
			options = {
				{
					icon = "fas fa-sign-in-alt",
					label = v.targetlabel,
					action = function()
						if v.password ~= 0 then
							local input = lib.inputDialog('Password', {
								 {type = 'input', label = 'Password', description = 'What Is The Password', required = true},
							})
							local combo = input[1]
							if v.password == combo then
								if Config.OxInv then
									exports.ox_inventory:openInventory('stash', {id = k})
								else	
									Wait(100)
									TriggerEvent("inventory:client:SetCurrentStash", k)
									TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
										maxweight = v.weight,
										slots = v.slots,
									})
								end	
							end	
						else
							if Config.OxInv then
								exports.ox_inventory:openInventory('stash', {id = k})
							else	
								Wait(100)
								TriggerEvent("inventory:client:SetCurrentStash", k)
								TriggerServerEvent("inventory:server:OpenInventory", "stash", k, {
									maxweight = v.weight,
									slots = v.slots,
								})
							end	
						end
					end,
					 canInteract = function()
						if QBCore.Functions.GetPlayerData().job.name == v.job and QBCore.Functions.GetPlayerData().job.grade.level >= v.rank or v.job == 1 then
							if QBCore.Functions.GetPlayerData().gang.name == v.gang and QBCore.Functions.GetPlayerData().gang.grade.level >= v.rank or v.gang == 1 then
								if v.item == 1 or QBCore.Functions.HasItem(v.item) then
									if QBCore.Functions.GetPlayerData().citizenid == v.cid or v.cid == 2 then
									return true end
								end	
							end	
						end	
					end
				},
			},
			distance = 2.5
		})
	end	
=======
local props = {}

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
>>>>>>> upstream
end
<<<<<<< fork

-- Atualiza ao iniciar o script
CreateThread(function()
    updateAdminStatus()
end)

-- Atualiza ao logar
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    updateAdminStatus()
    TriggerServerEvent("mri_Qstashes:server:Load")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    isAdminCache = false
    TriggerServerEvent("mri_Qstashes:server:Unload")
end)

RegisterNetEvent("mri_Qstashes:openAdm", function(searchTerm)
    if not isAdminCache then
        lib.notify({ type = 'error', description = locale("error.admin_only") })
        return
    end
    local stashes = lib.callback.await('stashesGetAll', false)
    local options = {
        {
            title = locale("menu.search_title"),
            icon = 'search',
            description = locale("menu.search_description"),
            onSelect = function()
                local input = lib.inputDialog(locale("menu.search_title"), {{
                    type = 'input',
                    label = locale("menu.search_input_label"),
                    description = locale("menu.search_input_desc")
                }})
                if input and input[1] and input[1] ~= '' then
                    TriggerEvent('mri_Qstashes:openAdm', input[1])
                end
            end
        },
        {
            title = locale("menu.create_title"),
            icon = 'hand',
            description = locale("menu.create_description"),
            onSelect = function()
                TriggerEvent('mri_Qstashes:client:doray')
            end
        }
    }
    local lower = function(str) return (str or ''):lower() end
    for i = 1, #stashes do
        local s = stashes[i]
        local match = true
        if searchTerm then
            local term = lower(searchTerm)
            match = lower(s.name):find(term, 1, true)
                or lower(s.job):find(term, 1, true)
                or lower(s.gang):find(term, 1, true)
                or lower(s.citizenID):find(term, 1, true)
                or (s.item and tostring(s.item):find(term, 1, true))
                or (s.rank and tostring(s.rank):find(term, 1, true))
                or (s.weight and tostring(s.weight):find(term, 1, true))
        end
        if (not searchTerm) or match then
            options[#options + 1] = {
                title = s.name,
                icon = 'box',
                description = (function()
                    local desc = {}
                    if s.weight and s.weight ~= '' and tonumber(s.weight) and tonumber(s.weight) > 0 then
                        table.insert(desc, locale("desc.weight") .. math.floor(tonumber(s.weight)/1000) .. locale("desc.kg"))
                    end
                    if s.slotSize then
                        table.insert(desc, locale("desc.slots") .. s.slotSize)
                    end
                    if s.citizenID and s.citizenID ~= '' then
                        table.insert(desc, locale("desc.cid") .. s.citizenID)
                    end
                    if s.job and s.job ~= '' then
                        table.insert(desc, locale("desc.job") .. s.job)
                    end
                    if s.gang and s.gang ~= '' then
                        table.insert(desc, locale("desc.gang") .. s.gang)
                    end
                    if s.rank and s.rank ~= '' and tonumber(s.rank) and tonumber(s.rank) > 0 then
                        table.insert(desc, locale("desc.rank") .. s.rank)
                    end
                    if s.item and s.item ~= '' and s.item ~= 1 then
                        table.insert(desc, locale("desc.item") .. s.item)
                    end
                    if s.password and s.password ~= '' and tonumber(s.password) and tonumber(s.password) > 0 then
                        table.insert(desc, locale("desc.senha"))
                    end
                    return table.concat(desc, ' | ')
                end)(),
                onSelect = function()
                    local stash = s
                    lib.registerContext({
                        id = 'stash_manage_' .. stash.id,
                        title = stash.name .. ' - ' .. locale("submenu.edit_desc"),
                        options = {
                            {
                                title = locale("submenu.edit"),
                                icon = 'edit',
                                description = locale("submenu.edit_desc"),
                                onSelect = function()
                                    local input = lib.inputDialog(locale("createmenu.title"), {
                                        { type = 'input', label = locale("createmenu.input1"), description = locale("createmenu.description1"), default = stash.name or "" },
                                        { type = 'input', label = locale("createmenu.input2"), description = locale("createmenu.description2"), default = stash.job or "" },
                                        { type = 'input', label = locale("createmenu.input3"), description = locale("createmenu.description3"), default = stash.gang or "" },
                                        { type = 'input', label = locale("createmenu.input4"), description = locale("createmenu.description4"), default = stash.rank or "" },
                                        { type = 'input', label = locale("createmenu.input5"), description = locale("createmenu.description5"), default = stash.item or "" },
                                        { type = 'number', label = locale("createmenu.input6"), description = locale("createmenu.description6"), default = stash.slotSize or Config.Defaultslot },
                                        { type = 'number', label = locale("createmenu.input7"), description = locale("createmenu.description7"), default = (stash.weight and math.floor(tonumber(stash.weight)/1000)) or Config.Defaultweight },
                                        { type = 'number', label = locale("createmenu.input8"), description = locale("createmenu.description8"), default = stash.password or 0 },
                                        { type = 'input', label = locale("createmenu.input9"), description = locale("createmenu.description9"), default = stash.citizenID or "" },
                                        { type = 'input', label = locale("createmenu.input10"), description = locale("createmenu.description10"), default = stash.targetlabel or Config.DefaultMessage },
                                        { type = 'input', label = locale("createmenu.input11"), description = locale("createmenu.description11"), default = stash.webhookURL or "" }
                                    })
                                    if input and input[1] ~= "" then
                                        if input[6] == nil then input[6] = Config.Defaultslot end
                                        if input[7] == nil then input[7] = Config.Defaultweight * 1000 else input[7] = input[7] * 1000 end
                                        TriggerServerEvent("updateStashesData", stash.id, input)
                                        lib.notify({ type = 'success', description = locale("createmenu.notify_sucess") })
                                    else
                                        lib.notify({ type = 'error', description = locale("createmenu.notify_error") })
                                    end
                                end
                            },
                            {
                                title = locale("submenu.move"),
                                icon = 'fa-solid fa-arrows-up-down-left-right',
                                description = locale("submenu.move_desc"),
                                onSelect = function()
                                    local newLoc = StartRay()
                                    if newLoc then
                                        TriggerServerEvent('updateStashLocation', stash.id, newLoc)
                                        lib.notify({ type = 'success', description = locale("submenu.move_success") })
                                    else
                                        lib.notify({ type = 'error', description = locale("submenu.move_cancel") })
                                    end
                                end
                            },
                            {
                                title = locale("submenu.teleport"),
                                icon = 'fa-solid fa-location-dot',
                                description = locale("submenu.teleport_desc"),
                                onSelect = function()
                                    SetEntityCoords(cache.ped, stash.loc.x, stash.loc.y, stash.loc.z)
                                    lib.notify({ type = 'success', description = locale("submenu.teleport_success") .. stash.name })
                                end
                            },
                            {
                                title = locale("submenu.delete"),
                                icon = 'trash',
                                description = locale("submenu.delete_desc"),
                                onSelect = function()
                                    local result = lib.alertDialog({
                                        header = locale("submenu.delete_confirm"),
                                        content = '',
                                        centered = true,
                                        cancel = true,
                                        size = 'sm',
                                        labels = { confirm = locale("submenu.delete") }
                                    })
                                    if result == 'confirm' then
                                        TriggerServerEvent("deleteStashesData", stash.id)
                                        lib.notify({ type = 'success', description = locale("openadm.options3_description3") })
                                    end
                                end
                            }
                        }
                    })
                    lib.showContext('stash_manage_' .. stash.id)
                end
            }
        end
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
                            type = 'input',
                            label = locale("target.label"),
                            description = locale("target.description"),
                            password = true,
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
            },
            {
                name = 'editstash',
                icon = 'fa-solid fa-pen-to-square',
                label = locale("submenu.edit"),
                distance = 4.5,
                onSelect = function()
                    -- Abrir diretamente o submenu do baú
                    local stash = v
                    lib.registerContext({
                        id = 'stash_manage_' .. stash.id,
                        title = stash.name .. ' - ' .. locale("submenu.edit_desc"),
                        options = {
                            {
                                title = locale("submenu.edit"),
                                icon = 'edit',
                                description = locale("submenu.edit_desc"),
                                onSelect = function()
                                    local input = lib.inputDialog(locale("createmenu.title"), {
                                        { type = 'input', label = locale("createmenu.input1"), description = locale("createmenu.description1"), default = stash.name or "" },
                                        { type = 'input', label = locale("createmenu.input2"), description = locale("createmenu.description2"), default = stash.job or "" },
                                        { type = 'input', label = locale("createmenu.input3"), description = locale("createmenu.description3"), default = stash.gang or "" },
                                        { type = 'input', label = locale("createmenu.input4"), description = locale("createmenu.description4"), default = stash.rank or "" },
                                        { type = 'input', label = locale("createmenu.input5"), description = locale("createmenu.description5"), default = stash.item or "" },
                                        { type = 'number', label = locale("createmenu.input6"), description = locale("createmenu.description6"), default = stash.slotSize or Config.Defaultslot },
                                        { type = 'number', label = locale("createmenu.input7"), description = locale("createmenu.description7"), default = (stash.weight and math.floor(tonumber(stash.weight)/1000)) or Config.Defaultweight },
                                        { type = 'number', label = locale("createmenu.input8"), description = locale("createmenu.description8"), default = stash.password or 0 },
                                        { type = 'input', label = locale("createmenu.input9"), description = locale("createmenu.description9"), default = stash.citizenID or "" },
                                        { type = 'input', label = locale("createmenu.input10"), description = locale("createmenu.description10"), default = stash.targetlabel or Config.DefaultMessage },
                                        { type = 'input', label = locale("createmenu.input11"), description = locale("createmenu.description11"), default = stash.webhookURL or "" }
                                    })
                                    if input and input[1] ~= "" then
                                        if input[6] == nil then input[6] = Config.Defaultslot end
                                        if input[7] == nil then input[7] = Config.Defaultweight * 1000 else input[7] = input[7] * 1000 end
                                        TriggerServerEvent("updateStashesData", stash.id, input)
                                        lib.notify({ type = 'success', description = locale("createmenu.notify_sucess") })
                                    else
                                        lib.notify({ type = 'error', description = locale("createmenu.notify_error") })
                                    end
                                end
                            },
                            {
                                title = locale("submenu.move"),
                                icon = 'fa-solid fa-arrows-up-down-left-right',
                                description = locale("submenu.move_desc"),
                                onSelect = function()
                                    local newLoc = StartRay()
                                    if newLoc then
                                        TriggerServerEvent('updateStashLocation', stash.id, newLoc)
                                        lib.notify({ type = 'success', description = locale("submenu.move_success") })
                                    else
                                        lib.notify({ type = 'error', description = locale("submenu.move_cancel") })
                                    end
                                end
                            },
                            {
                                title = locale("submenu.teleport"),
                                icon = 'fa-solid fa-location-dot',
                                description = locale("submenu.teleport_desc"),
                                onSelect = function()
                                    SetEntityCoords(cache.ped, stash.loc.x, stash.loc.y, stash.loc.z)
                                    lib.notify({ type = 'success', description = locale("submenu.teleport_success") .. stash.name })
                                end
                            },
                            {
                                title = locale("submenu.delete"),
                                icon = 'trash',
                                description = locale("submenu.delete_desc"),
                                onSelect = function()
                                    local result = lib.alertDialog({
                                        header = locale("submenu.delete_confirm"),
                                        content = '',
                                        centered = true,
                                        cancel = true,
                                        size = 'sm',
                                        labels = { confirm = locale("submenu.delete") }
                                    })
                                    if result == 'confirm' then
                                        TriggerServerEvent("deleteStashesData", stash.id)
                                        lib.notify({ type = 'success', description = locale("openadm.options3_description3") })
                                    end
                                end
                            }
                        }
                    })
                    lib.showContext('stash_manage_' .. stash.id)
                end,
                canInteract = function()
                    return isAdminCache
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
||||||| base
end)
=======
>>>>>>> upstream

<<<<<<< fork
function StartRay()
    local run = true
    while run do
        local hit, entity, endCoords = lib.raycast.cam(1 | 16)
        local coordsText = string.format(
            locale("raycast.title") .. '  \n X:  %.2f,  \n Y:  %.2f,  \n Z:  %.2f  \n %s  \n  %s',
            endCoords.x, endCoords.y, endCoords.z, locale("raycast.e_button"), locale("raycast.del_button")
        )
        lib.showTextUI(coordsText, {icon = 'fa-solid fa-location-dot'})
        DrawMarker(28, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 255, 42, 24,
            100, false, false, 0, true, false, false, false)
        if IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            run = false
            return endCoords
||||||| base
function StartRay()
    local run = true
    while run do
        local Wait = 1
        local hit, entityHit, endCoords, surfaceNormal, matHash = lib.raycast.cam(511, 4, 10)
        lib.showTextUI('Raycast Coords:  \n X:  ' ..
        endCoords.x .. ',  \n Y:  ' .. endCoords.y .. ',  \n Z:  ' .. endCoords.z .. '  \n[E] to copy  \n[DEL] to cancel')
        DrawMarker(21, endCoords.x, endCoords.y, endCoords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.1, 0.1, 0.1, 255, 255,
        255, 255, false, true, 2, nil, nil, false, false)
        if IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            run = false
            return endCoords
=======
local function check(data)
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
            if ps.tableContains(data.gang, ps.getGangName()) and ps.getGangData('grade').level >= data.gangRank then
                has = has + 1
            end
>>>>>>> upstream
        end
<<<<<<< fork
        -- BACKSPACE = 194
        if IsControlJustReleased(0, 194) then
            lib.hideTextUI()
            run = false
            return nil
||||||| base

        if IsControlJustReleased(0, 178) then
            lib.hideTextUI()
            run = false
            return nil
=======
    end
    if not data.job then
        checks = checks + 1
        has = has + 1
    else
        checks = checks + 1
        if GetResourceState('es_extended') == 'started' then
            if ps.tableContains(data.job, ps.getJobName()) and ps.getJobData('grade') >= data.jobRank then
                has = has + 1
            end
        else
            if ps.tableContains(data.job, ps.getJobName()) and ps.getJobData('grade').level >= data.jobRank then
                has = has + 1
            end
>>>>>>> upstream
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
            if ps.hasItem(v) then
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
        if ps.tableContains(data.identifier, ps.getIdentifier()) then
            has = has + 1
        end
    end
    return checks == has
end

local targets = {}

local function checkPassword(pass, id)
    if not pass or pass == '' then return true end
    local submitPass = ps.input(ps.lang('Interact.inputTitle'), {
        {type = 'input', title = ps.lang('Interact.inputHeader'), description = ps.lang('Interact.inputDesc'), required = true}
    })
    if not submitPass then return false end
    if submitPass[1] == pass then
        return ps.callback('md-stashes:server:passwordCheck', submitPass[1], id)
    else
        ps.notify(ps.lang('Notify.wrongPass'), 'error')
        return false
    end
end

<<<<<<< fork
RegisterNetEvent('mri_Qstashes:client:doray', function()
    if not isAdminCache then
        lib.notify({ type = 'error', description = locale("error.admin_only") })
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
            description = locale("createmenu.description10"),
            default = locale("createmenu.default10")
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
||||||| base
RegisterNetEvent('md-stashes:client:doray', function()
	local stashmake = StartRay()
	if stashmake then
		local input = lib.inputDialog('Stash Maker', {
			{type = 'input', label = 'name', description = 'Name Of Stash', required = true},
			{type = 'input', label = 'job', description = 'Job Or Blank'},
			{type = 'input', label = 'gang', description = 'Gang Or Blank'},
			{type = 'input', label = 'rank', description = 'Rank Or Blank'},
			{type = 'input', label = 'item', description = 'Item or Blank'},
			{type = 'input', label = 'Slot Size', description = 'Slot Size or Blank'},
			{type = 'input', label = 'Weight', description = 'Weight Size or Blank'},
			{type = 'input',label = 'Password', description = 'Password Or Blank'},
			{type = 'input', label = 'Citizen ID', description = 'Citizen ID or Blank'},
		  })
	local nameloc = "['"..input[1] .. "'] = { loc = vector3(" .. stashmake.x ..", " .. stashmake.y .. ", " .. stashmake.z .. ")"
	if input[2] == ''then else input[2] = ", job = '" .. input[2] .. "'" end
	if input[3] == ''then else input[3] = ", gang = '" .. input[3] .. "'" end
	if input[4] == ''then else input[4] = ", rank = " .. input[4] .. "" end
	if input[5] == ''then else input[5] = ", item = '" .. input[5] .. "'" end
	if input[6] == ''then else input[6] = ", slots = " .. input[6] .. "" end
	if input[7] == ''then else input[7] = ", weight = " .. input[7] .. "" end
	if input[8] == ''then else input[8] = ", password = '" .. input[8] .. "'" end
	if input[9] == ''then else input[9] = ", cid = '" .. input[9] .. "'" end
	local copy = nameloc .. input[2] .. "" .. input[3] .. "" .. input[4] .. "" .. input[5] .. "" .. input[6].. "" .. input[7] .. "" .. input[8] .. "" .. input[9].. "},"
	lib.setClipboard(copy)
	QBCore.Functions.Notify("Info Copied To Your Clip Board, Paste Into Config.stash")
	end
=======
local function initTargets()
    local cb = ps.callback('md-stashes:server:getStashes')
    for k, v in pairs(cb) do
        v.loc = json.decode(v.loc)
        v.data = json.decode(v.data)
        if v.data.object then
            ps.requestModel(v.data.object)
            props[#props + 1] = CreateObject(v.data.object, v.loc.x, v.loc.y, v.loc.z, false, false, false)
            SetEntityHeading(props[#props], v.loc.w or 180.0)
            FreezeEntityPosition(props[#props], true)
            ps.entityTarget(props[#props], {
                {
                    label = ps.lang('Interact.targetLabel'),
                    icon = ps.lang('Interact.targetIcon'),
                    action = function()
                        if not checkPassword(v.data.password, v.id) then return end
                        TriggerServerEvent('md-stashes:server:openStash', k)
                    end,
                    canInteract = function()
                        return check(v.data)
                    end
                }
            })
        else
            ps.boxTarget('md_stashes'..k, vector3(v.loc.x, v.loc.y, v.loc.z), {length = 1.0, width = 1.0, height = 1.0}, {
                {
                    label = ps.lang('Interact.targetLabel'),
                    icon = ps.lang('Interact.targetIcon'),
                    action = function()
                        if not checkPassword(v.data.password) then return end
                        TriggerServerEvent('md-stashes:server:openStash', k)
                    end,
                    canInteract = function()
                        return check(v.data)
                    end
                }
            })
            targets[#targets+1] = 'md_stashes'..k
        end
    end
end

initTargets()

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k, v in pairs(props) do
        DeleteEntity(v)
    end
>>>>>>> upstream
end)

RegisterNetEvent('md-stashes:client:newstash', function()
    for k, v in pairs (props) do
        DeleteEntity(v)
    end
    for k, v in pairs(targets) do
        ps.destroyTarget(v)
    end
    initTargets()
end)
