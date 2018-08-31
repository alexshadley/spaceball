function loadMap()
  wall:create(400, 25, 800, 50)
  wall:create(400, 575, 800, 50)
  wall:create(25, 300, 50, 500)
  wall:create(775, 300, 50, 500)
  
  wall:create(400, 225, 500, 50)
  wall:create(400, 375, 500, 50)

  wall:create(175, 125, 50, 50)
  wall:create(625, 125, 50, 50)
  wall:create(175, 475, 50, 50)
  wall:create(625, 475, 50, 50)
  
  goal:create(400, 212, 100, 24, "blue")
  goal:create(400, 388, 100, 24, "orange")
  
  con1 = gamepad:create(joysticks[1])
  con2 = gamepad:create(joysticks[2])
  con3 = gamepad:create(joysticks[3])
  con4 = gamepad:create(joysticks[4])
  player:create(300, 150, 0, 100, con1, "blue")
  player:create(500, 150, 0, 100, con2, "blue")
  player:create(300, 450, 0, -100, con3, "orange")
  player:create(500, 450, 0, -100, con4, "orange")
  
  ball:create(400, 300)
end