XML = require("src.xml")
local xml = XML.newParser()

MapDefaults = {}

local obj = xml:loadFile("mapping/objecttypes.xml").objecttypes

for _, v in pairs(obj:children()) do
	local o = {}
	for __, p in pairs(v:children()) do
		local d = nil
		local t = p["@type"]
		if t == "string" then
			d = ""
		elseif t == "int" or t == "float" then
			d = 0
		elseif t == "bool" then
			d = "false"
		end
		local val = p["@default"] or d
		if t == "int" or t == "float" then
			val = tonumber(val)
			if t == "int" then
				val = math.floor(val)
			end
		elseif t == "bool" then
			val = val == "true"
		end
		o[p["@name"]] = val
	end
	MapDefaults[v["@name"]] = o
end
