NDCore = exports["ND_Core"]:GetCoreObject()

RegisterNetEvent("ND_Status:update", function(data)
    local src = source
    local player = NDCore.Functions.GetPlayer(src)
    NDCore.Functions.SetPlayerData(player.id, "status", data)
end)