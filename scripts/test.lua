local obj = {}

function obj:interact(other, map)
	Queue({
		val = DialogChoice({
			{text="test1", val=1},
			{text="test2", val=2},
			{text="test3", val=3}
		}),
		next = function(d)
			local txt
			local v = d.choice.val
			if v == 1 then
				txt = "You chose the first option!"
			elseif v == 2 then
				txt = "Hello there!"
			else
				txt = "Oh, okay then."
			end
			Queue.insert(Dialog(txt))
		end
	},
	Dialog("Cool! It works!"),
	Dialog("Is it in order though?")
	)
end

return obj
