Map = class("Map", {
	entities = {},
	collisions = {},
	scripts = {},
	map = nil
})

function Map:init(file)
	self.map = sti.new("res/maps/" .. file .. ".lua")
	for _, v in pairs(self.map.objects) do
		if v.type == "Collision" then
			local col = {
				x = v.x,
				y = v.y,
				w = v.width,
				h = v.height,
				type = v.properties.type or "normal"
			}
			table.insert(self.collisions, col)
		elseif v.type == "Event" then
			table.insert(self.entities, Event(v))
		end
	end
	for _, v in pairs(self.entities) do
		if v.script then
			self.scripts[v.script] = dofile("scripts/" .. v.script .. ".lua")
			if self.scripts[v.script][v.funcInit] then
				self.scripts[v.script][v.funcInit](v, self)
			end
		end
	end
end

function Map:draw()
	local px, py = player:getDraw()
	self.map:setDrawRange(-px, -py, lg.getDimensions())
	for i, v in ipairs(self.map.layers) do
		if not v.objects or (v.objects and debug) then
			self.map:drawLayer(v)
		end
		local props = self.map:getLayerProperties(i)
		if props.drawEntities then
			for _, v in pairs(self.entities) do
				lg.push()
				lg.translate(v:getDraw())
				v:draw()
				lg.pop()
			end
		end
	end
end

function Map:update(dt)
	self.map:update(dt)
	for _, v in pairs(self.entities) do
		v:update(dt, self)
	end
end

function Map:isSolid(x, y, x1, y1, w, h)
	x, y = x * TILE, y * TILE
	x1, y1, w, h = x1 or 0, y1 or 0, w or TILE, h or TILE
	x1, y1 = x1 + x, y1 + y
	for _, v in pairs(self.collisions) do
		if Helper.collision(x1, y1, w, h, v.x, v.y, v.w, v.h) then
			return true
		end
	end
	x, y = x / TILE, y / TILE
	for _, v in pairs(self.entities) do
		if v.x == x and v.y == y then
			return true
		end
	end
	return false
end

function Map:interact(x, y, other)
	for _, v in pairs(self.entities) do
		if v.x == x and v.y == y then
			v:interact(other, self)
		end
	end
end

function Map:movedTo(oldX, oldY, other)
	for _, v in pairs(self.entities) do
		if v.x == other.x and v.y == other.y then
			v:touch(other, self)
		end
	end
end

function Map:getEventsAt(x, y)
	local tbl = {}
	for _, v in pairs(self.entities) do
		if v.x == x and v.y == y then
			table.insert(tbl, v)
		end
	end
	return tbl
end
