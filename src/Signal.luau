local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T> = Types.Handler<T>
type Callback<T> = Types.Callback<T>

type Signal<T...> = Types.Signal<T...>
type Connection = Types.Connection

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

        cleanup = fn(nil)
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

--[=[
    Observe an added and removed signal and call a handler any time a value is added.
    The handler will be called with all values that are added.
    When a value is removed, the associated cleanup will be called.
]=]
function ObserveAddedRemovedSignals<T>(values: {T}, added: Signal<T>, removed: Signal<T>, fn: Handler<T>): Cleanup
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

local Signal = {
    ChangedSignal = ObserveChangedSignal,
    SetClearSignals = ObserveSetClearSignals,
    AddedRemovedSignals = ObserveAddedRemovedSignals,
}

return Signal