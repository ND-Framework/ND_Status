local player = PlayerId()
local shown = false
local characterStatus = nil
local NDCore = exports["ND_Core"]:GetCoreObject()

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
        if info.enabled and enableUI then
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

    local character = NDCore.Functions.GetSelectedCharacter()
    if not character then return end

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
    if info.onRun and IsPedRunning(ped) then
        if characterStatus[info.type].status < 50.0 then
            characterStatus[info.type].status += info.increaseRate / 3
        elseif characterStatus[info.type].status > 55.0 then
            characterStatus[info.type].status -= info.onRun
            usingStamina = true
        end
    end
    if info.onSprint and IsPedSprinting(ped) then
        characterStatus[info.type].status -= info.onSprint
        changeStatus("thirst", -0.05)
        usingStamina = true
    end
    if info.onJump and IsPedJumping(ped) then
        characterStatus[info.type].status -= info.onJump
        usingStamina = true
    end
    if not usingStamina and characterStatus[info.type].status < characterStatus[info.type].max then
        characterStatus[info.type].status += info.increaseRate
    end
    if characterStatus[info.type].status < 0.0 then
        characterStatus[info.type].status = 0.0
    end
    SetPlayerStamina(player, characterStatus[info.type].status)
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