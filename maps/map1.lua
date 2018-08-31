function loadMap()
  wall:create(25, 300, 50, 600)
  wall:create(775, 300, 50, 600)
  wall:create(400, 25, 700, 50)
  wall:create(400, 575, 700, 50)
  
  wall:create(200, 200, 100, 100)
  wall:create(600, 400, 100, 100)
  wall:create(550, 250, 50, 50)
  wall:create(250, 350, 50, 50)
  
  goal:create(175, 175, 50, 50, "blue")
  goal:create(625, 425, 50, 50, "orange")
  
  con1 = gamepad:create(joysticks[1])
  con2 = gamepad:create(joysticks[2])
  player:create(100, 100, -100, 0, con1, "blue")
  player:create(700, 500, 100, 0, con2, "orange")
  
  ball:create(400, 300)
end