local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local Messenger = require(Modules.Messenger)

task.desynchronize()

local Actor = script.Parent

Messenger.Initialize(Actor)

Messenger.CallParallel(Actor, function()
	for i = 1, 100 do
		print(`Hello world at index {i}`)
	end
end)

local Result = Messenger.InvokeParallel(Actor, function()
	return "Hello World"
end)

warn(`Returned result was {Result}!`)