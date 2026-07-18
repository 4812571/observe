local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local ObserveAddedRemovedSignals = require(script.Parent.Parent.Signal.AddedRemovedSignals)

--[=[
    @within Observe
    @param team Team -- The team to observe
    @param fn Handler<Player> -- Called for every player on the team
    @return Cleanup -- A function that will end the observation

    Observe all players on a team.
]=]
local function ObserveTeamPlayers(team: Team, fn: Handler<Player>): Cleanup
    return ObserveAddedRemovedSignals(team:GetPlayers(), team.PlayerAdded, team.PlayerRemoved, fn)
end

return ObserveTeamPlayers
