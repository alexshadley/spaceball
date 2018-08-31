ballList = {}
ball = {}

function ball:create(x, y)
  o = {}
  setmetatable(o, {__index = ball})
  
  o.x, o.y = x, y
  
  o.velocity = {x = 0, y = 0}
  o.attachPlayer = nil
  
  --balancing variables
  o.drag = .2
  o.ricochetDrag = 10
  o.size = 12
  --balancing variables
  
  o.tag = "ball"
  o.collider = Collider:addRectangle(x, y, o.size, o.size)
  o.collider.parent = o
  
  table.insert(ballList, o)
end

function ball:update(dt)
  if self.attachPlayer then
    self:attachMove(dt)
  else
    self:move(dt)
  end
  
  self.collider:moveTo(self.x, self.y)
end

function ball:move(dt)
  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt
  
  self.velocity.x = self.velocity.x * (1 - self.drag * dt)
  self.velocity.y = self.velocity.y * (1 - self.drag * dt)
end

function ball:attachMove(dt)
  self.x = self.attachPlayer.x
  self.y = self.attachPlayer.y
end

function ball:collide(otherParent, dx, dy)
  if otherParent.tag == "wall" then
    if math.abs(dx) > 0 then
      if self.x < otherParent.x then
        self.x = self.x - math.abs(dx)
      else
        self.x = self.x + math.abs(dx)
      end
      
      self.velocity.x = -self.velocity.x
    else
      if self.y < otherParent.y then
        self.y = self.y - math.abs(dy)
      else
        self.y = self.y + math.abs(dy)
      end
      
      self.velocity.y = -self.velocity.y
    end
  end
  
  if otherParent.tag == "goal" then
    if otherParent.team == "blue" then
      score.orange = score.orange + 1
    elseif otherParent.team == "orange" then
      score.blue = score.blue + 1
    end
    
    reset()
  end
end

function ball:eject(angle, velocity)
  self.velocity.x = velocity * math.cos(angle)-- + self.attachPlayer.velocity.x
  self.velocity.y = velocity * math.sin(angle)-- + self.attachPlayer.velocity.y
  self.attachPlayer = nil
end

function ball:draw(dt)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.x - self.size / 2, self.y - self.size / 2, self.size, self.size)
end

function ball:reset()
  self.x, self.y = 400, 300
  self.velocity.x, self.velocity.y = 0, 0
end