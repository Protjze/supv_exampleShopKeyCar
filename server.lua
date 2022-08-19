local cfg <const>, pairs = Config, pairs

ESX.RegisterServerCallback('getkeyshop', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    local data = {}
    local query = "SELECT * FROM owned_vehicles WHERE owner = ?"
    local result = MySQL.query.await(query, {player.identifier})
    if result then
        for i = 1, #result do
            --print(json.encode(result[i], {indent = true}))
            local meta, model = json.decode(result[i].vehicle)
            for k,v in pairs(meta)do
                if k == 'model' then
                    model = v
                    data[#data+1] = {
                        plate = result[i].plate,
                        model = model
                    }
                end
            end


        end
    end
    cb(data)
end)

RegisterNetEvent("buykey:shop", function(plate, model)
    local _source = source
    local player = ESX.GetPlayerFromId(_source)
    local playerPed = GetPlayerPed(_source)
    local playerCoords = GetEntityCoords(playerPed)

    if #(playerCoords - cfg.buykey) > 3.0 then return end
    if player.getMoney() < cfg.price then return player.showNotification(("Tu as pas de sousou\nIl te manque : %s$"):format(cfg.price-player.getMoney())) end
    player.removeMoney(cfg.price)
    exports.supv_carkey:GiveCarKey(_source, plate, model)
end)

