--[[
-------------------------------------------------------------------------------------
                   Safe Entry Guard Mod for Project Zomboid - Main Logic
-------------------------------------------------------------------------------------
    Author: Hazy Lunar
    Description: Modder for the Valhalla Community.

    Purpose: This file serves as the main logic behind providing a protection buffer
             for players upon their entry into the game, ensuring they have a brief
             period of immunity from zombie attacks.

    Special thanks to the Valhalla Community for their continuous support and feedback.

    I'm open to mod commissions for a small fee under $50, depending on the mod size.
    For more details or to buy me a coffee: https://ko-fi.com/hazylunar

    For questions, suggestions, or collaborations, contact Hazy Lunar.
-------------------------------------------------------------------------------------
]]

local Logger = require 'SEGLogger';

local safeStart = 0;
local protectiveDuration = SandboxVars.SafeEntryGuard.Duration or 25; -- default to 25 seconds if not set in Sandbox.
local originalX = 0;
local originalY = 0;
local playerMoved = false;

local function playerIsAdmin()
    return isAdmin() or getAccessLevel() == "admin" or getAccessLevel() == "Admin";
end

local function halo(player, msg)
    player:setHaloNote(msg, 236, 131, 190, 50);
end

local function engageProtection(player)
    if playerIsAdmin() then
        Logger:log("Admin detected. Skipping protection.", Logger.DEBUG);
        return; -- Admins have their own protective measures.
    end

    originalX = player:getX();
    originalY = player:getY();

    -- Set player as invisible and ensure zombies don't attack them.
    player:setInvisible(true);
    player:setZombiesDontAttack(true);

    safeStart = getTimestamp();
    Logger:log("[SafeEntryGuard] Protection engaged.", Logger.INFO);
end

local function disengageProtection(player)
    player:setInvisible(false);
    player:setZombiesDontAttack(false);
    Events.OnPlayerUpdate.Remove(SafeEntryGuard_OnPlayerUpdate);
    halo(player, "Protection has ended!");
    Logger:log("[SafeEntryGuard] Protection disengaged.", Logger.INFO);
end

function SafeEntryGuard_OnPlayerUpdate(player)
    if safeStart == 0 then
        return;
    end

    if not playerMoved then
        if player:getX() ~= originalX or player:getY() ~= originalY then
            playerMoved = true;
            protectiveDuration = protectiveDuration *
                (SandboxVars.SafeEntryGuard.MovementMultiplier or 0.5); -- Default to 0.5 if not set in Sandbox.
            Logger:log("Player moved. Adjusted protective duration.", Logger.DEBUG);
        end
    end

    local elapsedProtectionTime = getTimestamp() - safeStart;
    local remainingProtectionTime = protectiveDuration - elapsedProtectionTime;

    if remainingProtectionTime <= 0 then
        disengageProtection(player);
    else
        halo(player, "Protected for " .. math.floor(remainingProtectionTime) .. " seconds.");
    end
end

local function delayedProtectionActivation()
    -- Read the log level from SandboxVars and set it in the logger
    local logLevel = SandboxVars.SafeEntryGuard.LogLevel or Logger.DEBUG;
    Logger:setLogLevel(logLevel);

    ISTimedActionQueue.add(ISDelayedAction:new(getPlayer(), engageProtection, 2)); -- Delayed by 2 seconds to ensure player is fully initialized.
    Logger:log("Delayed protection activation queued.", Logger.DEBUG);
end

Events.OnGameStart.Add(delayedProtectionActivation);
Events.OnPlayerUpdate.Add(SafeEntryGuard_OnPlayerUpdate);
