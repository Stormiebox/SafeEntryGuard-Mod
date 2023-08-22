--[[
-------------------------------------------------------------------------------------
               Safe Entry Guard Mod for Project Zomboid - Debugging Logger
-------------------------------------------------------------------------------------
    Author: Hazy Lunar
    Description: Modder for the Valhalla Community.

    Purpose: This file offers a logger utility for the Safe Entry Guard mod,
             enabling varied levels of debugging and information logging for easier
             troubleshooting and status tracking.

    Special thanks to the Valhalla Community for their continuous support and feedback.

    I'm open to mod commissions for a small fee under $50, depending on the mod size.
    For more details or to buy me a coffee: https://ko-fi.com/hazylunar

    For questions, suggestions, or collaborations, contact Hazy Lunar.
-------------------------------------------------------------------------------------
]]

local SEGLogger = {};

-- Setting up the log levels
SEGLogger.DEBUG = 1;
SEGLogger.INFO = 2;
SEGLogger.WARNING = 3;
SEGLogger.ERROR = 4;
SEGLogger.CRITICAL = 5;

-- Current log level
SEGLogger.currentLogLevel = SEGLogger.DEBUG; -- Default is DEBUG. Change this as needed.

-- Logger's name (can be changed if used for other mods/modules)
SEGLogger.name = "SafeEntryGuard";

function SEGLogger:setLogLevel(level)
    self.currentLogLevel = level;
end

function SEGLogger:setLoggerName(name)
    self.name = name;
end

function SEGLogger:log(message, level)
    if not level then
        level = self.INFO; -- default to INFO if no level is provided
    end

    if level < self.currentLogLevel then
        return;
    end

    local prefix = "";

    if level == self.DEBUG then
        prefix = "[DEBUG]";
    elseif level == self.INFO then
        prefix = "[INFO]";
    elseif level == self.WARNING then
        prefix = "[WARNING]";
    elseif level == self.ERROR then
        prefix = "[ERROR]";
    elseif level == self.CRITICAL then
        prefix = "[CRITICAL]";
    end

    local timestamp = os.date("%Y-%m-%d %H:%M:%S"); -- Format: YYYY-MM-DD HH:MM:SS

    print("[" .. timestamp .. "]" .. prefix .. " [" .. self.name .. "] " .. message);
end

return SEGLogger;
