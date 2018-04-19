--
-- Fibaro - Bartłomiej Szpala
-- Virtual Device - Alarm
-- Date: 19.04.2018
-- Time: 17:53
--
-- Created by: Jacek Gałka | http://jacekgalka.pl/en
--
-- ************ BEGIN configuration block ************
debugMode = true
local alarmZoneIDs = {57, 58, 61, 63}
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

function armZone(zoneID)
    --fibaro:call(zoneID, "setArmed", "1");
    Debug("orange", "Zone "..zoneID.. " armed")
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
for _, zoneID in pairs(alarmZoneIDs) do
    armZone(zoneID)
end
updateUI("arm")
Log("green", "Script ended")
-- ************ END code block ************