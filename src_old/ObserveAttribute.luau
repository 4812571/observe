local Types = require(script.Parent.Types)
type Cleanup = Types.Cleanup
type ValueObserverCallback<T> = Types.ValueObserverCallback<T>

local ValueObserver = require(script.Parent.ValueObserver)

--[=[
    @within Observe
    @param instance -- An instance to observe
    @param attributeName -- The name of the attribute to observe
    @param callback ValueObserverCallback<T> -- The callback to call for the attribute
    @return Cleanup

    ```lua
    ObserveAttribute(workspace, "Attribute", function(value)
        print("Attribute is now", value)
    end
    ```
]=]
local function ObserveAttribute<T>(instance: Instance, attributeName: string, callback: ValueObserverCallback<T>): Cleanup
    return ValueObserver(function()
        return instance:GetAttribute(attributeName)
    end, instance:GetAttributeChangedSignal(attributeName), callback)
end

return ObserveAttribute