--[=[
    @within Observe
    @type Cleanup () -> ()
    Cleanup function type
]=]

--[=[
    @within Observe
    @type ValueObserverCallback<T> (T) -> ()
    Value observer callback type
]=]

--[=[
    @within Observe
    @type TableObserverCallback<T> (T) -> (Cleanup)
    Table observer callback type
]=]

-- Abstract
local TableObserver = require(script.TableObserver)

-- Value
local ObserveAttribute = require(script.ObserveAttribute)
local ObserveProperty = require(script.ObserveProperty)
local ObserveValue = require(script.ObserveValue)

-- Table
local ObserveTags = require(script.ObserveTags)
local ObserveTagged = require(script.ObserveTagged)
local ObserveChildren = require(script.ObserveChildren)
local ObserveDescendants = require(script.ObserveDescendants)
local ObservePlayers = require(script.ObservePlayers)

--[=[
    @class Observe
]=]
local Observe = {
    -- Abstract
    TableObserver = TableObserver,

    -- Value
    ObserveAttribute = ObserveAttribute,
    ObserveProperty = ObserveProperty,
    ObserveValue = ObserveValue,

    -- Table
    ObserveTags = ObserveTags,
    ObserveTagged = ObserveTagged,
    ObserveChildren = ObserveChildren,
    ObserveDescendants = ObserveDescendants,
    ObservePlayers = ObservePlayers,
}

return Observe