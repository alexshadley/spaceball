gamepadList = {}
gamepad = {}

function gamepad:create(source)
  o = {}
  setmetatable(o, {__index = self})
  o.source = source
  
  o.x, o.y, o.a, o.b = false, false, false, false
  o.xOld, o.yOld, o.aOld, o.bOld = false, false, false, false
  o.xEdge, o.yEdge, o.aEdge, o.bEdge = false, false, false, false
  o.joy1, o.joy2 = {x = 0, y = 0, angle = nil}, {x = 0, y = 0, angle = nil}
  
  table.insert(gamepadList, o)
  return o
end

function gamepad:update()
  self.x = self.source:isGamepadDown("x")
  self.y = self.source:isGamepadDown("y")
  self.a = self.source:isGamepadDown("a")
  self.b = self.source:isGamepadDown("b")
  
  self.xEdge = (self.x and not self.xOld) -- boolean logic 'cause I'm fancy
  self.yEdge = (self.y and not self.yOld)
  self.aEdge = (self.a and not self.aOld)
  self.bEdge = (self.b and not self.bOld)
  
  if math.abs(self.source:getGamepadAxis("leftx")) > .05 or math.abs(self.source:getGamepadAxis("lefty")) > .05 then
    self.joy1.x, self.joy1.y = self.source:getGamepadAxis("leftx"), self.source:getGamepadAxis("lefty")
    self.joy1.angle = math.atan2(self.joy1.y, self.joy1.x)
  else
    self.joy1.x, self.joy1.y, self.joy1.angle = 0, 0, nil
  end
  
  if math.abs(self.source:getGamepadAxis("rightx")) > .05 or math.abs(self.source:getGamepadAxis("righty")) > .05 then
    self.joy2.x, self.joy2.y = self.source:getGamepadAxis("rightx"), self.source:getGamepadAxis("righty")
    self.joy2.angle = math.atan2(self.joy2.y, self.joy2.x)
  else
    self.joy2.x, self.joy2.y, self.joy2.angle = 0, 0, nil
  end
  
  self.xOld = self.x
  self.yOld = self.y
  self.aOld = self.a
  self.bOld = self.b
end