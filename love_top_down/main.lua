function love.load()
  sprites = {}
  sprites.player = love.graphics.newImage("sprites/player.png")
  sprites.zombie= love.graphics.newImage("sprites/zombie.png")
  sprites.bullet= love.graphics.newImage("sprites/bullet.png")
  sprites.background = love.graphics.newImage("sprites/background.png")

  player ={}
  player.x = love.graphics.getWidth()/2
  player.y = love.graphics.getHeight()/2
  player.speed = 180

  zombies = {}
  bullets = {}

end

function love.update(dt)
  if love.keyboard.isDown("d")  then
    player.x = player.x + player.speed * dt
  end

  if love.keyboard.isDown("a")  then
    player.x = player.x - player.speed * dt
  end

  if love.keyboard.isDown("w")  then
    player.y = player.y - player.speed * dt
  end
  
  if love.keyboard.isDown("s")  then
    player.y = player.y + player.speed * dt
  end

  for i, z in pairs(zombies) do
                z.x = z.x + math.cos(playerEnemyAngle(z)) * z.speed * dt
    z.y = z.y + math.sin(playerEnemyAngle(z)) * z.speed * dt

    if distanceBetween(z.x,z.y,player.x,player.y) < 30 then
      for i, z in pairs(zombies) do
        zombies[i] = nil
      end
    end
  end

  for i, b in pairs(bullets) do
    b.x = b.x + math.cos(b.direction) * b.speed * dt
    b.y = b.y + math.sin(b.direction) * b.speed * dt

  end

  for i=#bullets,1,-1 do
    local b = bullets[i]
    if b.x < 0 or b.x > love.graphics.getWidth() or b.y < 0 or b.y > love.graphics.getHeight() then
      table.remove(bullets,i)
      print("d :"..i)
    end

    for i, z in pairs(zombies) do
      for i, b in pairs(bullets) do
        if distanceBetween(z.x,z.y,b.x,b.y) < 20 then
          z.dead = true
          b.dead = true
        end
      end
    end

    for i = #zombies, 1, -1 do
      local z = zombies[i]
      if z.dead then
        table.remove(zombies,i)
      end
    end

    for i = #bullets, 1, -1 do
      local b = bullets[i]
      if b.dead then
        table.remove(bullets,i)
      end
    end
  end

end

function love.draw()
  love.graphics.draw(sprites.background,0,0)
  love.graphics.draw(sprites.player,player.x,player.y,playerMouseAngle(),nil,nil,sprites.player:getWidth()/2,sprites.player:getHeight()/2)

  while #zombies < 4 do
    spawnZombie()
  end

  for i, z in pairs(zombies) do
    love.graphics.draw(sprites.zombie,z.x,z.y,playerEnemyAngle(z),nil,nil,sprites.zombie:getWidth()/2,sprites.zombie:getHeight()/2)
  end

  for i, b in pairs(bullets) do
    love.graphics.draw(sprites.bullet,b.x,b.y,nil,.5,nil,sprites.bullet:getWidth()/2,sprites.bullet:getHeight()/2)
  end
end

function love.mousepressed(x,y,button)
  if button==1 then
    spawnBullet()
  end
end

function playerMouseAngle()
  return math.atan2(player.y-love.mouse.getY(),player.x-love.mouse.getX()) + math.pi
end

function playerEnemyAngle(enemy)
  return math.atan2(player.y-enemy.y,player.x-enemy.x)
end

function spawnZombie()
  local zombie = {}

  zombie.x = math.random(0,love.graphics.getWidth())
  zombie.y = math.random(0,love.graphics.getHeight())
  zombie.dead = false
  zombie.speed = 140

  local side = math.random(1,4)
  if side == 1 then
    zombie.x = -30
  elseif side == 2 then
    zombie.y = -30
  elseif side == 3 then
    zombie.y = love.graphics.getHeight()+30
  elseif side == 4 then
    zombie.x = love.graphics.getWidth()+30
  end

  table.insert(zombies,zombie)
end

function spawnBullet()
  local bullet = {}
  bullet.x = player.x
  bullet.y = player.y
  bullet.speed = 500
  bullet.direction = playerMouseAngle()
  bullet.dead = false
  table.insert(bullets,bullet)
end

function distanceBetween(x1,y1,x2,y2)
  return math.sqrt((x2-x1)^2+(y2-y1)^2)
end
