local actions = {}

function actions.stamina(ped, info, status)
    local usingStamina = false

    if info.onRun and IsPedRunning(ped) and status.status < 50.0 then
        status.status += info.increaseRate / 3
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

    if status.status > 50 then
        RestorePlayerStamina(cache.playerId, 1.0)
    end
end

function actions.alcohol(ped, info, status)

end


return actions
