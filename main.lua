debug = true
canShoot = true
canShootTimerMax = 0.2
canShootTimer = canShootTimerMax

bulletImg = nil

bullets = {}

bulletImg = love.graphics.newImage('assests/bullet.png')

createEnemyTimerMax = 0.4
createEnemyTimer = createEnemyTimerMax
  
-- More images
enemyImg = nil -- Like other images we'll pull this in during out love.load function
  
-- More storage
enemies = {} -- array of current enemies on screen
enemyImg = love.graphics.newImage('assests/enemy.png')
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

isAlive = true
score = 0

function love.load(arg)
  player = {x=200 , y=710 , speed = 350 , img = nil }
  player.img = love.graphics.newImage('assests/plane.png')
  
end


function love.update(dt)
  
  for i, enemy in ipairs(enemies) do
	for j, bullet in ipairs(bullets) do
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			score = score + 1
		end
	end

	if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
	and isAlive then
		table.remove(enemies, i)
		isAlive = false
	end
end
  
  -- Time out how far apart our shots can be
canShootTimer = canShootTimer - (1*dt)
if canShootTimer<0 then
  canShoot = true
end

  for i, bullet in ipairs(bullets) do
    bullet.y = bullet.y -(250*dt)
    if bullet.y < 0 then 
      table.remove(bullets,i)
    end
  end

createEnemyTimer = createEnemyTimer - (1 * dt)
if createEnemyTimer < 0 then
	createEnemyTimer = createEnemyTimerMax

	-- Create an enemy
	randomNumber = math.random(10, love.graphics.getWidth() - 10)
	newEnemy = { x = randomNumber, y = -10, img = enemyImg }
	table.insert(enemies,newEnemy)
end

for i, enemy in ipairs(enemies) do
	enemy.y = enemy.y + (200 * dt)

	if enemy.y > 850 then -- remove enemies when they pass off the screen
		table.remove(enemies, i)
	end
end


  
  if love.keyboard.isDown('space', 'rctrl', 'lctrl') and canShoot then
	-- Create some bullets
	newBullet = { x = player.x + (player.img:getWidth()/2), y = player.y, img = bulletImg }
	table.insert(bullets, newBullet)
	canShoot = false
	canShootTimer = canShootTimerMax
end
  if love.keyboard.isDown('escape') then
    love.event.push('quit')
  end
  
  if love.keyboard.isDown('left' , 'a') then 
    if player.x>0 then 
    player.x = player.x - (player.speed*dt)
    end
  elseif love.keyboard.isDown('right' , 'd') then
    if player.x < (love.graphics.getWidth() - player.img:getWidth())then
    player.x = player.x + (player.speed*dt)
    end
  end
  if not isAlive and love.keyboard.isDown('r') then
	-- remove all our bullets and enemies from screen
	bullets = {}
	enemies = {}

	-- reset timers
	canShootTimer = canShootTimerMax
	createEnemyTimer = createEnemyTimerMax

	-- move player back to default position
	player.x = 50
	player.y = 710

	-- reset our game state
	score = 0
	isAlive = true
end
  
end


function love.draw(dt)
  for i, enemy in ipairs(enemies) do
	love.graphics.draw(enemy.img, enemy.x, enemy.y)
end
  for i, bullet in ipairs(bullets) do
  love.graphics.draw(bullet.img, bullet.x, bullet.y)
end

  
  for i, enemy in ipairs(enemies) do
	for j, bullet in ipairs(bullets) do
		if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), bullet.x, bullet.y, bullet.img:getWidth(), bullet.img:getHeight()) then
			table.remove(bullets, j)
			table.remove(enemies, i)
			score = score + 1
		end
	end

	if CheckCollision(enemy.x, enemy.y, enemy.img:getWidth(), enemy.img:getHeight(), player.x, player.y, player.img:getWidth(), player.img:getHeight()) 
	and isAlive then
		table.remove(enemies, i)
		isAlive = false
	end
 
end
if isAlive then
	love.graphics.draw(player.img, player.x, player.y)
else
	love.graphics.print("Press 'R' to restart", love.graphics:getWidth()/2-50, love.graphics:getHeight()/2-10)
end

end