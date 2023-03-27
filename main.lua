require("util")
require("events")
require("states")

-- Reactor stats
local heat = 0
local water = 100
local power = 0
local ece = 30

-- Rounded love.timer.getTime()
Time = 0

-- Game states
local started = false
local superWater = false
local hasEvent = false
local lose = false

-- Events
local evTime = 0
local evTimeStart = 0
local evNum = 0
-- Event requirements
local event = nil -- Event text
local time = 0
local energy = 0
local noMore = 0

-- Resources
Font = nil
Sounds = {}
Images = {}

-- Mobile
local x, y = nil, nil

function love.load()
  Font = love.graphics.newFont("res/Segment14.otf", 32)

  -- Sounds
  Sounds["alarm"] = love.audio.newSource("res/sfx/alarm01.wav", "static")
  Sounds["alarm"]:setVolume(0.5)
  Sounds["energy"] = love.audio.newSource("res/sfx/energy01.wav", "static")
  Sounds["signal"] = love.audio.newSource("res/sfx/signal01.wav", "static")
  Sounds["beep"] = love.audio.newSource("res/sfx/beep01.wav", "static")

  -- Images
  Images["powerlink2"] = love.graphics.newImage("res/gfx/powerlink2.png")
end

function love.update(dt)
  Time = math.floor(love.timer.getTime())
  if dt < 1 / 60 then love.timer.sleep(1 / 60 - dt) end -- Force 60 FPS(RIP <60 Hz monitor users)
  if heat >= 2500 then
    started = false
    lose = true
  end
  if lose then
    started = false
    Sounds["alarm"]:setVolume(0)
    return
  end
  if not started then return end
  if hasEvent then evTime = Time - evTimeStart end
  Sounds["energy"]:play()
  power = (heat / water * ece ^ 2) -- * dt * 10

  if not hasEvent then
    evTime = 0
    evTimeStart = 0
    time = 0
    energy = 0
    event = nil
  end

  if evTime == time and hasEvent then
    if power < energy then
      print(("LOSE: %d"):format(power - energy))
      lose = true
    end
    if power > noMore and noMore ~= ENERGY_LIMIT_DEFAULT then
      lose = true
    end
    hasEvent = false
  end

  if ((Time % 60 >= 0 and Time % 60 <= 0.01) or (isDebug() and love.keyboard.isDown("e"))) and not hasEvent then
    event, energy, time, noMore = RandomizeEvents()
    evNum = evNum + 1
    hasEvent = true
    evTimeStart = Time
    if Sounds["alarm"]:isPlaying() then Sounds["alarm"]:stop() end
    Sounds["signal"]:play()
    if isDebug() then print(("EV: \"%s\", EG: %d"):format(event, energy)) end
  end

  if water < 70 then
    heat = (2 * ece / water + heat + 1 + water / 10) -- * dt * 10
  end

  if water > 70 then
    if heat > 400 --[[and timer % 7 == 0]] then
      heat = (heat - 0.5) -- * dt * 10
    end
  end

  if water <= 100 and water > 70 then heat = heat + 0.01 end

  if ((love.keyboard.isDown("up")) or (y ~= nil and y <= love.graphics.getHeight() / 2)) and water < 100 and not superWater then
    water = water + 10 * dt
  end
  if ((love.keyboard.isDown("up")) or (y ~= nil and y <= love.graphics.getHeight() / 2)) and water < 125 and superWater then
    water = water + 12 * dt
  end
  if (love.keyboard.isDown("down") or (y ~= nil and y >= love.graphics.getHeight() / 2)) and water > 0 and not superWater then
    water = water - 10 * dt
  end
  if (love.keyboard.isDown("down") or (y ~= nil and y >= love.graphics.getHeight() / 2)) and water > 0 and superWater then
    water = water - 12 * dt
  end

  if water > 100 and not superWater then water = 100 end
  if water > 125 and superWater then water = 125 end
  if water <= 0 then water = 0.1 end
end

function love.draw()
  SetColorHEX("#101010")
  love.graphics.rectangle("fill", 0, 0, 374, love.graphics.getHeight())
  SetColorHEX("#ff0000")
  love.graphics.print(
    string.format(
      "*REACTOR STATS*\n" ..
      "HEAT  %d\n" ..
      "WATER %d%%\n" ..
      "POWER %d\n" ..
      "ECE   %d", heat, water, power, ece
    ),
    Font
  )
  SetColorHEX("#212121")
  love.graphics.rectangle("fill", 0, 32 * 4 + 5, 374, love.graphics.getHeight())

  if hasEvent then
    eventOn()
    SetColorHEX("#ff0000")
    if noMore ~= ENERGY_LIMIT_DEFAULT then
      love.graphics.print(
        ("\n" ..
        "%s\n" ..
        "* ENERGY %d\n" ..
        "* BUT NO MORE THAN %d\n" ..
        "* TIME   %d\n" ..
        "** ELAPSED TIME %d\n" ..
        "** REMAINING    %d"
        ):format(event, energy, noMore, time, evTime,
          time - evTime),
        Font, 374, 0)
    else
      love.graphics.print(
        ("\n" ..
        "%s\n" ..
        "* ENERGY %d\n" ..
        "* TIME   %d\n" ..
        "** ELAPSED TIME %d\n" ..
        "** REMAINING    %d"
        ):format(event, energy, time, evTime,
          time - evTime),
        Font, 374, 0)
    end
  end

  SetColorHEX("#ffffff")
  if love.system.getOS() ~= "Android" or love.system.getOS() ~= "iOS" then
    love.graphics.draw(Images["powerlink2"], 0, love.graphics.getHeight() - (1024 / 2.9), 0, 0.05, 0.05)
  end

  SetColorHEX("#ff0000")
  love.graphics.print(("\n\n\n\n\n\n\n\n\nNO. OF EVENTS %d"):format(evNum), Font)

  if not started then offlineState() end
  if started then onlineState() end
  if not superWater then superWaterOff() end
  if superWater then superWaterOn() end
  if heat > 1000 then overheat() end
  if lose then kaboom() end
end

function love.keypressed(key)
  if key == "space" then started = not started end
  if key == "s" then superWater = not superWater end
  if key == "f5" then love.event.quit("restart") end
  if key == "escape" then love.event.quit() end
  if key == "f11" then love.window.setFullscreen(not love.window.getFullscreen()) end
end

---@diagnostic disable-next-line: unused-local
function love.touchpressed(id, _x, _y, dx, dy, pressure)
  x, y = _x, _y
  if (x ~= nil and y ~= nil) and x < 374 and y < love.graphics.getHeight() / 2 then
    y = 0
    started = not started
  end
  if (x ~= nil and y ~= nil) and x < 374 and y > love.graphics.getHeight() / 2 then
    y = 0
    superWater = not superWater
  end
end

---@diagnostic disable-next-line: unused-local
function love.touchreleased(id, _x, _y, dx, dy, pressure)
  ---@diagnostic disable-next-line: cast-local-type
  x, y = nil, nil
end
