local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the property to observe
    @return Cleanup -- A function that will end the observation

    Note: If the property is not a valid property of the instance, this will throw an error.
]=]
local function ObserveProperty<T>(instance: Instance, name: string, fn: Handler<T?>): Cleanup
    local cleanup = (fn :: any)(instance[name])

    local function onChanged()
        if cleanup then
            cleanup()
        end

        cleanup = (fn :: any)(instance[name])
    end

    local connection = instance:GetPropertyChangedSignal(name):Connect(onChanged)

    return function()
        connection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

return ObserveProperty
