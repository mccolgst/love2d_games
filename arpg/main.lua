radian = math.rad(math.pi / 2)

player = {
  x=200,
  y=200,
  attacking=false,
  bursts={}
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

cave = {}
speed = 5

function camera:set()
  love.graphics.push()
  love.graphics.translate(-self.x, -self.y)
end

function camera:shake()
  self:setpos(self.x+7,self.y+7)
end

function camera:unset()
  love.graphics.pop()
end

function camera:setpos(x, y)
  if x > 0 then
    self.x = x
  elseif x <= 0 then
    self.x = 0
  end
  if y > 0 then
    self.y = y
  elseif y <= 0 then
    self.y = 0
  end
end

function camera:mousepos()
  return love.mouse.getX() + self.x,
         love.mouse.getY() + self.y
end

function love.load()
  map = cave:make()
end

function love.update(dt)
  player:update()
end

function love.keyreleased(key)
  if key == "space" then
    cave.map = cave:step()
  end
end

function love.draw()
  -- camera ops
  love.graphics.clear()

  camera:set()
  camera:setpos(player.x-(love.graphics.getWidth()/2),
                player.y-(love.graphics.getHeight()/2))

  cave:draw()
  player:draw()
  camera:unset()

end

function player:update()
  if love.mouse.isDown(1) then
    mouse.x, mouse.y = camera:mousepos()
  end
  if love.mouse.isDown(2) and not player.attacking then
    camera:shake()
    player:attack()
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
  if not cave:is_wall_at_xy(player.x + player.dx,
                            player.y + player.dy) then
    player.x = player.x + player.dx
    player.y = player.y + player.dy
  else
    if not player.attacking then
      player:attack()
    end
  end


  if table.getn(player.bursts) == 0 then
    player.attacking = false
  end

  for idx, burst in ipairs(player.bursts) do
    burst.t = burst.t + 1
    if burst.t > burst.ttl then
      table.remove(player.bursts, idx)
    end
  end
end

function player:draw()
  love.graphics.setColor(255,255,255)
  love.graphics.circle("fill", player.x, player.y, 10)
  love.graphics.setColor(0,0,0)
  love.graphics.circle("fill", player.x, player.y, 9)

  for idx, burst in ipairs(player.bursts) do
    love.graphics.setColor(255,255,255)
    love.graphics.circle('line', burst.x, burst.y, burst.t*3)
    if burst.t<15 then
      love.graphics.circle('line', burst.x, burst.y, burst.t*2)
    end
  end
  love.graphics.setColor(255,255,255)
  love.graphics.print("x:"..player.x.." y:"..player.y,player.x-40,player.y+20)
  love.graphics.setColor(108,18,18)

  if mouse.x and mouse.y then
    love.graphics.circle("fill", mouse.x, mouse.y, 10)
  end

  love.graphics.setColor(0,0,0)

end

function player:attack()
  player.attacking = true
  local burst = {}
  burst.x = self.x
  burst.y = self.y
  burst.ttl = 20
  burst.t = 0
  table.insert(self.bursts, burst)
end

function cave:make()
  self.cell_size = 32
  self.randomized_map = self:random_table(100, 100)
  self.map = self.randomized_map
end

function cave:random_table(width, height)
  local map = {}
  -- width and height are number of cels
  for w=1,width do
    map[w] = {}
    for h=1,height do
      cel = math.random(1,2) == 2
      map[w][h] = cel
    end
  end
  return map
end

function cave:step()
  local new_map = {}
  for idx_row, row in ipairs(self.map) do
    new_map[idx_row] = {}
    for idx_col, col in ipairs(row) do
      local neighbors = self:check_neighbors(idx_row, idx_col, self.map)
      local is_wall = self.map[idx_row][idx_col]
      if (is_wall and neighbors >= 4) or
         (not is_wall and neighbors >= 5) then
        new_map[idx_row][idx_col] = true
      else
        new_map[idx_row][idx_col] = false
      end
    end
  end
  return new_map
end

function cave:check_neighbors(x, y, map)
  local walls = 0
  if x > 1 and x < 99 and y > 1 and y < 99 then
    if map[x-1][y-1] then walls = walls + 1 end
    if map[x][y-1] then walls = walls + 1 end
    if map[x+1][y-1] then walls = walls + 1 end
    if map[x-1][y] then walls = walls + 1 end
    if map[x+1][y] then walls = walls + 1 end
    if map[x-1][y+1] then walls = walls + 1 end
    if map[x][y+1] then walls = walls + 1 end
    if map[x+1][y+1] then walls = walls + 1 end
  end

  return walls
end

function cave:draw()
  for idx_row, row in ipairs(self.map) do
    for idx_col, col in ipairs(row) do
        if self.map[idx_row][idx_col] then
          love.graphics.setColor(131,118,156)
          love.graphics.rectangle('fill',idx_row*self.cell_size, idx_col*self.cell_size,
                                  self.cell_size,self.cell_size)
          love.graphics.setColor(0,0,0)
        end
    end
  end
end

function cave:is_wall_at_xy(x,y)
  row = math.ceil(x/self.cell_size) - 1
  col = math.ceil(y/self.cell_size) - 1
  return self.map[row][col]
end

function check_collision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end