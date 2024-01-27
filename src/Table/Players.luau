local Players = game:GetService("Players")

local Types = require(script.Parent.Parent.Types)

local Set = require(script.Parent.Set)

local function ObservePlayers(callback: Types.Handler<Player>)
    local add, remove, clear = Set(callback)

    for _, player in Players:GetPlayers() do
        add(player)
    end

    local function onPlayerAdded(player: Player)
        add(player)
    end

    local function onPlayerRemoving(player: Player)
        remove(player)
    end
    
    local addedConnection = Players.PlayerAdded:Connect(onPlayerAdded)
    local removingConnection = Players.PlayerRemoving:Connect(onPlayerRemoving)

    return function()
        addedConnection:Disconnect()
        removingConnection:Disconnect()
        clear()
    end
end

return ObservePlayers