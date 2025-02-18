local Players = game:GetService("Players")

local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>
type RBXSignal<T...> = Types.RBXSignal<T...>

local Signal = require(script.Parent.Signal)
local ObserveSetClearSignals = Signal.SetClearSignals
local ObserveAddedRemovedSignals = Signal.AddedRemovedSignals

--[=[
    @within Observe
    @return Cleanup

    Observe all players in the game.
]=]
local function ObservePlayers(fn: Handler<Player>): Cleanup
    return ObserveAddedRemovedSignals(Players:GetPlayers(), Players.PlayerAdded, Players.PlayerRemoving, fn)
end

--[=[
    @within Observe
    @param player Player
    @return Cleanup

    Observe the character of a given player
]=]
local function ObserveCharacter(player: Player, fn: Handler<Model?>): Cleanup
    return ObserveSetClearSignals(player.Character, player.CharacterAdded :: RBXSignal<Model>, player.CharacterRemoving :: RBXSignal<Model>, fn)
end

--[=[
    @within Observe
    @return Cleanup

    Observe all player character pairs in the game.
]=]
local function ObservePlayerCharacters(fn: Handler<Player, Model?>): Cleanup
    return ObservePlayers(function(player: Player)
        return ObserveCharacter(player, function(character: Model?)
            return fn(player, character)
        end)
    end)
end

local Player = {
    Players = ObservePlayers,
    Character = ObserveCharacter,
    PlayerCharacters = ObservePlayerCharacters,
}

return Player