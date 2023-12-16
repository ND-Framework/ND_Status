RegisterNetEvent("ND_Status:update", function(data)
    local src = source
    local player = NDCore.getPlayer(src)
    player.setMetadata("status", data)
end)
