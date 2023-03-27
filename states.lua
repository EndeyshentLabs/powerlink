---@diagnostic disable: lowercase-global
require("util")

function offlineState()
  SetColorHEX("#ff0000")
  if Time % 2 == 0 then SetColorHEX("#ffffff") end
  love.graphics.print("\n\n\n\n\nREACTOR OFFLINE", Font)
end

function onlineState()
  SetColorHEX("#00ff00")
  if Time % 2 == 0 then SetColorHEX("#33ff33") end
  love.graphics.print("\n\n\n\n\nREACTOR ONLINE", Font)
end

function superWaterOff()
  SetColorHEX("#ff0000")
  if Time % 2 == 0 then SetColorHEX("#ffffff") end
  love.graphics.print("\n\n\n\n\n\nSUPER PUMPING OFF", Font)
end

function superWaterOn()
  SetColorHEX("#00ff00")
  if Time % 2 == 0 then SetColorHEX("#33ff33") end
  love.graphics.print("\n\n\n\n\n\nSUPER PUMPING ON", Font)
end

function overheat()
  SetColorHEX("#ff0000")
  if Time % 2 == 0 then
    SetColorHEX("#ff3333")
    Sounds["alarm"]:play()
  end
  love.graphics.rectangle("fill", 0, 32 * 6 - 3, 374, 25)
  SetColorHEX("#000000")
  love.graphics.print("\n\n\n\n\n\n\n~~~ OVERHEAT", Font)
end

function kaboom()
  if Time % 2 == 0 then
    SetColorHEX("#ff0000")
    love.graphics.rectangle("fill", 0, 32 * 7 - 8, 374, 25)
    SetColorHEX("#ffffff")
    Sounds["beep"]:play()
    love.graphics.print("\n\n\n\n\n\n\n\n ~  KABOOM  ~ ", Font)
  else
    SetColorHEX("#ffffff")
    love.graphics.rectangle("fill", 0, 32 * 7 - 8, 374, 25)
    SetColorHEX("#ff0000")
    love.graphics.print("\n\n\n\n\n\n\n\n~ ~ KABOOM ~ ~", Font)
  end
end

function eventOn()
  if Time % 2 == 0 then
    SetColorHEX("#ffffff")
    love.graphics.print("~ ACTIVE EVENT", Font, 374, 0)
  else
    SetColorHEX("#ff0000")
    love.graphics.print("  ACTIVE EVENT", Font, 374, 0)
  end
end
