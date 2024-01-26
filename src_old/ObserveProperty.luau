-- currently, luau doesn't support Instance[string], because some strings will cause an error
-- we should be able to specify that the string is a valid property name, but that's not possible yet
-- for now, we'll just disable the type checker
--!nocheck

local Types = require(script.Parent.Types)
type Cleanup = Types.Cleanup
type ValueObserverCallback<T> = Types.ValueObserverCallback<T>

local ValueObserver = require(script.Parent.ValueObserver)

--[=[
    @within Observe
    @param instance Instance -- An instance to observe
    @param propertyName string -- The name of the property to observe
    @param callback ValueObserverCallback<T> -- The callback to call for the property

    ```lua
    ObserveProperty(workspace, "Name", function(value)
        print("Name is now", value)
    end
    ```
]=]
local function ObserveProperty<T>(instance: Instance, propertyName: string, callback: ValueObserverCallback<T>): Cleanup
    return ValueObserver(function()
        return instance[propertyName]
    end, instance:GetPropertyChangedSignal(propertyName), callback)
end

return ObserveProperty