local actions = {}
local walks = lib.load("data.walks")
local isDrunk = false
local oldMovement = nil
local alreadyRagdoll = false
local lsatBacUpdate = 0

local function getDrunkMovement(alcohol)
    if alcohol > 80 then
        return "MOVE_M@DRUNK@VERYDRUNK", true
    elseif alcohol > 55 then
        return "MOVE_M@DRUNK@VERYDRUNK"
    -- elseif alcohol > 45 then
    --     return "MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP"
    elseif alcohol > 30 then
        return "MOVE_M@DRUNK@MODERATEDRUNK"
    elseif alcohol >= 10 then
        return "MOVE_M@DRUNK@SLIGHTLYDRUNK"
    end
end

function actions.alcohol(ped, info, status)
    if status.status > 30 and not isDrunk then
        isDrunk = true
        DoScreenFadeOut(500)
        Wait(500)
        DoScreenFadeIn(500)

        SetTimecycleModifier("spectator5")
        SetPedMotionBlur(ped, true)
        SetPedIsDrunk(ped, true)

        oldMovement = GetPedMovementClipset(ped)
    elseif status.status < 10 and isDrunk then
        isDrunk = false
        DoScreenFadeOut(500)
        Wait(500)
        DoScreenFadeIn(500)

        ClearTimecycleModifier()
        SetPedMotionBlur(ped, false)
        SetPedIsDrunk(ped, false)
        -- ShakeGameplayCam("DRUNK_SHAKE", 0.0)

        alreadyRagdoll = false
        
        local movement = walks[oldMovement]
        return movement and SetPedMovementClipset(ped, movement, true) or ResetPedMovementClipset(ped, 0)
    end

    if not isDrunk then return end
    local newMovement, ragdoll = getDrunkMovement(status.status)
    lib.requestAnimSet(newMovement)
    SetPedMovementClipset(ped, newMovement, true)

    -- ShakeGameplayCam("DRUNK_SHAKE", status.status/50)

    if GetResourceState("Breathalyzer") == "started" then        
        local time = GetCloudTimeAsInt()
        if time-lsatBacUpdate > 10 then
            TriggerServerEvent("ND_Status:setBAC", math.floor(status.status))
            lsatBacUpdate = time
        end
    end

    if not ragdoll or alreadyRagdoll then return end
    alreadyRagdoll = true

    CreateThread(function()
        while alreadyRagdoll do
            Wait(math.random(8000, 15000))
            if math.random(1, 3) == 1 then
                SetPedToRagdoll(ped, 1000, 1000, 0, true, true, false)
            end
        end
    end)
end

function actions.stamina(ped, info, status)
    local usingStamina = false

    if info.onRun and IsPedRunning(ped) and status.status < 50.0 then
        status.status += info.onRun/5
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
        status.status += info.increaseRate*2
    end

    if status.status > 50 then
        RestorePlayerStamina(cache.playerId, 1.0)
    end
end

function actions.armor(ped, info, status)
    local armor = GetPedArmour(ped)
    local maxArmor = GetPlayerMaxArmour(cache.playerId)
    if armor > maxArmor then
        armor = maxArmor
    elseif armor < 0 then
        armor = 0
    end
    
    local total = (armor/maxArmor)*100
    local scalingFactor = (armor/maxArmor)+((100-total)/60)
    if scalingFactor < 0 then
        scalingFactor = -scalingFactor
    end

    status.status = (armor / (maxArmor*scalingFactor))*100
end

local lastFlashTime = 0
local lastStarveNotifiaction = 0
function actions.starve(ped, info, status)
    if status.status > 1 or IsPedFatallyInjured(ped) then return end
    
    local time = GetCloudTimeAsInt()
    if time-lastFlashTime < 10 then return end

    if time-lastStarveNotifiaction > 40 then
        lib.notify({
            title = ("You're %s"):format(info.type == "hunger" and "starving" or "dehydrated"),
            type = "inform",
            duration = 10000
        })
        lastStarveNotifiaction = time
    end
    
    lastFlashTime = time
    DoScreenFadeOut(500)
    SetTimeout(500, function()
        DoScreenFadeIn(500)
        Wait(400)
        ApplyDamageToPed(ped, 3)
    end)
end

return actions
