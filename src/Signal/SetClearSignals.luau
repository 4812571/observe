local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T> = Types.Handler<T>

type Signal<T...> = Types.Signal<T...>

--[=[
    Observe a set and clear signal and call a handler with whatever value the set signal passes to it.
    If the clear signal is fired, the handler will be called with nil.
]=]
local function ObserveSetClearSignals<T>(value: T, set: Signal<T>, clear: Signal<any>, fn: Handler<T?>): Cleanup
    -- Initially call the handler with the current value
    local cleanup = fn(value)

    local function onSet(newValue)
        if cleanup then
            cleanup()
        end

        cleanup = fn(newValue)
    end

    local function onClear()
        if cleanup then
            cleanup()
        end

        cleanup = nil
    end

    local setConnection = set:Connect(onSet)
    local clearConnection = clear:Connect(onClear)

    return function()
        setConnection:Disconnect()
        clearConnection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

return ObserveSetClearSignals
