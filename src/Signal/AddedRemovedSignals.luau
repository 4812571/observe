local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T> = Types.Handler<T>

type Signal<T...> = Types.Signal<T...>

--[=[
    Observe an added and removed signal and call a handler any time a value is added.
    The handler will be called with all values that are added.
    When a value is removed, the associated cleanup will be called.
]=]
local function ObserveAddedRemovedSignals<T>(values: {T}, added: Signal<T>, removed: Signal<T>, fn: Handler<T>): Cleanup
    local cleanups = {}

    local function onAdded(value)
        if cleanups[value] then
            return
        end

        cleanups[value] = fn(value)
    end

    local function onRemoved(value)
        local cleanup = cleanups[value]

        if cleanup then
            cleanup()
            cleanups[value] = nil
        end
    end

    -- Initially call the handler with each current value
    for _, value in values do
        cleanups[value] = fn(value)
    end

    -- Connect the signals
    local addedConnection = added:Connect(onAdded)
    local removedConnection = removed:Connect(onRemoved)

    return function()
        addedConnection:Disconnect()
        removedConnection:Disconnect()

        for _, cleanup in cleanups do
            cleanup()
        end
    end
end

return ObserveAddedRemovedSignals
