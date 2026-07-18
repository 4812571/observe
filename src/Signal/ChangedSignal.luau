local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T> = Types.Handler<T>

type Signal<T...> = Types.Signal<T...>

--[=[
    Observe a signal and call a handler with whatever value the signal passes to it.
]=]
local function ObserveChangedSignal<T>(value: T, changed: Signal<T>, fn: Handler<T>): Cleanup
    -- Initially call the handler with the current value
    local cleanup = fn(value)

    local function onChanged(newValue)
        if cleanup then
            cleanup()
        end

        cleanup = fn(newValue)
    end

    local connection = changed:Connect(onChanged)

    return function()
        connection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

return ObserveChangedSignal
