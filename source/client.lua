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
