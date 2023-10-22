--* Written by batu (.gg @abdul_jalil) on 22/10/23 *--

--* Paths
local Future = require(script.Future)

--* Types
type Future = Future.Future
type Callback = () -> ()

--* Logic
local Messenger = {
	_COUNT = 0,
	_CACHE = {}
}

--* Handles the message callback initialization for the Actor passed in 'actor'
function Messenger.Initialize(actor: Actor)
	actor:BindToMessageParallel("callParallel", function(callback: Callback)
		callback()
	end)

	actor:BindToMessageParallel("invokeParallel", function(callback: Callback, id: string)
		local future: Future = Messenger._CACHE[id]

		assert(future, "FATAL ERROR, 'FUTURE' WAS NOT FOUND")

		local result = callback()

		future:Complete(result or true)
	end)
end

--* Calls the function 'callback' in parallel, using the Actor 'actor'
function Messenger.CallParallel(actor: Actor, callback: Callback)	
	actor:SendMessage("callParallel", callback)
end


--* Invokes the function 'callback' in parallel, using the Actor 'actor', returning a result
function Messenger.InvokeParallel(actor: Actor, callback: Callback): any
	local id = utf8.char(Messenger._COUNT)
	Messenger._COUNT += 1
	
	local future = Future.new()
	
	Messenger._CACHE[id] = future
	
	actor:SendMessage("invokeParallel", callback, id)
	
	local result = future:Wait()
	
	Messenger._CACHE[id] = nil
	future:Destroy()
	
	return result :: any
end

return Messenger