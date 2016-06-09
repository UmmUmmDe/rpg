Queue = {
	list = {}
}
setmetatable(Queue, Queue)

function Queue.__call(self, ...)
	Queue.add(...)
end

function Queue.add(...)
	for i, v in ipairs({...}) do
		table.insert(Queue.list, v)
	end
end

function Queue.insert(...)
	local l = 1
	if #Queue.list > 0 then
		l = 2
	end
	for i, v in ipairs({...}) do
		table.insert(Queue.list, l, v)
	end
end

function Queue.interact(...)
	local d = Queue.list[1]
	local od = d
	if d then
		if type(d) == "table" and d.val then
			d = d.val
		end
		if type(d) == "table" then
			if od.next then
				if type(od.next) == "table" then
					Queue.insert(unpack(Helper.reverse(od.next)))
				elseif type(od.next) == "function" then
					od.next(...)
				end
			end
		elseif type(d) == "function" then
			d(...)
		end
		table.remove(Queue.list, 1)
	end
end

function Queue.draw()
	local d = Queue.list[1]
	local od = d
	if d then
		if type(d) == "table" and d.val then
			d = d.val
		end
		if type(d) == "table" then
			if d.draw then
				d:draw()
				return true
			end
		end
	end
	return false
end

function Queue.update(dt)
	local d = Queue.list[1]
	local od = d
	if d then
		if type(d) == "table" and d.val then
			d = d.val
		end
		if type(d) == "table" then
			if d.update then
				d:update(dt)
				return true
			end
		else
			Queue.interact()
		end
	end
	return false
end
