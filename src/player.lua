require("src.tween")
require("src.event")

Player = Event:extend("Player")

function Player:init(sprite)
	self.sprite = sprite
	self.quad = lg.newQuad(0, 0, 32, 32, 32 * 4, 32 * 4)
	table.insert(map.entities, self)
end

function Player:draw()
	local x, y = 0, 0
	if self.tween then
		x, y = self.tween.dx, self.tween.dy
		local xx, yy = self.tween.x - self.tween.tx, self.tween.y - self.tween.ty
		if xx < 0 then
			x = x - TILE
		elseif xx > 0 then
			x = x + TILE
		end
		if yy < 0 then
			y = y - TILE
		elseif yy > 0 then
			y = y + TILE
		end
	end
	x, y = math.floor(x), math.floor(y)
	if self.sprite then
		lg.draw(res.res[self.sprite], self.quad, x, y)
	else
		lg.rectangle("fill", x, y, TILE, TILE)
	end
end

function Player:update(dt, map)
	self.super.update(self, dt, map)
	if not self.tween then
		local x, y = 0, 0
		if isDown("up") then
			y = y - 1
		end
		if isDown("down") then
			y = y + 1
		end
		if isDown("left") then
			x = x - 1
		end
		if isDown("right") then
			x = x + 1
		end
		if isDown("run") then
			self.speed = 200
		else
			self.speed = 100
		end
		if x ~= 0 or y ~= 0 then
			self:move(x, y, map)
		else
			if isDown("interact") and just("interact") then
				self:interact(map)
			end
		end
	end
end
