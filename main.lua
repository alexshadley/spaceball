HC = require "hardoncollider"
require "config"
require "wall"
require "player"
require "gamepad"
require "ball"
require "goal"

require(mapLocation)

function on_collide(dt, shapeA, shapeB, dx, dy)
  for i, v in ipairs(colliderPriorities) do
    if shapeA.parent.tag == v then shapeA.parent:collide(shapeB.parent, dx, dy) break
    elseif shapeB.parent.tag == v then shapeB.parent:collide(shapeA.parent, dx, dy) break end
  end
end

function love.load(arg)
  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
  
  --love.window.setFullscreen(true)
  
  joysticks = love.joystick.getJoysticks()
  
  Collider = HC(100, on_collide)
  colliderPriorities = {"player", "ball", "wall", "goal"}
  
  objectLists = {playerList, ballList, wallList, goalList}
  
  loadMap()
  
  score = {blue = 0, orange = 0}
  scoreFont = love.graphics.newFont(30)
  
  gameTime = 0
end

function reset()
  for i, v in ipairs(objectLists) do
    for ii, vv in ipairs(v) do
      if vv.reset then
        vv:reset()
      end
    end
  end
end

function love.update(dt)
  gameTime = gameTime + dt
  
  for i, v in ipairs(objectLists) do
    for ii, vv in ipairs(v) do
      vv:update(dt)
    end
  end
  
  for i, v in ipairs(gamepadList) do
    v:update()
  end
  
  Collider:update(dt)
end

function love.draw()
  love.graphics.setFont(scoreFont)
  love.graphics.setColor(90, 100, 230)
  love.graphics.print(score.blue, 350, 285)
  love.graphics.setColor(255, 190, 30)
  love.graphics.print(score.orange, 430, 285)
  
  love.graphics.setColor(255, 255, 255)
  
  for i, v in ipairs(objectLists) do
    for ii, vv in ipairs(v) do
      vv:draw()
    end
  end
  --[[love.graphics.setColor(255, 0, 0)
  for shape in Collider:activeShapes() do
    shape:draw("line")
  end]]
end