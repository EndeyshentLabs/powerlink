-- Yoinked from https://love2d.org/wiki/love.math.colorFromBytes#Example
function SetColorHEX(rgba)
  -- setColorHEX(rgba)
  -- where rgba is string as "#336699cc"
  local rb = tonumber(string.sub(rgba, 2, 3), 16)
  local gb = tonumber(string.sub(rgba, 4, 5), 16)
  local bb = tonumber(string.sub(rgba, 6, 7), 16)
  local ab = tonumber(string.sub(rgba, 8, 9), 16) or nil
  love.graphics.setColor(love.math.colorFromBytes(rb, gb, bb, ab))
end

function isDebug()
  if arg[#arg] == "-debug" or arg[#arg] == "--debug" then
    return true
  else
    return false
  end
end
