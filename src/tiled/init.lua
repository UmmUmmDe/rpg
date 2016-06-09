XML = require("src.xml")
local xml = XML.newParser()
require("src.tiled.defaults")
require("src.tiled.tileset")
require("src.tiled.layer")
require("src.tiled.objectgroup")

TILE = 16

Map = class("Map", {
	file = nil,
	obj = nil,
	width = 0,
	height = 0,
	tilesets = {},
	layers = {},
	entities = {},
	collisions = {},
	scripts = {}
})

function Map:init(filename)
	self.file = filename
	local f, err = io.open("res/maps/" .. filename .. ".tmx")
	if f then
		local content = f:read("*a")
		f:close()
		self.xml = xml:ParseXmlText(content)
		local obj = self.xml.map
		self.width, self.height = tonumber(obj["@width"]), tonumber(obj["@height"])
		for i, v in ipairs(obj:children()) do
			local k = v:name()
			if k == "tileset" then
				table.insert(self.tilesets, Tileset(v, self))
			elseif k == "layer" then
				table.insert(self.layers, Layer(v, self))
			elseif k == "objectgroup" then
				table.insert(self.layers, ObjectGroup(v, self))
			end
		end
		self.obj = obj
		for _, v in pairs(self.entities) do
			if v.props.script and not self.scripts[v.props.script] then
				self.scripts[v.props.script] = dofile("scripts/" .. v.props.script .. ".lua")
				if self.scripts[v.props.script][v.props.funcInit] then
					self.scripts[v.props.script][v.props.funcInit](v, self)
				end
			end
		end
	else
		error(err)
	end
end

function Map:draw()
	for i, v in ipairs(self.layers) do
		lg.push()
		if v.class == Layer then
			v:draw(self)
		end
		if v.props.drawEntities then
			for _, v in pairs(self.entities) do
				lg.push()
				lg.translate(v.x * TILE, v.y * TILE)
				v:draw()
				lg.pop()
			end
		end
		lg.pop()
	end
end

function Map:update(dt)
	for _, v in pairs(self.entities) do
		v:update(dt, self)
	end
end

function Map:getTileset(id)
	if id == 0 then
		return
	end
	for _, v in pairs(self.tilesets) do
		if v:isTile(id) then
			return v
		end
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
