local Players = game:GetService("Players")

local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveAddedRemovedSignals = require(script.Parent.Parent.Signal.AddedRemovedSignals)

--[=[
    @within Observe
    @return Cleanup

    Observe all players in the game.
]=]
local function ObservePlayers(fn: Handler<Player>): Cleanup
    return ObserveAddedRemovedSignals(Players:GetPlayers(), Players.PlayerAdded, Players.PlayerRemoving, fn)
end

return ObservePlayers
