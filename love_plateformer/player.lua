 player = world:newRectangleCollider(360,100,40,100, {collision_class = "Player"})

 player.speed = 240
 player.animation = animations.run
 player.isMoving = false
 player.direction = 1
 player.grounded = true
 player:setFixedRotation(true)

 function updatePlayer(dt)
  player.isMoving = false
  if player.body then

    platforms = world:queryRectangleArea(player:getX() - 20 ,player:getY() + 50,40,2,{"Platform"})
    if #platforms>0 then
      player.grounded = true
    else
      player.grounded = false
    end

    local px, py = player:getPosition()
    if love.keyboard.isDown("d") then
      player:setX(px + player.speed * dt)
      player.isMoving=true
      player.direction = 1
    end

    if love.keyboard.isDown("a") then
      player:setX(px - player.speed *dt)
      player.isMoving = true
      player.direction = -1
    end

    if player:enter("Danger") then
      player:destroy()
    end

    if player.grounded then
      if player.isMoving then
        player.animation = animations.run
      else
        player.animation = animations.idle
      end
    else
      player.animation = animations.jump
    end

  end

  player.animation:update(dt)

 end


function drawPlayer()
  local px,py = player:getPosition()
  player.animation:draw(sprites.playerSheet,px,py,nil,player.direction *.25,.25,130,300)
end

function love.keypressed(key)
  if key == "w" then
    -- rectagle is in the center 
    if player.grounded then
      player:applyLinearImpulse(0,-4000)
    end
  end
end
