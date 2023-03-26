require("util")

function offlineState()
  SetColorHEX("#ff0000")
  if dTime % 2 == 0 then SetColorHEX("#ffffff") end
  love.graphics.print("\n\n\n\n\nREACTOR OFFLINE", font)
end

function onlineState()
  SetColorHEX("#00ff00")
  if dTime % 2 == 0 then SetColorHEX("#33ff33") end
  love.graphics.print("\n\n\n\n\nREACTOR ONLINE", font)
end

function superWaterOff()
  SetColorHEX("#ff0000")
  if dTime % 2 == 0 then SetColorHEX("#ffffff") end
  love.graphics.print("\n\n\n\n\n\nSUPER PUMPING OFF", font)
end

function superWaterOn()
  SetColorHEX("#00ff00")
  if dTime % 2 == 0 then SetColorHEX("#33ff33") end
  love.graphics.print("\n\n\n\n\n\nSUPER PUMPING ON", font)
end

function overheat()
  SetColorHEX("#ff0000")
  if dTime % 2 == 0 then
    SetColorHEX("#ff3333")
    sounds["alarm"]:play()
  end
  love.graphics.rectangle("fill", 0, 32 * 6 - 3, 374, 25)
  SetColorHEX("#000000")
  love.graphics.print("\n\n\n\n\n\n\n~~~ OVERHEAT", font)
end

function kaboom()
  if dTime % 2 == 0 then
    SetColorHEX("#ff0000")
    love.graphics.rectangle("fill", 0, 32 * 7 - 8, 374, 25)
    SetColorHEX("#ffffff")
    sounds["beep"]:play()
    love.graphics.print("\n\n\n\n\n\n\n\n ~  KABOOM  ~ ", font)
  else
    SetColorHEX("#ffffff")
    love.graphics.rectangle("fill", 0, 32 * 7 - 8, 374, 25)
    SetColorHEX("#ff0000")
    love.graphics.print("\n\n\n\n\n\n\n\n~ ~ KABOOM ~ ~", font)
  end
end

function eventOn()
  if dTime % 2 == 0 then
    SetColorHEX("#ffffff")
    love.graphics.print("~ ACTIVE EVENT", font, 374, 0)
  else
    SetColorHEX("#ff0000")
    love.graphics.print("  ACTIVE EVENT", font, 374, 0)
  end
end
