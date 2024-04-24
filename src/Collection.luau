local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local Signal = require(script.Parent.Signal)
local ObserveAddedRemovedSignals = Signal.AddedRemovedSignals

--[=[
    Observes all of the tags that have non empty collections.
]=]
local function ObserveTags(fn: Handler<string>): Cleanup
    return ObserveAddedRemovedSignals(CollectionService:GetAllTags(), CollectionService.TagAdded, CollectionService.TagRemoved, fn)
end

--[=[
    Observes all of the instances that have the given tag
]=]
local function ObserveTagged(tag: string, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(CollectionService:GetTagged(tag), CollectionService:GetInstanceAddedSignal(tag), CollectionService:GetInstanceRemovedSignal(tag), fn)
end

local Collection = {
    Tags = ObserveTags,
    Tagged = ObserveTagged,
}

return Collection
