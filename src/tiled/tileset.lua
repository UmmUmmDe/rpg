Tileset = class("Tileset", {
	count = 0,
	col = 0,
	src = nil,
	width = 0,
	height = 0,
	name = "",
	img = nil,
	quad = nil,
	id = 0
})

function Tileset:init(obj, map)
	self.name = obj["@name"]
	self.count = tonumber(obj["@tilecount"])
	self.col = tonumber(obj["@columns"])
	self.id = tonumber(obj["@firstgid"])
	self.src = obj.image["@source"]:sub(4):reverse():gsub("(%w*)%.", "", 1):reverse() --Get resource name
	self.imgWidth = tonumber(obj.image["@width"])
	self.imgHeight = tonumber(obj.image["@height"])
	self.width = self.imgWidth / TILE
	self.height = self.imgHeight / TILE
	self.quad = lg.newQuad(0, 0, TILE, TILE, self.imgWidth, self.imgHeight)
end

function Tileset:isTile(id)
	return id >= self.id and id < self.count
end

function Tileset:draw(tile)
	tile = tile - self.id + 1
	local x = tile % self.width
	local y = math.floor((tile - x) / self.width)
	x = x - 1
	self.quad:setViewport(x * TILE, y * TILE, TILE, TILE)
	lg.draw(res.res[self.src], self.quad)
end
