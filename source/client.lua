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
