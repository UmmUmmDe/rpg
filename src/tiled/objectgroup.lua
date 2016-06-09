ObjectGroup = class("ObjectGroup", {
	name = "",
	objects = {},
	props = {}
})

function ObjectGroup:init(obj, map)
	self.name = obj["@name"]
	for i, v in ipairs(obj:children()) do
		if v:name() == "object" then
			if v["@type"] == "Collision" then
				local col = {
					id = tonumber(v["@id"]), --Will this ever come in handy?
					x = tonumber(v["@x"]),
					y = tonumber(v["@y"]),
					w = tonumber(v["@width"]),
					h = tonumber(v["@height"])
				}
				if v.properties then
					col.props = Helper.loadProperties(v.properties)
					col.type = col.props.type
				end
				table.insert(map.collisions, col)
			elseif v["@type"] == "Event" then
				table.insert(map.entities, Event(v, map))
			end
		elseif v:name() == "properties" then
			self.props = Helper.loadProperties(v)
		end
	end
end
