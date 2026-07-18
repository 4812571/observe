local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveAddedRemovedSignals = require(script.Parent.Parent.Signal.AddedRemovedSignals)

--[=[
    Observes all of the tags that have non empty collections.
]=]
local function ObserveTags(fn: Handler<string>): Cleanup
    return ObserveAddedRemovedSignals(CollectionService:GetAllTags(), CollectionService.TagAdded, CollectionService.TagRemoved, fn)
end

return ObserveTags
