RegisterNetEvent("ND_Status:update", function(data)
    local src = source
    local player = NDCore.getPlayer(src)
    if not player then return end
    player.setMetadata("status", data)
end)
