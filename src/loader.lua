local toLoad = require("config.load")
local len = 0
for k, v in pairs(toLoad) do
	len = len + 1
end
local done = 0
local current = nil
local currentKey = nil

res = {
	res = {}
}

local thread = lt.newThread([[
local lt = love.thread
local c = lt.getChannel("resourceLoaderSend")
local c2 = lt.getChannel("resourceLoaderStop")
local c3 = lt.getChannel("resourceLoaderResponse")
while not c2:pop() do
	local file = c:demand()
	local f, e = io.open("res/" .. file)
	if f then
		local contents
		local ext = file:reverse():match("(%w*)%."):reverse()
		local mode = "text"
		if ext == "png" then
			mode = "image"
		elseif ext == "ttf" then
			mode = "font"
		end
		if mode ~= "ttf" then
			contents = f:read("*all")
		else
			contents = ""
		end
		f:close()
		c3:push(contents)
		c3:push(mode)
	else
		c3:push(e)
	end
end
]])

local function getNext()
	for k, v in pairs(toLoad) do
		current = v
		currentKey = k
		break
	end
end

function res:startLoading()
	thread:start()
	getNext()
	lt.getChannel("resourceLoaderSend"):push(current)
end

function res:loadUpdate(dt)
	if done ~= len then
		local c = lt.getChannel("resourceLoaderResponse")
		local c2 = lt.getChannel("resourceLoaderSend")
		local val = c:pop()
		if val then
			local mode = c:pop()
			local obj = val
			if mode == "image" then
				obj = lg.newImage(li.newImageData(lf.newFileData(val, current)))
			elseif mode == "font" then
				obj = lg.newFont("res/" .. current, 16)
			end
			done = done + 1
			res.res[currentKey] = obj
			toLoad[currentKey] = nil
			if done ~= len then
				getNext()
				c2:push(current)
			end
		end
	else
		lt.getChannel("resourceLoaderStop"):push(true)
		state = States.OVERWORLD
	end
end

function res:loadDraw()
	local str = "Finished loading!"
	local p = done / len
	if done ~= len then
		str = "Loading file \"res/" .. current .. "\" (" .. (p * 100) .. "%)..."
	end
	lg.setColor(255, 255, 255)
	lg.print(str)
	lg.rectangle("fill", 0, lg.getHeight() - 20, lg.getWidth() * p, 20)
end
