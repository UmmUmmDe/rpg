Event = class("Event", {
	x = 0,
	y = 0,
	tx = nil,
	ty = nil,
	tween = nil,
	sprite = nil,
	inventory = {},
	party = {},
	quad = nil,
	speed = 100,
	lastDir = false,
	script = nil,
	props = {},
	dir = "d"
})

function Event:init(obj, map)
	self.x, self.y = math.floor(tonumber(obj["@x"]) / TILE), math.floor(tonumber(obj["@y"]) / TILE)
	if obj.properties then
		self.props = Helper.loadProperties(obj.properties)
	end
	local def = MapDefaults.Event
	self.sprite = self.props.sprite or def.sprite
	self.script = self.props.script or def.script
	self.funcInit = self.props.funcInit or def.funcInit
	self.funcUpdate = self.props.funcUpdate or def.funcUpdate
	self.funcInteract = self.props.funcInteract or def.funcInteract
	self.funcTouch = self.props.funcTouch or def.funcTouch
	self.solid = self.props.solid or def.solid
end

function Event:draw()
end

function Event:update(dt, map)
	if self.tween and self.tween.done then
		self.tween = nil
	end
	if self.script then
		if map.scripts[self.script][self.funcUpdate] then
			map.scripts[self.script][self.funcUpdate](self, map, dt)
		end
	end
end

function Event:touch(other, map)
	if self.script then
		if map.scripts[self.script][self.funcTouch] then
			map.scripts[self.script][self.funcTouch](self, map, other)
		end
	end
end

function Event:interact(other, map)
	if map then
		if self.script then
			if map.scripts[self.script][self.funcInteract] then
				map.scripts[self.script][self.funcInteract](self, map, other)
			end
		end
	else
		local map = other
		local x, y = self:getDirAsNum(self.x, self.y)
		for _, v in pairs(map:getEventsAt(x, y)) do
			v:interact(self, map)
		end
	end
end

function Event:move(x, y, map)
	if x ~= 0 or y ~= 0 then
		if x ~= 0 and y ~= 0 then
			if lastDir then
				x = 0
			else
				y = 0
			end
		end
		if x < 0 then
			self.dir = "l"
		elseif x > 0 then
			self.dir = "r"
		elseif y < 0 then
			self.dir = "u"
		elseif y > 0 then
			self.dir = "d"
		end
		lastDir = x ~= 0
		local w, h = TILE * math.abs(y) / 2, TILE * math.abs(x) / 2
		local x1, y1 = (TILE - w) / 2 - x, (TILE - h) / 2 - y
		if not map:isSolid(self.x + x, self.y + y, x1, y1, w, h) then
			self.tween = Tween(self.x * TILE, self.y * TILE, self.x * TILE + x * TILE, self.y * TILE + y * TILE, self.speed)
			self.x = self.x + x
			self.y = self.y + y
		end
	end
end

function Event:getDirAsNum(x, y)
	x, y = x or 0, y or 0
	if self.dir == "d" then
		y = y + 1
	elseif self.dir == "u" then
		y = y - 1
	elseif self.dir == "l" then
		x = x - 1
	elseif self.dir == "r" then
		x = x + 1
	end
	return x, y
end
