--[[
-------------------------------------------------------------------------------------
                   Safe Entry Guard Mod for Project Zomboid - Main Logic
-------------------------------------------------------------------------------------
    Author: Stormbox
    Description: An active contributor and modder for the Deathscape Community.

    Purpose: The Safe Entry Guard Mod provides players with a temporary protective buffer
             upon entering the game, including invisibility, zombie ignorance, and ghost mode.
             This ensures that players aren't instantly overwhelmed by zombies and offers
             a brief window to get their bearings before the challenges of survival begin.

    Special Thanks: I'd like to extend my gratitude to the Deathscape Community for their
                    unwavering support and invaluable feedback.

    Support Me: If you appreciate my work and wish to back me, I'm open to mod commissions
                for a modest fee under $50, depending on the mod's intricacy. Your support
                empowers me to continue crafting more mods for our community.
                To express your appreciation or buy me a coffee: https://ko-fi.com/stormboxoriginal

    Contact: For any questions, suggestions, or potential collaborations, please feel free
             to contact me. Your feedback is cherished, and I eagerly await discussions
             with fellow PZ enthusiasts.
-------------------------------------------------------------------------------------
]]
-- SafeEntryGuard Mod
local ProtectionSystem = {}
ProtectionSystem.Players = {} -- Tracks states dynamically for split-screen/co-op players

-- Checks if the player possesses admin privileges and should bypass protection
function ProtectionSystem.IsExempt(playerObj)
    local role = getAccessLevel and getAccessLevel() or ""
    local adminCheck = isAdmin and isAdmin() or false
    return adminCheck or role == "admin" or role == "Admin"
end

-- Utility function to render floating Halo text above the player
function ProtectionSystem.ShowText(playerObj, textKey, ...)
    if not playerObj then
        return
    end

    local text = getText and getText(textKey, ...) or tostring(textKey)
    playerObj:setHaloNote(text, 236, 131, 190, 50)
end

-- Applies or removes the quadruple-layer protection modifiers based on sandbox settings
function ProtectionSystem.ApplyModifiers(playerObj, enable)
    if not playerObj then
        return
    end

    local options = SandboxVars and SandboxVars.SafeEntryGuard or {}

    -- Wrap in pcalls because certain admin methods (like setGodMod) 
    -- may be restricted or removed from client-side Lua exposure in Multiplayer.
    if options.UseInvisibility ~= false then 
        pcall(function() playerObj:setInvisible(enable) end) 
    end
    if options.UseZombiesDontAttack ~= false then 
        pcall(function() playerObj:setZombiesDontAttack(enable) end) 
    end
    if options.UseGhostMode ~= false then 
        pcall(function() playerObj:setGhostMode(enable) end) 
    end
    if options.UseGodMode ~= false then 
        pcall(function() playerObj:setGodMod(enable) end) 
    end
end

-- Initializes the protection phase for a specific player instance
function ProtectionSystem.Initiate(playerObj)
    if not playerObj or ProtectionSystem.IsExempt(playerObj) then
        print("[SafeEntryGuard] Bypassing protection sequence (Admin or Invalid Player).")
        return
    end

    local pNum = playerObj:getPlayerNum()
    local initialDuration = (SandboxVars and SandboxVars.SafeEntryGuard and SandboxVars.SafeEntryGuard.SafeTime) or 120
    
    -- Store player-specific state data for robust splitscreen/co-op compatibility
    ProtectionSystem.Players[pNum] = {
        modifiersApplied = false,
        isShielded = true,
        shieldExpiresAt = getTimestamp() + initialDuration,
        startX = playerObj:getX(),
        startY = playerObj:getY(),
        movementPenaltyApplied = false,
        lastTimeDisplayed = -1
    }

    -- Modifiers are deferred to OnUpdate to ensure player inventory is fully initialized
    print("[SafeEntryGuard] Protection sequence queued for player " .. tostring(pNum))

    Events.OnPlayerUpdate.Remove(ProtectionSystem.OnUpdate)
    Events.OnPlayerUpdate.Add(ProtectionSystem.OnUpdate)
end

-- Deactivates the protection phase and cleans up the player's state
function ProtectionSystem.Terminate(playerObj)
    if not playerObj then
        return
    end

    local pNum = playerObj:getPlayerNum()
    local pData = ProtectionSystem.Players[pNum]
    
    if not pData or not pData.isShielded then return end
    pData.isShielded = false

    -- Revoke the protection modifiers
    ProtectionSystem.ApplyModifiers(playerObj, false)
    
    ProtectionSystem.ShowText(playerObj, "IGUI_SafeEntryGuard_noProtection")
    print("[SafeEntryGuard] Protection systems deactivated for player " .. tostring(pNum))
end

-- Core tick function executing every frame to monitor player state
function ProtectionSystem.OnUpdate(playerObj)
    if not playerObj then
        return
    end

    local pNum = playerObj:getPlayerNum()
    local pData = ProtectionSystem.Players[pNum]

    if not pData or not pData.isShielded then return end

    -- Apply the protective modifiers on the first tick to prevent NullPointerExceptions
    if not pData.modifiersApplied then
        ProtectionSystem.ApplyModifiers(playerObj, true)
        pData.modifiersApplied = true
    end

    -- Combat Cancellation: If the player attacks, instantly revoke protection
    if playerObj:isAttacking() then
        ProtectionSystem.Terminate(playerObj)
        return
    end

    local currentSec = getTimestamp()
    local secondsRemaining = pData.shieldExpiresAt - currentSec

    if secondsRemaining <= 0 then
        ProtectionSystem.Terminate(playerObj)
        return
    end

    if not pData.movementPenaltyApplied then
        -- Calculate spatial divergence using the squared distance formula
        -- This prevents micro-movements (like breathing animations) from falsely triggering the penalty
        local diffX = playerObj:getX() - pData.startX
        local diffY = playerObj:getY() - pData.startY
        
        -- 0.1 threshold confirms actual locational movement
        if (diffX * diffX) + (diffY * diffY) > 0.1 then
            pData.movementPenaltyApplied = true
            local penaltyTime = (SandboxVars and SandboxVars.SafeEntryGuard and SandboxVars.SafeEntryGuard.MovedSafeTime) or 15
            
            -- Recalibrate the expiration timestamp based on the penalty
            pData.shieldExpiresAt = currentSec + penaltyTime
            secondsRemaining = penaltyTime

            if secondsRemaining <= 0 then
                ProtectionSystem.Terminate(playerObj)
                return
            end

            ProtectionSystem.ShowText(playerObj, "IGUI_SafeEntryGuard_moveCountdown", secondsRemaining)
            pData.lastTimeDisplayed = secondsRemaining
            print("[SafeEntryGuard] Coordinate shift detected. Shield recalibrated.")
        end
    end

    -- Render overhead text throttled to 1-second intervals
    if secondsRemaining ~= pData.lastTimeDisplayed then
        pData.lastTimeDisplayed = secondsRemaining
        if not (pData.movementPenaltyApplied and secondsRemaining == ((SandboxVars and SandboxVars.SafeEntryGuard and SandboxVars.SafeEntryGuard.MovedSafeTime) or 15)) then
            ProtectionSystem.ShowText(playerObj, "IGUI_SafeEntryGuard_countdown", secondsRemaining)
        end
    end
end

Events.OnGameStart.Add(function()
    local playerObj = getPlayer and getPlayer() or nil
    if playerObj then
        ProtectionSystem.Initiate(playerObj)
    end
end)

-- Trigger protection on respawn as well
Events.OnCreatePlayer.Add(function(playerIndex, player)
    if playerIndex == 0 then
        ProtectionSystem.Initiate(player)
    end
end)
