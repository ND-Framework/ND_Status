local shown = false
local characterStatus = nil
local actions = lib.load("source.actions")

function setStatus(statusName, value)
    local charStatus = characterStatus[statusName]
    if not charStatus or not value then return end

    charStatus.status = value
end

function changeStatus(statusName, value)
    local charStatus = characterStatus[statusName]
    if not charStatus or not value then return end

    charStatus.status += value

    if charStatus.status > charStatus.max then
        charStatus.status = charStatus.max
    end
    if charStatus.status < 0 then
        charStatus.status = 0
    end
end

function setMaxStatus(statusName, max)
    local charStatus = characterStatus[statusName]
    if not charStatus or not max then return end

    charStatus.max = max
end

local function getStatus()
    return characterStatus
end

local function createUI()
    if enableUI then
        SendNUIMessage({
            type = "remove"
        })
    end

    for i=1, #config do
        local info = config[i]
        if not info.enabled or not enableUI or not info.style then goto next end

        Wait(500)
        if info.type == "stamina" then
            setMaxStatus("stamina", characterStatus[info.type]?.max)
        end
        SendNUIMessage({
            type = "add",
            info = info
        })

        ::next::
    end

    shown = true
end

local function createStatus(index)
    local newInfo = config[index]
    if not newInfo or not newInfo.enabled then return end
    return {
        type = newInfo.type,
        status = newInfo.default or newInfo.max,
        max = newInfo.max,
        reversed = newInfo.reversed
    }
end

local function setupPlayerStatus(player)
    local characterData = player?.metadata.status
    characterStatus = {}

    if not characterData then
        for i=1, #config do
            local info = config[i]
            characterStatus[newInfo.type] = createStatus(i)
        end
        return createUI()
    end

    for i=1, #config do
        local info = config[i]
        if info.enabled and not characterData[info.type] then
            characterData[info.type] = createStatus(i)
        elseif not info.enabled and characterData[info.type] then
            characterData[info.type] = nil
        end
    end

    characterStatus = characterData
    createUI()
end

AddEventHandler("onResourceStart", function(resourceName)
    if cache.resource ~= resourceName then return end
    Wait(500)

    local player = NDCore.getPlayer()
    setupPlayerStatus(player)
end)

RegisterNetEvent("ND:characterLoaded", function(character)
    Wait(500)
    setupPlayerStatus(character)
end)

CreateThread(function()
    while true do
        Wait(500)
        if not characterStatus or not shown then goto skip end

        local ped = cache.ped
        for i=1, #config do
            local info = config[i]
            local infoType = info.type
            local charStatus = characterStatus[infoType]
            if not info.enabled or not charStatus then goto next end

            if info.decreaseRate and charStatus.status >= 1 then
                charStatus.status -= info.decreaseRate / 3
            end
            if info.action and actions[info.action] then
                actions[info.action](ped, info, charStatus)
            end
            if charStatus.status < 0 then
                charStatus.status = 0
            end
            if charStatus.status > (info.max or 100) then
                charStatus.status = info.max or 100
            end

            ::next::
        end

        ::skip::
    end
end)

CreateThread(function()
    if enableUI then
        repeat Wait(100) until(shown)
    end

    local lastUpdate = 0
    while true do
        Wait(500)

        local time = GetCloudTimeAsInt()
        if time-lastUpdate > 240 then
            TriggerServerEvent("ND_Status:update", characterStatus)
            lastUpdate = time
        end

        SendNUIMessage({
            type = "update",
            info = json.encode(characterStatus)
        })
    end
end)
