Layer = class("Layer", {
	name = "",
	encoding = "",
	width = 0,
	height = 0,
	data = nil,
	props = {}
})

function Layer:init(obj, map)
	self.name = obj["@name"]
	self.width = tonumber(obj["@width"])
	self.height = tonumber(obj["@height"])
	self.encoding = obj.data["@encoding"]
	if self.encoding == "csv" then
		local data = obj.data:value():gsub("\n", "")
		self.data = {}
		for y = 1, self.height do
			local tbl = {}
			for x = 1, self.width do
				local str = data:match("(%d*),?")
				if str == "" then
					error("Something weird happened...")
				end
				tbl[x] = tonumber(str)
				data = data:gsub("%d*", "", 1):gsub(",", "", 1)
			end
			self.data[y] = tbl
		end
	else
		error("Unsupported map encoding \"" .. self.encoding .. "\"")
	end
	if obj.properties then
		self.props = Helper.loadProperties(obj.properties)
	end
end

function Layer:draw(map)
	lg.push()
	for y, row in ipairs(self.data) do
		for x, tile in ipairs(row) do
			local set = map:getTileset(tile)
			if set then
				set:draw(tile)
			end
			lg.translate(TILE, 0)
		end
		lg.translate(-self.width * TILE, TILE)
	end
	lg.pop()
end
