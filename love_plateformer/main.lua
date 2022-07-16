function love.load()
  anim8 = require "libraries.anim8.anim8"
  wf = require "libraries.windfield.windfield"
  sti = require "libraries.Simple-Tiled-Implementation.sti"
  cameraFile = require "libraries.hump.camera"

  cam = cameraFile()

  love.window.setMode(1000,768)

  sprites= {}
  sprites.playerSheet = love.graphics.newImage("sprites/playerSheet.png")
  sprites.enemySheet = love.graphics.newImage("sprites/enemySheet.png")

  local grid = anim8.newGrid(614,564,sprites.playerSheet:getWidth(),sprites.playerSheet:getHeight())
  local enemyGrid = anim8.newGrid(100,79,sprites.enemySheet:getWidth(),sprites.enemySheet:getHeight())
  animations = {}
  -- 1-15 #frames , rowline, time 
  animations.idle = anim8.newAnimation(grid("1-15",1),.05)
  animations.run= anim8.newAnimation(grid("1-15",3),.05)
  animations.jump = anim8.newAnimation(grid("1-7",2),.05)

  animations.enemy = anim8.newAnimation(enemyGrid("1-2",1),.03)
 -- 0,100 gravity x,y
 world = wf.newWorld(0,800,false)
 world:setQueryDebugDrawing(true)

 world:addCollisionClass("Platform")
 world:addCollisionClass("Player" --[[, {ignores = {"Platform"}} ]])
 world:addCollisionClass("Danger")

 platforms = {}
 dangerZone = world:newRectangleCollider(0,550,800,50,  {collision_class = "Danger"})
 flagX = 0
 flagY = 0
 

 require("player")
 require("enemy")
 require("libraries.show")

 dangerZone:setType("static")

 loadMap()
 --spawnEnemy(1000,220)
end

function love.update(dt)
  world:update(dt)
  gameMap:update(dt)
  updatePlayer(dt)
  updateEnemies(dt)
  local px, _= player:getPosition()
  cam:lookAt(px,love.graphics.getHeight()/2)

  local flagCollision = world:queryCircleArea(flagX,flagY,10,{"Player"})
  if #flagCollision > 0 then
    print("ok")
  end
end

function love.draw()
  cam:attach()
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    world:draw()
    drawPlayer()
    drawEnemies()
  cam:detach()
  -- HUD
end

function spawnPlatform(x,y,w,h)
  if w>0 and h>0 then
   local platform = world:newRectangleCollider(x,y,w,h, {collision_class = "Platform"})
   platform:setType("static")
   table.insert(platforms,platform)
  end
end


function destroyAll()

end

function loadMap()
  gameMap = sti("maps/level1.lua")
  for _, obj in pairs(gameMap.layers["Platforms"].objects) do
    spawnPlatform(obj.x,obj.y,obj.width,obj.height)
  end
  for _, obj in pairs(gameMap.layers["Enemies"].objects) do
    spawnEnemy(obj.x,obj.y,obj.width,obj.height)
  end
  for _, obj in pairs(gameMap.layers["Flag"].objects) do
    flagX = obj.x
    flagY = obj.y
  end

end
