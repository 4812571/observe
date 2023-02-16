local Types = require(script.Parent.Types)
local Players = game:GetService("PlayerService")

type Cleanup = Types.Cleanup
type TableObserverCallback<T> = Types.TableObserverCallback<T>

local TableObserver = require(script.Parent.TableObserver)

--[=[
    @within Observe
    @param callback TableObserverCallback<Player> -- The callback to call for each player
    @return Cleanup

    ```lua
    ObservePlayers(function(player)
        print(player.Name, "joined the game")

        return function()
            print(player.Name, "left the game")
        end
    end)
    ```
]=]

local function ObservePlayers(callback: TableObserverCallback<Instance>): Cleanup
    return TableObserver(Players:GetPlayers(), Players.PlayerAdded, Players.PlayerRemoving, callback)
end

return ObservePlayers