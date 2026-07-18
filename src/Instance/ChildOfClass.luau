local Types = require(script.Parent.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param className string -- The class name of the child to observe
    @param fn Handler<Instance> -- Called for the first child of the instance with the given class
    @return Cleanup -- A function that will end the observation

    Note: If there are multiple children of the same class, the first one will be observed.
    -- If it is removed, another one will be chosen using FindFirstChildOfClass.

    Note: This has to run code every time a child is added or removed.
]=]
local function ObserveChildOfClass(instance: Instance, className: string, fn: Handler<Instance>): Cleanup
    local child = instance:FindFirstChildOfClass(className)
    local cleanup = nil

    if child then
        cleanup = (fn :: any)(child)
    end

    local function onChildAdded(added)
        -- If there is already a currently observed child, we don't need to do anything.
        if child then
            return
        end

        -- Only observe children with the matching class.
        if added.ClassName ~= className then
            return
        end

        -- Store the current child, call the associated function, and store the cleanup function.
        child = added
        cleanup = (fn :: any)(added)
    end

    local function onChildRemoved(removed)
        -- If the removed child is not the currently observed child, it can be safely ignored.
        if removed ~= child then
            return
        end

        -- Clear the current child
        child = nil

        -- Handle the previous cleanup
        if cleanup then
            cleanup()
            cleanup = nil
        end

        -- Check if there is another child of the same class
        local foundChild = instance:FindFirstChildOfClass(className)

        -- If there is another child, handle it the same way as if it was added.
        if foundChild then
            child = foundChild
            cleanup = (fn :: any)(foundChild)
        end
    end

    local addedConnection = instance.ChildAdded:Connect(onChildAdded)
    local removedConnection = instance.ChildRemoved:Connect(onChildRemoved)

    return function()
        addedConnection:Disconnect()
        removedConnection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

return ObserveChildOfClass
