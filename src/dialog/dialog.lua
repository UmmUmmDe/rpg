Dialog = DialogBase:extend("Dialog", {
	text = "",
	display = "",
	rate = 0.02,
	counter = 0,
	position = DialogPosition.BOTTOM
})

function Dialog:init(text, rate, position)
	self.super.init(self)
	self.text = text
	self.rate = rate or self.rate
	self.position = position or self.position
end

function Dialog:draw()
	self.super.draw(self)
	local x, y, w, h = 0, 0, lg.getWidth(), 100
	if self.position == DialogPosition.TOP then
		--nothing changes
	elseif self.position == DialogPosition.BOTTOM then
		y = lg.getHeight() - h
	else
		if type(self.position) ~= "table" then
			error("Unsupported dialog position \"" .. self.position .. ".\"")
		end
		x, y, w, h = self.position.x, self.position.y, self.position.w, self.position.h
	end
	lg.push()
	lg.translate(x, y)
	lg.setScissor(x, y, w, h)
	lg.setColor(255, 255, 255)
	lg.rectangle("fill", 0, 0, w, h)
	if self.obj then
		lg.setColor(0, 0, 0)
		self.obj:draw(5, 5)
	end
	lg.setScissor()
	lg.pop()
end

function Dialog:update(dt)
	self.super.update(self, dt)
	if self.display ~= self.text then
		self.counter = self.counter + dt
		local c = 0
		while self.counter >= self.rate and self.display ~= self.text do
			self.counter = self.counter - self.rate
			c = c + 1
		end
		if c > 0 then
			self.display = self.text:sub(1, self.display:len() + c)
			self.obj = rich:new({self.display, lg.getWidth() - 10, macros})
		end
	end
end

function Dialog:interact()
	if self.display ~= self.text then
		self.display = self.text
		self.obj = rich:new({self.display, lg.getWidth() - 10, macros})
	end
	self.super.interact(self)
end
