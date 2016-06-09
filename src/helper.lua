Helper = {}

function Helper.find(table, obj)
	for i, v in ipairs(table) do
		if v == obj then
			return i
		end
	end
end

function Helper.collision(x1, y1, w1, h1, x2, y2, w2, h2)
	return x1 < x2 + w2 and x2 < x1 + w1 and y1 < y2 + h2 and y2 < y1 + h1
end

function Helper.loadProperties(v)
	local tbl = {}
	for _, p in pairs(v:children()) do
		local val = p["@value"]
		local type = p["@type"]
		if type == "int" or type == "float" then
			val = tonumber(val)
			if type == "int" then
				val = math.floor(val)
			end
		elseif type == "bool" then
			val = val == "true"
		end
		tbl[p["@name"]] = val
	end
	return tbl
end

function Helper.reverse(table)
	local tbl = {}
	for i, v in ipairs(table) do
		tbl[#table - (i - 1)] = v
	end
	return tbl
end
