local cfg <const>, pairs = Config, pairs
local carkey <const> = exports.supv_carkey

ESX.RegisterServerCallback('getkeyshop', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    local data = {}
    local query = "SELECT * FROM owned_vehicles WHERE owner = ?"
    local result = MySQL.query.await(query, {player.identifier})
    if result then
        for i = 1, #result do
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
        cb(data)
    end
end)

RegisterNetEvent("buykey:shop", function(plate, model)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local player = supv.player.getFromId(_source)

    if player:distance(cfg.buykey) > 3.0 then return end
    if xPlayer.getMoney() < cfg.price then return xPlayer.showNotification(("Tu as pas de sousou\nIl te manque : %s$"):format(cfg.price-xPlayer.getMoney())) end
    xPlayer.removeMoney(cfg.price)
    carkey:GiveCarKey(_source, plate, model)
end)

supv.version.check("https://raw.githubusercontent.com/SUP2Ak/supv_exampleShopKeyCar/main/version.json", nil, nil, 'json', "https://github.com/SUP2Ak/supv_exampleShopKeyCar", 'fr')
