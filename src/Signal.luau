local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T> = Types.Handler<T>
type Callback<T> = Types.Callback<T>

type Signal<S, C, T...> = Types.Signal<S, C, T...>
type Connection<C> = Types.Connection<C>

local State = require(script.Parent.State)

local ObserveValue = State.Value
local ObserveDistinctArray = State.DistinctArray
local ObserveClearableValue = State.ClearableValue

--[=[
    Observe a signal and call a handler with whatever value the signal passes to it.
]=]
local function ObserveChangedSignal<S, C, T>(value: T, changed: Signal<S, C, T>, fn: Handler<T>): Cleanup
    local cleanup, onChanged = ObserveValue(value, fn)

    local connection = changed:Connect(onChanged)

    return function()
        connection:Disconnect()

        cleanup()
    end
end

--[=[
    Observe a set and clear signal and call a handler with whatever value the set signal passes to it.
    If the clear signal is fired, the handler will be called with nil.
]=]
local function ObserveSetClearSignals<S1, C1, S2, C2, T>(value: T, set: Signal<S1, C1, T>, clear: Signal<S2, C2>, fn: Handler<T?>): Cleanup
    local cleanup, onChanged = ObserveClearableValue(value, fn)

    local function onClear()
        onChanged(nil)
    end

    local setConnection = set:Connect(onChanged)
    local clearConnection = clear:Connect(onClear)

    return function()
        setConnection:Disconnect()
        clearConnection:Disconnect()

        cleanup()
    end
end

--[=[
    Observe an added and removed signal and call a handler any time a distinct value is added.
    The handler will be called with all distinct values that are added.
    When a value is removed, the associated cleanup will be called.
]=]
function ObserveAddedRemovedSignals<S1, C1, S2, C2, T>(values: {T}, added: Signal<S1, C1, T>, removed: Signal<S2, C2, T>, fn: Handler<T>): Cleanup
    local cleanup, onAdded, onRemoved = ObserveDistinctArray(values, fn)

    -- Connect the signals
    local addedConnection = added:Connect(onAdded)
    local removedConnection = removed:Connect(onRemoved)

    return function()
        addedConnection:Disconnect()
        removedConnection:Disconnect()

        cleanup()
    end
end

local Signal = {
    ChangedSignal = ObserveChangedSignal,
    SetClearSignals = ObserveSetClearSignals,
    AddedRemovedSignals = ObserveAddedRemovedSignals,
}

return Signal