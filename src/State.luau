local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

--[=[
    Observe a changed callback and call a handler with whatever value the changed callback is provided.
]=]
local function ObserveValue<T1, T2>(value: T1, fn: Handler<T1 | T2>): (Cleanup, (T2) -> ())
    local cleanup = fn(value)

    local function onChanged(newValue: T2)
        if cleanup then
            cleanup()
        end

        cleanup = fn(newValue)
    end

    return function()
        if cleanup then
            cleanup()
            cleanup = nil
        end
    end, onChanged
end
--[=[
    Observe a changed callback and call a handler with whatever non-nil value the changed callback is provided.
    When the value is nil or the cleanup callback is called the handler will not be called.
]=]
local function ObserveClearableValue<T1, T2>(value: T1?, fn: Handler<T1 | T2>): (Cleanup, (T2?) -> ())
    return ObserveValue(value, function(newValue: (T1 | T2)?)
        if newValue == nil then
            return
        end

        return fn(newValue)
    end)
end

--[=[
    Observe an added & removed callback and call a handler any time a value is added.
    The handler will be called with all values that are added.
    When a value is removed, the most recent cleanup will be called.
]=]
local function ObserveArray<T>(values: { T }, fn: Handler<T>): (Cleanup, (T) -> (), (T) -> ())
    local cleanupsByValue: { [T]: { Cleanup } } = {}

    local function onAdded(value: T)
        local cleanups = cleanupsByValue[value]

        if not cleanups then
            cleanups = {}
            cleanupsByValue[value] = cleanups
        end

        table.insert(cleanups, fn(value) or function() end)
    end

    local function onRemoved(value: T)
        local cleanups = cleanupsByValue[value]
        local cleanup = cleanups and table.remove(cleanups)

        if cleanup then
            cleanup()
        end

        if not next(cleanups) then
            cleanupsByValue[value] = nil
        end
    end

    -- Initially call the handler with each current value
    for _, value in values do
        onAdded(value)
    end

    return function()
        for _, cleanups in cleanupsByValue do
            for _, cleanup in cleanups do
                cleanup()
            end
        end
        table.clear(cleanupsByValue)
    end, onAdded, onRemoved
end

--[=[
    Observe an added & removed callback and call a handler any time a value is added.
    The handler will be called with all distinct values that are added.
    When a value is removed, the associated cleanup will be called.
]=]
local function ObserveSet<T>(values: { [T]: boolean }, fn: Handler<T>): (Cleanup, (T) -> (), (T) -> ())
    local cleanups: { [T]: Cleanup } = {}

    local function onAdded(value: T)
        if cleanups[value] then
            return
        end

        local cleanup = fn(value)

        if cleanup then
            cleanups[value] = cleanup
        else
            cleanups[value] = nil
        end
    end

    local function onRemoved(value: T)
        local cleanup = cleanups[value]

        if cleanup then
            cleanup()
            cleanups[value] = nil
        end
    end

    -- Initially call the handler with each current value
    for value, _ in values do
        onAdded(value)
    end

    return function()
        for _, cleanup in cleanups do
            cleanup()
        end
        table.clear(cleanups)
    end, onAdded, onRemoved
end

--[=[
    Observe an added & removed callback and call a handler any time a distinct (non-duplicate) value is added.
    The handler will be called with all distinct values that are added.
    When a value is removed, the associated cleanup will be called.
]=]
local function ObserveDistinctArray<T>(values: {T}, fn: Handler<T>): (Cleanup, (T) -> (), (T) -> ())
    -- TODO: Consider converting the input array to a set and using ObserveSet
    local cleanups: { [T]: Cleanup } = {}

    local function onAdded(value: T)
        if cleanups[value] then
            return
        end

        local cleanup = fn(value)

        if cleanup then
            cleanups[value] = cleanup
        else
            cleanups[value] = nil
        end
    end

    local function onRemoved(value: T)
        local cleanup = cleanups[value]

        if cleanup then
            cleanup()
            cleanups[value] = nil
        end
    end

    -- Initially call the handler with each current value
    for _, value in values do
        onAdded(value)
    end

    return function()
        for _, cleanup in cleanups do
            cleanup()
        end
        table.clear(cleanups)
    end, onAdded, onRemoved
end

--[=[
    Observe a changed callback and call a handler with the key value pair.
    The handler will be called with all distinct values in the map.
    When a value is changed, the associated cleanup will be called.
]=]
local function ObserveMap<K, V>(values: { [K]: V }, fn: Handler<K, V>): (Cleanup, (K, V) -> ())
    local cleanups: { [K]: Cleanup } = {}

    local function onChanged(key: K, value: V)
        local cleanup = cleanups[key]

        if cleanup then
            cleanup()
        end

        local newCleanup = fn(key, value)

        if newCleanup then
            cleanups[key] = newCleanup
        else
            cleanups[key] = nil
        end
    end

    -- Initially call the handler with each current value
    for key, value in values do
        onChanged(key, value)
    end

    return function()
        for _, cleanup in cleanups do
            cleanup()
        end
        table.clear(cleanups)
    end, onChanged
end

local State = {
    Value = ObserveValue,
    ClearableValue = ObserveClearableValue,
    Array = ObserveArray,
    DistinctArray = ObserveDistinctArray,
    Set = ObserveSet,
    Map = ObserveMap,
}

return State