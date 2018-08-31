wallList = {}
wall = {}

function wall:create(x, y, width, height)
  o = {}
  setmetatable(o, {__index = self})
  
  o.x, o.y, o.width, o.height = x, y, width, height
  
  o.tag = "wall"
  o.collider = Collider:addRectangle(x - width / 2, y - height / 2, width, height)
  o.collider.parent = o
  
  table.insert(wallList, o)
end
  
function wall:update(dt)
  
end
  
function wall:draw()
  love.graphics.setColor(170, 170, 190)
  love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function wall:collide(otherParent)
  
end