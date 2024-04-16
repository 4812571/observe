## Why `observe`

### Simple

Compared to many other reactive libraries, observe has a relatively small scope and straightforward API usage, allowing you to leverage it in your code with very minimal learning curve.

```lua
-- Make everything with the "Red" tag red.
Observe.Tagged("Red", function(instance)
    instance.Color = Color3.new(1, 0, 0)
end)
```

### Reactive

Roblox is fundamentally built around instances with fixed lifetimes, and the events they emit. Observe complements this structure well by allowing your code to observe properties, and stop observing them when they are no longer relevant.

```lua
-- Start observing the name of workspace.Part
local stopObserving = Observe.Attribute(workspace.Part, "Name" function(name)
    print("The part's name is:", name)
end)

-- Stop the observation after 10 seconds.
task.delay(10, function()
    stopObserving()
end)
```

### Cleaner Cleanup

In many cases, it is desirable to be able to have code happen when a specific observation ends as well. All observers in observe allow a cleanup function to be returned to be ran when the observation ends.

```lua
Observe.Players(function(player)
    print(player.Name, "is in the game!")

    return function()
        print(player.Name, "has left the game!")
    end
end)
```

Additionally, every observer returns a cleanup function, allowing the observer to stop all observations, and stop looking for new ones.

```lua
-- Make every child of the workspace blue
local stopObserving = Observe.Children(workspace, function(part)
    if not part:IsA("BasePart") then
        return
    end

    local previousColor = part.Color
    part.Color = Color3.new(0, 0, 0)

    -- Revert the color back when the part is removed from the observer
    return function()
        part.Color = previousColor
    end
end)

-- Stop the observer, reverting all parts back to their original color
task.delay(10, function()
    stopObserving()
end)
```

### Type-safe

Observe's API is 100% statically typed using luau's type system.

## Installation

Add the latest installation of observe to your `wally.toml`:

```console
iter = "4812571/iter@0.2.5
```