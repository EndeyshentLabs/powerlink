Events = {
  "This night will be very cold.\nBoilers will works harder.\nTown requires 5000kV", -- Boilers
  "Today will be a parade of Telsa coils.\nTown requires 10000kV",                   -- Tesla
  "Grill festival will be this morning.\nPrepare about 7500kV",                      -- Grill
}

EventsEnrg = {
  5000,  -- Boilers
  10000, -- Tesla
  7500,  -- Grill
}

EventsTime = {
  60,  -- Boilers
  120, -- Tesla
  15,  -- Grill
}

function RandomizeEvents()
  local i = love.math.random(1, #Events)
  return Events[i], EventsEnrg[i], EventsTime[i]
end
