# supv_exampleShopKeyCar for supv_carkey


client :
```lua
--- GiveCarKeyStrict
-- only job and admin got use it client-side
---@param plate string
---@param model string|number (if model = string then model = model|if model = number[hash] then model = GetDisplayNameFromVehicleModel(model))
---@param target? nil|number (optional)
exports.supv_carkey:GiveCarKeyStrict(plate, model, target)

--- DeleteCarKey
--- optional
---@param plate string
---@param count? nil|boolean|number (optional) (if count = nil then count = 1) (if count = true then count = item.totalCount)
exports.supv_carkey:DeleteCarKey(plate, count)
```

server :
```lua
--- GiveCarKeyStrict
--- from job or admin
---@param source number
---@param plate string
---@param model string
---@param target? nil|number (optional) 
exports.supv_carkey:GiveCarKeyStrict(source, plate, model, target)

--- GiveCarKey
---
---@param source number
---@param plate string
---@param model string
exports.supv_carkey:GiveCarKey(source, plate, model)

--- DeleteCarKey
---
---@param source number
---@param plate string
---@param count? nil|boolean|number (optional) (if count = nil then count = 1) (if count = true then count = item.totalCount)
exports.supv_carkey:DeleteCarKey(source, plate, count)
```

if you use sublime_administration goto client/menu's/OnlinePlayers/[b]PlayerDetails.lua

add this in function _Admin.Panel:PlayerDetailsVehicle2(rank, plate, stored, data, label, name, cat, price) ~l.632 under RageUI.Line()

```lua
    RageUI.Button('Give Key', nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
        onSelected = function()
            exports.supv_carkey:GiveCarKeyStrict(plate, GetDisplayNameFromVehicleModel(data.model), _Admin.TargetId)
            Wait(200)
        end
    });
```