local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveAddedRemovedSignals = require(script.Parent.Parent.Signal.AddedRemovedSignals)

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for every descendant of the instance
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveDescendants(instance: Instance, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(instance:GetDescendants(), instance.DescendantAdded, instance.DescendantRemoving, fn)
end

return ObserveDescendants
