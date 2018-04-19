--
-- Fibaro - Bartłomiej Szpala
-- Virtual Device - Alarm - Main Loop
-- Date: 19.04.2018
-- Time: 19:44
--
-- Created by: Jacek Gałka | http://jacekgalka.pl/en
--
-- ************ BEGIN configuration block ************
local zoneArmStateDeviceID = 1 -- ID urządzenia wskazującego stan uzbrojenia strefy.
local alarmBreachedDeviceID = 2 -- ID urządzenia wskazującego na występowanie alarmu

-- W przyszłości można się pokusić o tablicę ID do sprawdzania, które strefy są uzbrojone i uzbrajania lub rozbrajania oraz aktualizowania UI urządzenia wirtualnego w pętli
-- jak w skrypcie Arm all button.lua.

-- ************ END configuration block ************

-- ************ BEGIN helper functions ************
Log = function ( color, message )
    fibaro:debug(string.format('<%s style="color:%s;">%s', "span", color, message, "span"))
end

Debug = function ( color, message)
    if debugMode == true then
        fibaro:debug(string.format('<%s style="color:%s;">%s', "span", color, message, "span"))
    end
end

function isAlarmZoneArmed(deviceID)
    if tonumber(fibaro:getValue(deviceID, "value")) > 0 then
        Debug("orange", "Alarm zone "..deviceID.." is armed")
        return true
    else
        Debug("orange", "Alarm zone "..deviceID.." is NOT armed")
        return false
    end
end

function armFibaroZone(deviceID)
    Debug("blue", "Arming Fibaro zone "..deviceID)
    fibaro:call(deviceID, "setArmed", "1");
end

function disarmFibaroZone(deviceID)
    Debug("blue", "Disarming Fibaro zone "..deviceID)
    fibaro:call(deviceID, "setArmed", "0");
end

function updateUI(armState)
    if armState == "arm" then
        fibaro:call(fibaro:getSelfId(), "setProperty", "ui.alarmStateLabel.value", "Alarm uzbrojony") -- Ustawia wartość etykiety o identyfikatorze alarmStateLabel w tym VD na 'Alarm uzbrojony'
        fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", 1000) -- Ustawia ikonę TEGO VD na ikonę o ID 1000
    else
        fibaro:call(fibaro:getSelfId(), "setProperty", "ui.alarmStateLabel.value", "Alarm rozbrojony")
        fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", 1001)
    end
end
-- ************ END helper functions ************
    
-- ************ BEGIN code block ************
Log("white", "")
Log("green", "Starting script...")
if isAlarmZoneArmed(zoneArmStateDeviceID) then
    armFibaroZone(alarmBreachedDeviceID)
    updateUI("arm")
else
    disarmFibaroZone(alarmBreachedDeviceID)
    updateUI("disarm")
end
Log("green", "Script ended")
-- ************ END code block ************