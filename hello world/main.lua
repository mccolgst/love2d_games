mousex = love.mouse.getX()
mousey = love.mouse.getY()

speed=.05

circs = {}
function love.load()
  love.window.setMode(200,200)
end
function rando_circles()
  for i=0,5 do
    local circ = {}
    circ.x = love.math.random(-1600,1600)
    circ.y = love.math.random(-1600,1600)
    circ.color =
    table.insert(circs, circ)
  end
end

function love.update()
  mousex = love.mouse.getX()
  mousey = love.mouse.getY()
  if love.mouse.isDown(1) then
    circs = {}
    rando_circles()
  end
  for idx,circ in pairs(circs) do
    abs_y_diff = math.abs(circ.y - mousey)
    abs_x_diff = math.abs(circ.x - mousex)
    if circ.x < mousex then
      circ.x = circ.x + (abs_x_diff*speed)
    else
      circ.x = circ.x - (abs_x_diff*speed)
    end
    if circ.y < mousey then
      circ.y = circ.y + (abs_y_diff*speed)
    else
      circ.y = circ.y - (abs_y_diff*speed)
    end
  end
end


function love.draw()
    --love.graphics.print('Hello World!', x, y)
    for idx,circ in pairs(circs) do
      love.graphics.setColor(love.math.random(255),
                             love.math.random(255),
                             love.math.random(255))
      love.graphics.circle("line",circ.x,circ.y,20,10)

    end
end