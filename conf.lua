function love.conf(t)
  t.version = "11.3"
  t.identity = "powerlink"

  t.window.title = "PowerLink Nuclear Power Plant. EndeyshentLabs (C), 2023"
  t.window.icon = "res/gfx/powerlink2_128.png"
  t.window.width = 1280
  t.window.height = 720
  t.window.resizable = true
  t.window.borderless = true
  t.window.fullscreen = false
  t.window.minwidth = 1280
  t.window.minheight = 720
  t.window.highdpi = true
  t.window.vsync = true

  t.modules.joystick = false
  t.modules.touch = false
end
