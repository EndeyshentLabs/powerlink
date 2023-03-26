require("util")
require("events")
require("states")

GlobarTimer = 0

local heat = 0
local water = 100
local power = 0
local ece = 40

timer = 0
dTime = 0

local started = false
local superWater = false
local hasEvent = false
local lose = false

local evTime = 0
local evTimeStart = 0

font = nil
sounds = {}
images = {}

function love.load()
  -- font = love.graphics.newFont("res/LinearBeam.ttf", 16)
  font = love.graphics.newFont("res/Segment14.otf", 32)

  -- Sounds
  sounds["alarm"] = love.audio.newSource("res/sfx/alarm01.wav", "static")
  sounds["alarm"]:setVolume(0.5)
  sounds["energy"] = love.audio.newSource("res/sfx/energy01.wav", "static")
  sounds["signal"] = love.audio.newSource("res/sfx/signal01.wav", "static")
  sounds["beep"] = love.audio.newSource("res/sfx/beep01.wav", "static")

  -- Images
  images["powerlink2"] = love.graphics.newImage("res/gfx/powerlink2.png")
end

function love.update(dt)
  if dt < 1 / 60 then love.timer.sleep(1 / 60 - dt) end
  GlobarTimer = GlobarTimer + 1
  if heat >= 2500 then
    started = false
    lose = true
  end
  if lose then
    started = false
    sounds["alarm"]:setVolume(0)
    return
  end
  if not started then return end
  if hasEvent then evTime = dTime - evTimeStart end
  sounds["energy"]:play()
  timer = timer + 1
  power = (heat / water * ece ^ 2) -- * dt * 100

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
    hasEvent = false
  end

  if ((dTime % 60 >= 0 and dTime % 60 <= 0.01) or (isDebug() and love.keyboard.isDown("e"))) and not hasEvent then
    event, energy, time = RandomizeEvents()
    hasEvent = true
    evTimeStart = dTime
    if sounds["alarm"]:isPlaying() then sounds["alarm"]:stop() end
    sounds["signal"]:play()
    if isDebug() then print(("EV: %s, EG: %d"):format(event, energy)) end
  end

  if water < 70 then
    heat = (2 * ece / water + heat + 1 + water / 10) -- * dt * 100
  end

  if water > 70 then
    if heat > 400 --[[and timer % 7 == 0]] then
      heat = (heat - 0.5) -- * dt * 10
    end
  end

  if water <= 100 and water > 70 then heat = heat + 0.01 end

  if love.keyboard.isDown("up") and water < 100 and not superWater then
    water = water + 10 * dt
  end
  if love.keyboard.isDown("up") and water < 125 and superWater then
    water = water + 10 * dt
  end
  if love.keyboard.isDown("down") and water > 0 then
    water = water - 10 * dt
  end

  if water > 100 and not superWater then water = 100 end
  if water > 125 and superWater then water = 125 end
  if water <= 0 then water = 0.1 end
end

function love.draw()
  dTime = math.floor(love.timer.getTime())
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
    font
  )
  SetColorHEX("#212121")
  love.graphics.rectangle("fill", 0, 32 * 4 + 5, 374, love.graphics.getHeight())

  if hasEvent then
    eventOn()
    SetColorHEX("#ff0000")
    love.graphics.print(
      ("\n" ..
      "%s\n" ..
      "* ENERGY %d\n" ..
      "* TIME   %d\n" ..
      "** ELAPSED TIME %d\n" ..
      "** REMAINING    %d"
      ):format(event, energy, time, evTime,
        time - evTime),
      font, 374, 0)
  end

  SetColorHEX("#ffffff")
  love.graphics.draw(images["powerlink2"], 0, love.graphics.getHeight() - (1024 / 2.9), 0, 0.05, 0.05)

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
