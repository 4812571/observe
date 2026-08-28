local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveSetClearSignals = require(script.Parent.Parent.Signal.SetClearSignals)

--[=[
    @within Observe
    @param player Player
    @return Cleanup

    Observe the character of a given player
]=]
local function ObserveCharacter(player: Player, fn: Handler<Model?>): Cleanup
    return ObserveSetClearSignals(player.Character, player.CharacterAdded, player.CharacterRemoving, fn)
end

return ObserveCharacter
