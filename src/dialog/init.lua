rich = require("src.richtext")
require("src.dialog.dialogposition")
require("src.dialog.queue")

macros = {}

DialogBase = class("DialogBase", {})

function DialogBase:init()
end

function DialogBase:update(dt)
	if isDown("interact") and just("interact") then
		self:interact()
	end
end

function DialogBase:draw()
end

function DialogBase:interact()
	Queue.interact(self)
end

require("src.dialog.dialog")
require("src.dialog.dialogchoice")
