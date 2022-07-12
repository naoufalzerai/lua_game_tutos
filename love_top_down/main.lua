function love.load()
  print('tesr')
  target = {}
  target.x=200
  target.y=200
  target.radius=50
  score = 0
  timer = 10

  gameFont=love.graphics.newFont(40)
end
function love.update(dt)
  if timer>0 then
    timer = timer - dt
  end
  if timer<0 then 
    timer = 0
  end
end

function love.draw()
  love.graphics.setColor(0,1,0)
  love.graphics.circle("fill",target.x,target.y,target.radius)
  love.graphics.setColor(1,1,1)
  love.graphics.setFont(gameFont)
  love.graphics.print(score,0,0)
  love.graphics.print(math.ceil(timer),love.graphics.getWidth()-150,0)
end


function love.mousepressed(x,y,button,istouch,presses)
  if button==1 and timer ~= 0 then
    local distance = distanceBetween(x,y,target.x,target.y)
    if distance<=target.radius  then
      score=score+1
      target.y = math.random(target.radius,love.graphics.getHeight()-target.radius)
      target.x = math.random(target.radius,love.graphics.getWidth()-target.radius)
    end
  end
end

function distanceBetween(x1,y1,x2,y2)
  return math.sqrt((x2-x1)^2+(y2-y1)^2)
end
