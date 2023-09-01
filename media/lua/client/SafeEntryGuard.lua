--[[
-------------------------------------------------------------------------------------
                   Safe Entry Guard Mod for Project Zomboid - Main Logic
-------------------------------------------------------------------------------------
    Author: Hazy Lunar
    Description: An active contributor and modder for the Valhalla Community.

    Purpose: The Safe Entry Guard Mod provides players with a temporary protective buffer
             upon entering the game, including invisibility, zombie ignorance, and ghost mode.
             This ensures that players aren't instantly overwhelmed by zombies and offers
             a brief window to get their bearings before the challenges of survival begin.

    Special Thanks: I'd like to extend my gratitude to the Valhalla Community for their
                    unwavering support and invaluable feedback.

    Support Me: If you appreciate my work and wish to back me, I'm open to mod commissions
                for a modest fee under $50, depending on the mod's intricacy. Your support
                empowers me to continue crafting more mods for our community.
                To express your appreciation or buy me a coffee: https://ko-fi.com/hazylunar

    Contact: For any questions, suggestions, or potential collaborations, please feel free
             to contact me. Your feedback is cherished, and I eagerly await discussions
             with fellow PZ enthusiasts.
-------------------------------------------------------------------------------------
]]
-- SafeEntryGuard Mod
local safeStart = 0
local originalX = 0
local originalY = 0
local playerMoved = false
local safeTime = (SandboxVars.SafeEntryGuard.SafeTime == nil) and 120 or SandboxVars.SafeEntryGuard.SafeTime
local movedSafeTime = (SandboxVars.SafeEntryGuard.MovedSafeTime == nil) and 15 or
SandboxVars.SafeEntryGuard.MovedSafeTime                                                                                   -- Default to 15 seconds
local useInvisibility = (SandboxVars.SafeEntryGuard.UseInvisibility == nil) and true or
SandboxVars.SafeEntryGuard.UseInvisibility
local useZombiesDontAttack = (SandboxVars.SafeEntryGuard.UseZombiesDontAttack == nil) and true or
SandboxVars.SafeEntryGuard.UseZombiesDontAttack
local useGhostMode = (SandboxVars.SafeEntryGuard.UseGhostMode == nil) and true or SandboxVars.SafeEntryGuard
.UseGhostMode

local function playerIsAdmin()
    return isAdmin() or getAccessLevel() == "admin" or getAccessLevel() == "Admin"
end

local function halo(player, msg)
    player:setHaloNote(msg, 236, 131, 190, 50)
end

local function engageProtection(player) -- Engage Protection
    if playerIsAdmin() then -- If Admin, skip protection
        print("[SafeEntryGuard] Admin detected. No additional safety applied.")
        return
    end
    originalX = player:getX()
    originalY = player:getY()

    if useInvisibility then
        player:setInvisible(true) -- Engage Invisibility
    end

    if useZombiesDontAttack then
        player:setZombiesDontAttack(true) -- Engage Zombies Don't Attack
    end

    if useGhostMode then
        player:setGhostMode(true) -- Engage Ghost Mode
    end

    safeStart = getTimestamp() -- Set Safe Start Time
    print("[SafeEntryGuard] Protection engaged.")
end

local function disengageProtection(player) -- Disengage Protection
    if useInvisibility then
        player:setInvisible(false) -- Disengage Invisibility
    end

    if useZombiesDontAttack then
        player:setZombiesDontAttack(false) -- Disengage Zombies Don't Attack
    end

    if useGhostMode then
        player:setGhostMode(false) -- Disengage Ghost Mode
    end

    Events.OnPlayerUpdate.Remove(SafeEntryGuard_OnPlayerUpdate) -- Remove Player Update Event
    halo(player, getText("IGUI_SafeEntryGuard_noProtection"))
    print("[SafeEntryGuard] Protection disengaged.")
end

function SafeEntryGuard_OnPlayerUpdate(player) -- Player Update Event
    if safeStart == 0 then
        return
    end
    if not playerMoved then
        if player:getX() ~= originalX or player:getY() ~= originalY then
            playerMoved = true
            safeTime = movedSafeTime                                                         -- Set the protection time after movement
            halo(player, getText("IGUI_SafeEntryGuard_moveCountdown", math.floor(safeTime))) -- Notify the player about the new protection time after movement
            print("[SafeEntryGuard] Player moved. Protection duration set to movedSafeTime.")
        end
    end

    local elapsedSafeTime = getTimestamp() - safeStart
    local remainingSafeTime = safeTime - elapsedSafeTime
    if remainingSafeTime <= 0 then
        disengageProtection(player)
    else
        halo(player, getText("IGUI_SafeEntryGuard_countdown", math.floor(remainingSafeTime)))
    end
end

Events.OnGameStart.Add(function()
    engageProtection(getPlayer())
end)

Events.OnPlayerUpdate.Add(SafeEntryGuard_OnPlayerUpdate)
