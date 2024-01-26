local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Signal<T> = Types.Signal<T>
type TableObserverCallback<T> = Types.TableObserverCallback<T>

--[=[
    @within Observe
    @param valueGetter () -> T -- A function that returns the current value
    @param changedSignal Signal<any> -- A signal that fires when the value changes
    @param callback TableObserverCallback<T> -- A callback to call for the value
    @return Cleanup

    ```lua
    ValueObserver(function()
        return workspace.CurrentCamera
    end, workspace:GetPropertyChangedSignal("CurrentCamera"), function(camera)
        print("Current camera is now", camera)
    end)
    ```
]=]
local function ValueObserver<T>(valueGetter: () -> T, changedSignal: Signal<any>, callback: TableObserverCallback<T>): Cleanup
    callback(valueGetter())

    local connection = changedSignal:Connect(function()
        callback(valueGetter())
    end)

    return function()
        connection:Disconnect()
    end
end

return ValueObserver