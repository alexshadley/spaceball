function loadMap()
  wall:create(400, 25, 800, 50)
  wall:create(400, 575, 800, 50)
  wall:create(50, 375, 100, 350)
  wall:create(750, 225, 100, 350)
  
  wall:create(350, 225, 200, 50)
  wall:create(450, 375, 200, 50)
  wall:create(225, 300, 50, 200)
  wall:create(575, 300, 50, 200)

  wall:create(25, 125, 50, 150)
  wall:create(775, 475, 50, 150)
  
  goal:create(25, 125, 50, 150, "blue")
  goal:create(775, 475, 50, 150, "orange")
  
  con1 = gamepad:create(joysticks[1])
  con2 = gamepad:create(joysticks[2])
  con3 = gamepad:create(joysticks[3])
  con4 = gamepad:create(joysticks[4])
  player:create(150, 100, 0, -100, con1, "blue")
  player:create(650, 100, 0, -100, con2, "blue")
  player:create(150, 500, 0, 100, con3, "orange")
  player:create(650, 500, 0, 100, con4, "orange")
  
  ball:create(400, 300)
end