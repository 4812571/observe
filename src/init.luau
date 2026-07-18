local Types = require(script.Types)

-- Function Types
export type Cleanup = Types.Cleanup
export type Callback<T> = Types.Callback<T>
export type Handler<T...> = Types.Handler<T...>

-- Trait Types
export type Signal<T> = Types.Signal<T>

local Observe = {
    -- Signal Adapters
    ChangedSignal = require(script.Signal.ChangedSignal),
    SetClearSignals = require(script.Signal.SetClearSignals),
    AddedRemovedSignal = require(script.Signal.AddedRemovedSignals),

    -- Instance Management
    ChildOfClass = require(script.Instance.ChildOfClass),
    ChildWhichIsA = require(script.Instance.ChildWhichIsA),
    Children = require(script.Instance.Children),
    Descendants = require(script.Instance.Descendants),
    Property = require(script.Instance.Property),
    Attribute = require(script.Instance.Attribute),

    -- Player Management
    Players = require(script.Player.Players),
    TeamPlayers = require(script.Player.TeamPlayers),
    Character = require(script.Player.Character),
    PlayerCharacters = require(script.Player.PlayerCharacters),

    -- Collection Management
    Tags = require(script.Collection.Tags),
    Tagged = require(script.Collection.Tagged),
}

return Observe
