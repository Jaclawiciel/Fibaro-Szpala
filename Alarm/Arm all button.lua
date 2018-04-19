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
local alarmZoneIDs = {57, 58, 61, 63} -- tablica z ID stref do uzbrojenia
-- ************ END configuration block ************

-- ************ BEGIN helper functions ************
-- Wyświetla kolorowe logi.
-- Przykład użycia Log("green", "Log testowy")
Log = function ( color, message )
    fibaro:debug(string.format('<%s style="color:%s;">%s', "span", color, message, "span"))
end

-- Wyświetla kolorowe logi gdy zmienna 'debugMode' ustawiona na true
-- Przykład użycia Debug("green", "Debug testowy")
Debug = function ( color, message)
    if debugMode == true then
        fibaro:debug(string.format('<%s style="color:%s;">%s', "span", color, message, "span"))
    end
end

-- Uzbraja strefę o ID przekazanym w parametrze 'zoneID'
function armZone(zoneID)
    fibaro:call(zoneID, "setArmed", "1");
    Debug("orange", "Zone "..zoneID.. " armed")
end

-- Aktualizuje interfejs urządzenia wirtualnego np. zmieniając opisy labeli oraz ikony
function updateUI(armState)
    if armState == "arm" then
        fibaro:call(fibaro:getSelfId(), "setProperty", "ui.alarmStateLabel.value", "Alarm uzbrojony") -- Ustawia wartość etykiety o identyfikatorze alarmStateLabel w tym VD na 'Alarm uzbrojony'
        fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", 1000) -- Ustawia ikonę tego VD na ikonę o ID 1000
    else
        fibaro:call(fibaro:getSelfId(), "setProperty", "ui.alarmStateLabel.value", "Alarm rozbrojony")
        fibaro:call(fibaro:getSelfId(), "setProperty", "currentIcon", 1001)
    end
end
-- ************ END helper functions ************
    
-- ************ BEGIN code block ************
Log("white", "")
Log("green", "Starting script...")

-- Pętla iterujące po wszystkich ID stref do uzbrojenia
-- Zmienna 'zoneID' przyjmuje kolejno wartości z tabeli. Klasyczna pętla foreach.
for _, zoneID in pairs(alarmZoneIDs) do
    armZone(zoneID) -- wywołanie funkcji uzbrajania strefy z przekazaniem ID strefy
end
updateUI("arm") -- aktualizacja interfejsu użytkownika VD
Log("green", "Script ended")
-- ************ END code block ************