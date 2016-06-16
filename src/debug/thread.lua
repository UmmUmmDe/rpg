local channel = love.thread.getChannel("debug")

while true do
	local input = io.read()
	channel:push(input)
end
