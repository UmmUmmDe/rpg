require("src.helper")

local tweens = {}

Tween = class("Tween", {
	x = 0,
	y = 0,
	tx = 0,
	ty = 0,
	dx = 0,
	dy = 0,
	speed = 1, --Pixels per second
	done = false
})

function Tween:init(x, y, tx, ty, speed)
	self.x = x
	self.y = y
	self.tx = tx
	self.ty = ty
	self.speed = speed
	table.insert(tweens, self)
end

function Tween.update(dt)
	for _, v in pairs(tweens) do
		local dx, dy = v.x > v.tx, v.y > v.ty
		local spd = v.speed * dt
		local x, y = spd, spd
		if v.tx == v.x then
			x = 0
		elseif dx then
			x = -x
		end
		if v.ty == v.y then
			y = 0
		elseif dy then
			y = -y
		end
		v.dx = v.dx + x
		v.dy = v.dy + y
		if math.abs(v.x - v.tx) - math.abs(v.dx) <= 0 and math.abs(v.y - v.ty) - math.abs(v.dy) <= 0 then
			v.dx, v.dy = v.tx - v.x, v.ty - v.y
			table.remove(tweens, Helper.find(tweens, v))
			v.done = true
		end
	end
end
