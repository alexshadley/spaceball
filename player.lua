playerList = {}
player = {}

function player:create(x, y, xVel, yVel, controller, team)
  o = {}
  setmetatable(o, {__index = player})
  
  o.x, o.y, o.controller, o.team = x, y, controller, team
  o.velocity = {x = xVel, y = yVel}
  o.origin = {x = o.x, y = o.y, xVel = o.velocity.x, yVel = o.velocity.y}
  
  teamCount = 0
  for i, v in ipairs(playerList) do
    if v.team == o.team then
      teamCount = teamCount + 1
    end
  end
  o.variant = teamCount + 1
  
  o.facing = 0 --0 for flying, 1 for top, 2 right, 3 bottom, 4 left
  o.attachWall = nil
  o.attachBall = nil
  o.lastSmack = 0
  
  --balancing variables
  o.jumpVelocity = 200
  o.runVelocity = 100
  o.size = 32
  o.reach = 48
  o.throwPower = 400
  --balancing variables
  
  o.tag = "player"
  o.collider = Collider:addRectangle(x, y, o.size, o.size)
  o.collider.parent = o
  o.reachCollider = Collider:addRectangle(x, y, o.reach, o.reach)
  Collider:setGhost(o.reachCollider)
  
  table.insert(playerList, o)
end

function player:update(dt)
  
  
  if self.facing == 0 then
    self:flyingMove(dt)
  else
    self:groundedMove(dt)
    self:jump(dt)
    self:groundedCheck(dt)
  end
  
  if self.attachBall then
    self:throw(dt)
  else
    self:catch(dt)
    self:smack(dt)
  end
  
  
  self.collider:moveTo(self.x, self.y)
  self.reachCollider:moveTo(self.x, self.y)
end

function player:smack(dt)
  if self.controller.bEdge then
    for i, v in ipairs(playerList) do
      if self.reachCollider:collidesWith(v.collider) and v.lastSmack + 2 < gameTime and v.attachBall and v ~= self then
        self.attachBall = v.attachBall
        v.attachBall = nil
        self.attachBall.attachPlayer = self
        self.lastSmack = gameTime
      end
    end
  end
end

function player:catch(dt)
  if self.controller.bEdge then
    for i, v in ipairs(ballList) do
      if self.reachCollider:collidesWith(v.collider) and not v.attachPlayer then
        self.attachBall = v
        v.attachPlayer = self
      end
    end
  end
end

function player:throw(dt)
  if self.controller.bEdge and self.attachBall and self.controller.joy1.angle then
    self.attachBall:eject(self.controller.joy1.angle, self.throwPower)
    self.attachBall = nil
  end
end

function player:flyingMove(dt)
  self.x = self.x + self.velocity.x * dt
  self.y = self.y + self.velocity.y * dt
end

function player:groundedMove(dt)
  if self.facing == 2 or self.facing == 4 then
    if self.controller.joy1.y < 0 then
      self.y = self.y - self.runVelocity * dt
    elseif self.controller.joy1.y > 0 then
      self.y = self.y + self.runVelocity * dt
    end
  else
    if self.controller.joy1.x < 0 then
      self.x = self.x - self.runVelocity * dt
    elseif self.controller.joy1.x > 0 then
      self.x = self.x + self.runVelocity * dt
    end
  end
end
 
function player:groundedCheck(dt)
  if self.facing == 1 or self.facing == 3 then
    if self.x + (1/2) * (self.size) < self.attachWall.x - (1/2) * (self.attachWall.width) then
      self.velocity.x = -100
      
      if self.facing == 1 then
        self.velocity.y = 20
      else
        self.velocity.y = -20
      end
      self.facing = 0
    elseif self.x - (1/2) * (self.size) > self.attachWall.x + (1/2) * (self.attachWall.width) then
      self.velocity.x = 100
      
      if self.facing == 1 then
        self.velocity.y = 20
      else
        self.velocity.y = -20
      end
      self.facing = 0
    end
  elseif self.facing == 2 or self.facing == 4 then
    if self.y + (1/2) * (self.size) < self.attachWall.y - (1/2) * (self.attachWall.height) then
      self.velocity.y = -100
      
      if self.facing == 2 then
        self.velocity.x = -20
      else
        self.velocity.x = 20
      end
      self.facing = 0
    elseif self.y - (1/2) * (self.size) > self.attachWall.y + (1/2) * (self.attachWall.height) then
      self.velocity.y = 100
      
      if self.facing == 2 then
        self.velocity.x = -20
      else
        self.velocity.x = 20
      end
      self.facing = 0
    end
  end
end

function player:jump(dt)
  if self.controller.a and self.controller.joy1.angle then
    if self.facing == 1 then
      if self.controller.joy1.angle > -(31/32) * math.pi and self.controller.joy1.angle < -(1/32) * math.pi then
        self.y = self.y - 1
      else
        return
      end
    end
    if self.facing == 3 then
      if self.controller.joy1.angle > (1/32) * math.pi and self.controller.joy1.angle < (31/32) * math.pi then
        self.y = self.y + 1
      else
        return
      end
    end
    if self.facing == 2 then
      if self.controller.joy1.angle > -(15/32) * math.pi and self.controller.joy1.angle < (15/32) * math.pi then
        self.y = self.y + 1
      else
        return
      end
    end
    if self.facing == 4 then
      if self.controller.joy1.angle > (17/32) * math.pi or self.controller.joy1.angle < -(17/32) * math.pi then
        self.y = self.y - 1
      else
        return
      end
    end
    
    self.velocity.x = math.cos(self.controller.joy1.angle) * self.jumpVelocity
    self.velocity.y = math.sin(self.controller.joy1.angle) * self.jumpVelocity
    self.facing = 0
  end
end

function player:draw()
  if self.team == "blue" then
    if self.variant == 1 then
      love.graphics.setColor(90, 100, 230)
    else
      love.graphics.setColor(90, 170, 230)
    end
  elseif self.team == "orange" then
    if self.variant == 1 then
      love.graphics.setColor(255, 190, 30)
    else
      love.graphics.setColor(255, 130, 30)
    end
    
  end
  
  love.graphics.rectangle("fill", self.x - (self.size / 2), self.y - (self.size / 2), self.size, self.size)
  if self.controller.joy1.angle then
    love.graphics.setColor(100, 255, 100)
    love.graphics.line(self.x, self.y, self.x + self.size * math.cos(self.controller.joy1.angle), self.y + self.size * math.sin(self.controller.joy1.angle))
  end
end

function player:collide(otherParent, dx, dy)
  if otherParent.tag == "wall" and (math.abs(dx) > 0 or math.abs(dy) > 0) then
    
    if math.abs(dx) > 0 then
      if self.x < otherParent.x then
        self.facing = 4
        self.x = self.x - math.abs(dx)
      else
        self.facing = 2
        self.x = self.x + math.abs(dx)
      end
      
    else
      if self.y < otherParent.y then
        self.facing = 1
        self.y = self.y - math.abs(dy)
      else
        self.facing = 3
        self.y = self.y + math.abs(dy)
      end
    end
    
    self.velocity.x, self.velocity.y = 0, 0
    self.attachWall = otherParent
  end
end

function player:reset()
  self.x = self.origin.x
  self.y = self.origin.y
  self.facing = 0
  self.velocity.x = self.origin.xVel
  self.velocity.y = self.origin.yVel
end