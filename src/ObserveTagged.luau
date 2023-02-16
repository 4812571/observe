local CollectionService = game:GetService("CollectionService")

local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type TableObserverCallback<T> = Types.TableObserverCallback<T>

local TableObserver = require(script.Parent.TableObserver)

--[=[
    @within Observe
    @param tagName string -- The tag to observe
    @param callback TableObserverCallback-- The callback to call when the tag is added or removed
    @return Cleanup

    ```lua
    ObserveTagged("Tag", function(instance)
        print(instance.Name, "is tagged with Tag")

        return function()
            print(instance.Name, "is no longer tagged with Tag")
        end
    end)
    ```
]=]
local function ObserveTagged(tagName: string, callback: TableObserverCallback<string>): Cleanup
    return TableObserver(CollectionService:GetTagged(tagName), CollectionService:GetInstanceAddedSignal(tagName), CollectionService:GetInstanceRemovedSignal(tagName), callback)
end

return ObserveTagged