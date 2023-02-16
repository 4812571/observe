local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type ValueBaseObject<T> = Types.ValueBaseObject<T>
type ValueObserverCallback<T> = Types.ValueObserverCallback<T>

local ValueObserver = require(script.Parent.ValueObserver)

--[=[
    @within Observe
    @param valueBase ValueBase -- A ValueBase to observe
    @param callback -- The callback to call for the value

    ```lua
    ObserveValue(workspace, function(value)
        print("Value is now", value)
    end
    ```
]=]
local function ObserveValue<T>(valueBase: ValueBaseObject<T>, callback: ValueObserverCallback<T>): Cleanup
    return ValueObserver(function()
        return valueBase.Value
    end, valueBase.Changed, callback)
end

return ObserveValue