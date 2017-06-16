radian = math.rad(math.pi / 2)

player = {
  x=200,
  y=200
}

mouse = {
  x=200,
  y=200,
  dx=0,
  dy=0
}

camera = {}
camera.x = love.graphics.getWidth()/2
camera.y = love.graphics.getHeight()/2

speed=5

function camera:set()
  love.graphics.push()
  love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
  love.graphics.pop()
end

function camera:setpos(x, y)
  if x > 0 then
    self.x = x
  end
  if y > 0 then
    self.y = y
  end
end

function camera:mousepos()
  return love.mouse.getX() + self.x,
         love.mouse.getY() + self.y
end

function love.load()

end

function love.update(dt)
  if love.mouse.isDown(1) then
    mouse.x, mouse.y = camera:mousepos()
  end
  if player.x < mouse.x-speed then
    player.dx = speed
  elseif player.x > mouse.x+speed then
    player.dx = -speed
  else
    player.dx = 0
    player.x = mouse.x
  end
  if player.y < mouse.y-speed then
    player.dy = speed
  elseif player.y > mouse.y+speed then
    player.dy = -speed
  else
    player.dy = 0
    player.y = mouse.y
  end

  player.x = player.x + player.dx
  player.y = player.y + player.dy
end


function love.draw()
  -- camera ops
  camera:set()
  camera:setpos(player.x-(love.graphics.getWidth()/2),
                player.y-(love.graphics.getHeight()/2))
  love.graphics.print("x:"..player.x.." y:"..player.y,player.x-40,player.y+20)
  love.graphics.setColor(108,18,18)

  for x=0,love.graphics.getWidth(),30 do
    love.graphics.line(x,0,x,love.graphics.getHeight())
  end
  
  for y=0,love.graphics.getHeight(),30 do
    love.graphics.line(0,y,love.graphics.getWidth(),y)
  end
  if mouse.x and mouse.y then
    love.graphics.circle("fill", mouse.x, mouse.y, 10)

  end
  
  love.graphics.setColor(255,255,255)
  love.graphics.circle("fill", player.x, player.y, 10)

  camera:unset()

end