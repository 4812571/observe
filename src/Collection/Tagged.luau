local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveAddedRemovedSignals = require(script.Parent.Parent.Signal.AddedRemovedSignals)

--[=[
    Observes all of the instances that have the given tag
]=]
local function ObserveTagged(tag: string, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(CollectionService:GetTagged(tag), CollectionService:GetInstanceAddedSignal(tag), CollectionService:GetInstanceRemovedSignal(tag), fn)
end

return ObserveTagged
