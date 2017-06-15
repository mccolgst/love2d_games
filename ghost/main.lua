local anim8 = require 'anim8'
local image, animation

ghostx = 200
ghosty = 200
newx = 200
newy = 200

mousex = love.mouse.getX()
mousey = love.mouse.getY()

speed=.05

function love.load()
  image = love.graphics.newImage('ghost.png')
  local g = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
  animation = anim8.newAnimation(g('1-8',1), 0.1)
end

function love.update(dt)
  animation:update(dt)
  mousex = love.mouse.getX()
  mousey = love.mouse.getY()
  if love.mouse.isDown(1) then
    newx = mousex
    newy = mousey
  end
  abs_y_diff = math.abs(ghosty - newy)
  abs_x_diff = math.abs(ghostx - newx)
  if ghostx < newx then
    ghostx = ghostx + (abs_x_diff * speed)
  else
    ghostx = ghostx - (abs_x_diff * speed)
  end
  if ghosty < newy then
    ghosty = ghosty + (abs_y_diff * speed)
  else
    ghosty = ghosty - (abs_y_diff * speed)
  end
end


function love.draw()
  animation:draw(image, ghostx, ghosty, 0, 4, 4)
end