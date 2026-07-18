local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the attribute to observe
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveAttribute<T>(instance: Instance, name: string, fn: Handler<T>): Cleanup
    local cleanup = (fn :: any)(instance:GetAttribute(name) :: T)

    local function onChanged()
        if cleanup then
            cleanup()
        end

        cleanup = (fn :: any)(instance:GetAttribute(name) :: T)
    end

    local connection = instance:GetAttributeChangedSignal(name):Connect(onChanged)

    return function()
        connection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

return ObserveAttribute
