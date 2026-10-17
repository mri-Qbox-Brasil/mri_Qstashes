Config = {}
<<<<<<< fork
Config.Command = "bau"
Config.Defaultslot = 50
Config.Defaultweight = 1000
Config.DefaultMessage = "Abrir baú"
Config.Debug = false
||||||| base
Config.OxInv = false
Config.OxTarget = true
Config.interact = false
Config.Defaultslot = 50
Config.Defaultweight = 1000000
--[[
    OPTIONALS
    job = "jobname"
    gang = "gangname"
    rank = 0 ( if no rank in code, defaults to 0 for job/gang)
    weight = 100000
    slots = 50
    item = 'item'
    cid = 'citizenID'
    password = 1234 ( must be number between 1 and 99999)
    REQUIRED
    loc = vector3

]]
Config.stash = {
    ['test'] = { loc = vector3(520.29736328125, -3108.0920410156, 33.285308837891)},
    ['test2'] = { loc = vector3(2746.3481445312, 2787.6713867188, -35.787368774414), item = 'lockpick', slots = 12, weight = 10000},
   
    
}
=======
ps = exports.ps_lib:init()
ps.loadLangs('en')

Config.OldData = false -- Enable this if you are using old data from before version 3.0.0 | this loads command ADjustStashes to adjust old data to new data format
                      -- Turn to false after you run the command IF you need to use it
Config.Defaults = {
    slots = 50,
    maxWeight = 1000000
}
>>>>>>> upstream

-- Permissões de admin (ace groups ou permissões customizadas)
Config.AdminPerms = { "admin" } -- pode ser uma ou mais strings, ex: {"admin", "god"}

Config.Objects = {
    {value = 'tr_prop_tr_chest_01a', label = 'Small Chest'},
    {value = 'prop_champ_box_01',    label = 'Medium Crate'},
    {value = 'prop_box_wood05a',     label = 'Large Crate'},
    {value = 'prop_lev_crate_01',    label = 'Large Wooden Crate'},
    {value = 'prop_container_03mb', label = 'Shipping Container'},
}

Config.UseBackpacks = true -- Set to false if you do not want to use backpacks
