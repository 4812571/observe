local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type TableObserverCallback<T> = Types.TableObserverCallback<T>

local TableObserver = require(script.Parent.TableObserver)

--[=[
    @within Observe
    @param instance Instance -- An instance to observe
    @param callback TableObserverCallback<Instance> -- The callback to call for each child
    @return Cleanup

    ```lua
    ObserveChildren(workspace, function(child)
        print(child.Name, "is a child of workspace")

        return function()
            print(child.Name, "is no longer a child of workspace")
        end
    end)
    ```
]=]
local function ObserveChildren(instance: Instance, callback: TableObserverCallback<Instance>): Cleanup
    return TableObserver(instance:GetChildren(), instance.ChildAdded, instance.ChildRemoved, callback)
end

return ObserveChildren