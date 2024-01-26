local Types = require(script.Parent.Parent.Types)

type Add<T> = (value: T) -> ()
type Remove<T> = (value: T) -> ()
type Clear = () -> ()

local function Set<T>(callback: Types.Handler<T>): (Add<T>, Remove<T>, Clear)
    local cleanups = {}

    local function add(value: T)
        cleanups[value] = callback(value)
    end

    local function remove(value: T)
        local cleanup = cleanups[value]

        if cleanup then
            cleanup()
        end
    end

    local function clear()
        for value, cleanup in cleanups do
            cleanup()
            cleanups[value] = nil
        end
    end

    return add, remove, clear
end

return Set