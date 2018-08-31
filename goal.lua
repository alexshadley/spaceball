goalList = {}
goal = {}

function goal:create(x, y, width, height, team)
  o = {}
  setmetatable(o, {__index = self})
  
  o.x, o.y, o.width, o.height, o.team = x, y, width, height, team
  
  o.tag = "goal"
  o.collider = Collider:addRectangle(x - width / 2, y - height / 2, width, height)
  o.collider.parent = o
  
  table.insert(goalList, o)
end
  
function goal:update(dt)
  
end
  
function goal:draw()
  if self.team == "blue" then
    love.graphics.setColor(90, 100, 230)
  elseif self.team == "orange" then
    love.graphics.setColor(255, 190, 30)
  end
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function goal:collide(otherParent)
  
end