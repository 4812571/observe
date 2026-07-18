local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObservePlayers = require(script.Parent.Players)
local ObserveCharacter = require(script.Parent.Character)

--[=[
    @within Observe
    @return Cleanup

    Observe all player character pairs in the game.
]=]
local function ObservePlayerCharacters(fn: Handler<Player, Model>): Cleanup
    return ObservePlayers(function(player: Player)
        return ObserveCharacter(player, function(character: Model)
            return (fn :: any)(player, character)
        end)
    end)
end

return ObservePlayerCharacters
