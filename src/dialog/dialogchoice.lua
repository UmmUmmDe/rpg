DialogChoice = DialogBase:extend("DialogChoice", {
	choices = {},
	choice = nil,
	selected = 1
})

function DialogChoice:init(choices)
	self.choices = choices
end

function DialogChoice:draw()
	self.super.draw(self)
	local x, y, w, h = 0, 0, 200, 0
	local fh = res.res.font:getHeight()
	h = 5 + (5 + fh) * #self.choices
	lg.push()
	lg.setScissor(x, y, w, h)
	lg.translate(x, y)
	lg.setColor(255, 255, 255)
	lg.rectangle("fill", 0, 0, w, h)
	lg.setColor(0, 0, 0)
	for i, v in ipairs(self.choices) do
		local text = v.text
		if self.selected == i then
			text = "▶ " .. text
		else
			text = "  " .. text
		end
		lg.print(text, 20, 5 + (5 + fh) * (i - 1))
	end
	lg.setScissor()
	lg.pop()
end

function DialogChoice:update(dt)
	self.super.update(self, dt)
	if isDown("up") and just("up") then
		self.selected = self.selected - 1
		if self.selected < 1 then
			self.selected = #self.choices
		end
	elseif isDown("down") and just("down") then
		self.selected = self.selected + 1
		if self.selected > #self.choices then
			self.selected = 1
		end
	end
end

function DialogChoice:interact()
	self.choice = self.choices[self.selected]
	self.super.interact(self)
end
