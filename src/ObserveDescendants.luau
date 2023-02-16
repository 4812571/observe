local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type TableObserverCallback<T> = Types.TableObserverCallback<T>

local TableObserver = require(script.Parent.TableObserver)

--[=[
    @within Observe
    @param instance Instance -- An instance to observe
    @param callback TableObserverCallback<Instance> -- The callback to call for each descendant
    @return Cleanup

    ```lua
    ObserveDescendants(workspace, function(descendant)
        print(descendant.Name, "is a descendant of workspace")

        return function()
            print(descendant.Name, "is no longer a descendant of workspace")
        end
    end)
    ```
]=]
local function ObserveDescendants(instance: Instance, callback: TableObserverCallback<Instance>): Cleanup
    return TableObserver(instance:GetDescendants(), instance.DescendantAdded, instance.DescendantRemoving, callback)
end

return ObserveDescendants