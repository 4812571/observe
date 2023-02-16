local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Signal<T> = Types.Signal<T>
type Connection = Types.Connection
type TableObserverCallback<T> = Types.TableObserverCallback<T>

--[=[
    @within Observe
    @param tab {[any]: T} -- A table to observe
    @param addedSignal Signal<T> -- A signal that fires when a value is added to the table
    @param removedSignal Signal<any> -- A signal that fires when a value is removed from the table
    @param callback TableObserverCallback<T> -- A callback to call for each value in the table
    @return Cleanup

    ```lua
    TableObserver(workspace:GetChildren(), workspace.ChildAdded, workspace.ChildRemoved, function(child)
        print(child.Name, "is a child of workspace")

        return function()
            print(child.Name, "is no longer a child of workspace")
        end
    end)
    ```
]=]
    
local function TableObserver<T>(tab: {[any]: T}, addedSignal: Signal<T>, removedSignal: Signal<any>, callback: TableObserverCallback<T>): Cleanup
    local removers = {}

    local function add(val)
        removers[val] = callback(val)
    end

    local function remove(val)
        if removers[val] then
            removers[val]()
            removers[val] = nil
        end
    end

    for _, val in tab do
        add(val)
    end

    local addedConnection = addedSignal:Connect(function(val: T) add(val) end)
    local removedConnection = removedSignal:Connect(function(val: T) remove(val) end)

    return function()
        for _, remover in removers do
            remover()
        end

        addedConnection:Disconnect()
        removedConnection:Disconnect()
    end
end

return TableObserver