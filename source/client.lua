local player = PlayerId()
local shown = false
local characterStatus = nil

function setStatus(statusName, value)
    characterStatus[statusName].status = value
end

function changeStatus(statusName, value)
    characterStatus[statusName].status += value
    if characterStatus[statusName].status > characterStatus[statusName].max then characterStatus[statusName].status = characterStatus[statusName].max end
end

function setMaxStatus(statusName, max)
    characterStatus[statusName].max = max
    if statusName ~= "stamina" then return end
    SetPlayerMaxStamina(player, max)
end

function getStatus()
    return characterStatus
end

function createUI()
    if enableUI then
        SendNUIMessage({
            type = "remove"
        })
    end
    for _, info in pairs(config) do
        Wait(1000)
        if info.type == "stamina" then
            setMaxStatus("stamina", characterStatus[info.type].max)
        end
        if info.enabled and enableUI and info.style then
            SendNUIMessage({
                type = "add",
                info = info
            })
        end
    end
    shown = true
end

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    local player = NDCore.getPlayer()
    if not player then return end

    local characterData = player.metadata.status
    if characterData then
        characterStatus = characterData
        return createUI()
    end

    characterStatus = {}
    for _, info in pairs(config) do
        if info.enabled then
            characterStatus[info.type] = {
                type = info.type,
                status = info.max,
                max = info.max
            }
        end
    end
    createUI()
end)

RegisterNetEvent("ND:setCharacter", function(character)
    local characterData = character.data.status
    if not characterData then
        characterStatus = {}
        for _, info in pairs(config) do
            if info.enabled then
                characterStatus[info.type] = {
                    type = info.type,
                    status = info.max,
                    max = info.max
                }
            end
        end
        createUI()
        return
    end
    characterStatus = characterData
    createUI()
end)

function stamina(ped, info)
    local usingStamina = false
    local status = characterStatus[info.type]
    if info.onRun and IsPedRunning(ped) then
        if status.status < 50.0 then
            status.status += info.increaseRate / 3
        elseif status.status > 55.0 then
            status.status -= info.onRun
            usingStamina = true
        end
    end
    if info.onSprint and IsPedSprinting(ped) then
        status.status -= info.onSprint
        changeStatus("thirst", -0.05)
        usingStamina = true
    end
    if info.onJump and IsPedJumping(ped) then
        status.status -= info.onJump
        usingStamina = true
    end
    if not usingStamina and status.status < status.max then
        status.status += info.increaseRate
    end
    if status.status < 0.0 then
        status.status = 0.0
    end
    SetPlayerStamina(player, status.status)
end

CreateThread(function()
    while true do
        Wait(500)
        if characterStatus and shown then
            local ped = PlayerPedId()
            for _, info in pairs(config) do
                if info.enabled then
                    if info.decreaseRate and characterStatus[info.type].status >= 1.0 then
                        characterStatus[info.type].status -= info.decreaseRate / 3
                    elseif characterStatus[info.type].status < 0.0 then
                        characterStatus[info.type].status = 0.0
                    end

                    if info.type == "stamina" then
                        stamina(ped, info)
                    end
                end
            end
        end
    end
end)

if enableUI then
    CreateThread(function()
        repeat Wait(100) until(shown)
        while true do
            Wait(1000)
            SendNUIMessage({
                type = "update",
                info = json.encode(characterStatus)
            })
        end
    end)
end

CreateThread(function()
    while true do
        Wait(4*60000)
        TriggerServerEvent("ND_Status:update", characterStatus)
    end
end)