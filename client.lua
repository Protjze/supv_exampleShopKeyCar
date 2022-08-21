local menu, OpenMenu = {}, {}
local GetDisplayNameFromVehicleModel <const> = GetDisplayNameFromVehicleModel
local IsControlJustPressed <const> = IsControlJustPressed
local GetEntityModel <const> = GetEntityModel
local carkey <const> = exports.supv_carkey

RegisterNetEvent('esx:playerLoaded', function(x)
    ESX.PlayerData = x
end)

RegisterNetEvent('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local keys = {}

local function GetKeys()
    keys = {}
    ESX.TriggerServerCallback('getkeyshop', function(data)
        keys = data
    end)
end

local function CreateMenu(key)
    local title, banner = "", {}
    if key == 'job' then
        title = "Création de clé"
        banner = {0,0,0,120}
    elseif key == 'shop' then
        title = "Serrurier"
        banner = {255,255,255,120}
    end

    menu[key] = RageUI.CreateMenu(title, 'sélection')

    menu[key]:SetRectangleBanner(banner[1], banner[2], banner[3], banner[4])
end

function OpenMenu.job(key, plate, model)
    CreateMenu(key)

    RageUI.Visible(menu[key], true)
    CreateThread(function()
        while true do
            Wait(0)

            RageUI.IsVisible(menu[key], function()
                RageUI.Button(("Créer une clé : %s - %s"):format(plate, GetDisplayNameFromVehicleModel(model)), nil, {}, true, {
                    onSelected = function()
                        carkey:GiveCarKeyStrict(plate, model)
                        RageUI.Visible(menu[key], false)
                    end
                })
            end)

            if not supv.oncache.currentvehicle then
                RageUI.Visible(menu[key], false)
            end

            if not RageUI.Visible(menu[key]) then
                menu[key] = RMenu.DeleteType(menu[key], true)
                menu[key] = nil
                return false
            end
        end
    end)
end



function OpenMenu.shop(key)
    CreateMenu(key)
    RageUI.Visible(menu[key], true)
    CreateThread(function()
        GetKeys()
        while true do
            Wait(0)

            RageUI.IsVisible(menu[key], function()
                if #keys > 0 then
                    for _,v in ipairs(keys) do
                        RageUI.Button(("%s - %s"):format(v.plate, GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = ("~g~%s~s~$"):format(Config.price)}, true, {
                            onSelected = function()
                                TriggerServerEvent('buykey:shop', v.plate, GetDisplayNameFromVehicleModel(v.model))
                                RageUI.Visible(menu[key], false)
                            end
                        })
                    end
                end
            end)

            if not RageUI.Visible(menu[key]) then
                menu[key] = RMenu.DeleteType(menu[key], true)
                menu[key] = nil
                return false
            end
        end
    end)
end

CreateThread(function()
    local sleep, player = 0, supv.player.get()
    while true do
        sleep = 500
        player:distance(Config.buykey)
        if player.dist < 10.0 then sleep = 0 
            if not next(menu) and not supv.oncache.currentvehicle then supv.marker.simple(true, player.dist < 3.0, Config.buykey) end
            if player.dist < 3.0 and not supv.oncache.currentvehicle then
                if IsControlJustPressed(0, 38) and not next(menu) then
                    OpenMenu.shop('shop')
                end
            elseif menu['shop'] and player.dist > 3.0 then
                RageUI.Visible(menu['shop'], false)
            end
        end

        Wait(sleep)
    end
end)


RegisterCommand('createKey', function()
    if ESX.PlayerData.job and Config.Allowed[ESX.PlayerData.job.name] and supv.oncache.currentvehicle then
        OpenMenu.job('job', supv.vehicle.getProperties(supv.oncache.currentvehicle).plate, GetEntityModel(supv.oncache.currentvehicle))
    end
end, false)


RegisterCommand('deleteKey', function() -- example to remove key (useful for rented vehicle) pour les véhicule louer pratique une méthode pour remove les clées
    local plate = supv.keyboard.input('plaque', nil, 8)
    if #plate < 4 then return end
    carkey:DeleteCarKey(plate, 1)
end)
