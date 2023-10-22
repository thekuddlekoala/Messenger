--* Batu's Future module
--* Idea by ATK
--* Implementation by Batu

local Future = {}
Future.__index = Future

export type Future = typeof(setmetatable({}, Future))

--* Constructs a new 'Future' object
function Future.new() : Future
	return setmetatable({
		_callbacks = {},
	}, Future) :: Future
end

--* Returns the current value of the 'Future' object
function Future:GetValue(): any
	return unpack(self._value) :: any
end

--* Waits for the 'Future' object to 'Complete', then returns the value.
function Future:Wait(): any
	if self._value ~= nil then
		return unpack(self._value) :: any
	end

	while self._value == nil do
		task.wait()
	end
	
	return unpack(self._value) :: any
end

--* Fires the callback with the completed value of the 'Future' object, or adds it to the callback list
function Future:OnComplete(callback: (... any) -> ()): Future
	if self._value ~= nil then
		callback(unpack(self._value))
	else
		table.insert(self._callbacks, callback)
	end

	return self :: Future
end

--* Sets the value of the 'Future' object to the '...' arguements passed in, causing it to 'Complete'
function Future:Complete(...)
	if self._value ~= nil then
		warn("Future cannot be set twice")
		return
	end

	self._value = {...}

	for _, callback in self._callbacks do
		callback(unpack(self._value))
	end
end

--* Destroys the future object
function Future:Destroy()
	table.clear(self._callbacks)
	table.clear(self)
	setmetatable(self, nil)
end

return Future