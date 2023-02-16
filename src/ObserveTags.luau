local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type ValueObserverCallback<T> = Types.ValueObserverCallback<T>

local TableObserver = require(script.Parent.TableObserver)

--[=[
    @within Observe
    @param callback ValueObserverCallback<T> -- The callback to call for each tag
    @return Cleanup

    ```lua
    ObserveTags(function(tagName)
        print(tagName, "is a tag")

        return function()
            print(tagName, "is no longer a tag")
        end
    end)
    ```
]=]
local function ObserveTags(callback: ValueObserverCallback<string>): Cleanup
    return TableObserver(CollectionService:GetAllTags(), CollectionService.TagAdded, CollectionService.TagRemoved, callback)
end

return ObserveTags