local Types = require(script.Types)

-- Function Types
export type Cleanup = Types.Cleanup
export type Callback<T> = Types.Callback<T>
export type Handler<T...> = Types.Handler<T...>

-- Trait Types
export type Signal<T...> = Types.Signal<{ [any]: any }, { [any]: any }, T...>
export type RBXSignal<T...> = Types.RBXSignal<T...>

local Signal = require(script.Signal)
local Instance = require(script.Instance)
local Player = require(script.Player)
local Collection = require(script.Collection)
local State = require(script.State)

local Observe = {
    -- Signal Adapters
    ChangedSignal = Signal.ChangedSignal,
    SetClearSignals = Signal.SetClearSignals,
    AddedRemovedSignal = Signal.AddedRemovedSignals,

    -- State Adapters
    Value = State.Value,
    ClearableValue = State.ClearableValue,
    Array = State.Array,
    DistinctArray = State.DistinctArray,
    Set = State.Set,
    Map = State.Map,

    -- Instance Management
    Children = Instance.Children,
    Descendants = Instance.Descendants,
    Property = Instance.Property,
    Attribute = Instance.Attribute,

    -- Player Management
    Players = Player.Players,
    Character = Player.Character,
    PlayerCharacters = Player.PlayerCharacters,

    -- Collection Management
    Tags = Collection.Tags,
    Tagged = Collection.Tagged,
}

return Observe
