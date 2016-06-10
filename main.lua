_INFO = {
	_VERSION = "Alpha 1.0",
	_AUTHOR = "UmmUmmDe"
}

TILE = 32

la = love.audio
le = love.event
lf = love.filesystem
lft = love.font
lg = love.graphics
li = love.image
lj = love.joystick
lk = love.keyboard
lm = love.math
lmou = love.mouse
ls = love.sound
lsys = love.system
lt = love.thread
ltm = love.timer
ltc = love.touch
lv = love.video
lw = love.window

if lf.exists("scripts/override.lua") then
	require("scripts.override")
	override = true
end

inspect = require("src.inspect")
class = require("src.30log")
States = require("src.states")

Keys = require("config.keys")
local obj = {}
for k, v in pairs(Keys) do
	obj[k] = {
		def = v,
		pressed = false,
		just = false
	}
end
Keys = obj
obj = nil

sti = require("src.sti")
require("src.map")
require("src.loader")
require("src.player")
require("src.dialog")

function love.load(args)
	state = States.LOADING
	map = Map("test")
	player = Player()
	res:startLoading()
	debug = true
end

function love.update(dt)
	for k, v in pairs(Keys) do
		if v.just then
			v.just = false
		end
		local down = false
		for _, key in pairs(v.def) do
			if lk.isDown(key) then
				down = true
				break
			end
		end
		if down ~= v.pressed then
			v.just = true
		end
		v.pressed = down
	end
	if isDown("menu") then
		le.quit() --Temporary
	elseif isDown("debug") and just("debug") then
		debug = not debug
	end
	if Queue.update(dt) then --do nothing
	elseif state == States.LOADING then
		res:loadUpdate(dt)
	elseif state == States.OVERWORLD then
		map:update(dt)
	end
	Tween.update(dt)
end

function love.draw()
	lg.setColor(255, 255, 255)
	if res.res.font then
		lg.setFont(res.res.font)
	end
	if state == States.LOADING then
		res:loadDraw()
	elseif state == States.OVERWORLD then
		lg.push()
		local px, py = player:getDraw()
		lg.translate(-px + (lg.getWidth() - TILE) / 2, -py + (lg.getHeight() - TILE) / 2)
		map:draw()
		lg.pop()
	end
	Queue.draw()
end

function isDown(code)
	return Keys[code].pressed
end

function just(code)
	return Keys[code].just
end

function isUp(code)
	return not isDown(code)
end
