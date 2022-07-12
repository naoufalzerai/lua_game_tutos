function love.load()
  print('tesr')
  target = {}
  target.x=200
  target.y=200
  target.radius=50
  score = 0
  timer = 0

  gameFont=love.graphics.newFont(40)
  sprites = {}
  sprites.sky = love.graphics.newImage('sprites/sky.png')
  sprites.target= love.graphics.newImage('sprites/target.png')
  sprites.crosshairs= love.graphics.newImage('sprites/crosshairs.png')

  love.mouse.setVisible(false)
  
  gameState = 1

end

function love.update(dt)
  if timer>0 then
    timer = timer - dt
  end
  if timer<0 then
    timer = 0
    gameState = 1
  end
end

function love.draw()

  love.graphics.setFont(gameFont)
  love.graphics.draw(sprites.sky,0,0)
  love.graphics.print(score,0,0)
  love.graphics.print(math.ceil(timer),love.graphics.getWidth()-150,0)
  if gameState == 1 then
    love.graphics.printf("Press to start",0,255,love.graphics.getWidth(),"center")
  elseif gameState==2 then
    love.graphics.draw(sprites.target,target.x-target.radius,target.y-target.radius)
    love.graphics.setColor(1,1,1)
  end
  love.graphics.draw(sprites.crosshairs,love.mouse.getX()-20,love.mouse.getY()-20)
end

function love.mousepressed(x,y,button,istouch,presses)
  if button==1 and gameState==2 then
    local distance = distanceBetween(x,y,target.x,target.y)
    if distance<=target.radius  then
      score=score+1
      target.y = math.random(target.radius,love.graphics.getHeight()-target.radius)
      target.x = math.random(target.radius,love.graphics.getWidth()-target.radius)
    end
  elseif button==1 and gameState ==1 then
    score= 0
    timer=10
    gameState=2
  end
end

function distanceBetween(x1,y1,x2,y2)
  return math.sqrt((x2-x1)^2+(y2-y1)^2)
end
