local obj = {}

function obj:interact(other, map)
	Queue({
		val = DialogChoice({
			{text="test1", val=1},
			{text="test2", val=2},
			{text="test3", val=3}
		}),
		next = {
			Dialog("Cool! It works!"),
			Dialog("Is it in order though?")
		}
	})
end

return obj
