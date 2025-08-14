RegisterNetEvent("ND_Status:update", function(data)
    local src = source
    local player = NDCore.getPlayer(src)
    if not player then return end
    player.setMetadata("status", data)
end)

RegisterNetEvent("ND_Status:setBAC", function(status)
    local src = source
    if GetResourceState("Breathalyzer") ~= "started" then return end

    if status < 0 then
        status = 0
    elseif status > 100 then
        status = 100
    end
        
    local lvl = status*(math.random(6, 10)/2000)
    exports["Breathalyzer"]:setBAC(src, lvl)
end)

lib.addCommand("fillstatus", {
    help = "Refresh status",
    params = {
        {
            name = "target",
            type = "playerId",
            help = "Target player's server id",
        }
    },
    restricted = "group.admin"
}, function(source, args, raw)
    TriggerClientEvent("ND_Status:fillstatus", args.target)
end)