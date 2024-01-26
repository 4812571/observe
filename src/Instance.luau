local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>

local Signal = require(script.Parent.Signal)
local ObserveAddedRemovedSignals = Signal.AddedRemovedSignals

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for the named child of the instance
    @return Cleanup -- A function that will end the observation

    Note: If there are multiple children with the same name, the first one will be observed. 
    -- If it is removed, another one will be chosen using FindFirstChild.

    Note: This has to run code every time a child is added or removed.
]=]
local function ObserveChild(instance: Instance, name: string, fn: Handler<Instance>): Cleanup
    local child = instance:FindFirstChild(name)
    local cleanup = nil

    if child then
        fn(child)
    end

    local function onChildAdded(added)
        -- If there is already a currently observed child, we don't need to do anything.
        if child then
            return
        end

        -- Store the current child, call the associated function, and store the cleanup function.
        child = added
        cleanup = fn(added)
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

        -- Check if there is another child with the same name
        local foundChild = instance:FindFirstChild(name)

        -- If there is another child, handle it the same way as if it was added.
        if foundChild then
            child = foundChild
            cleanup = fn(foundChild)
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

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for every child of the instance
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveChildren(instance: Instance, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(instance:GetChildren(), instance.ChildAdded, instance.ChildRemoved, fn)
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for every descendant of the instance
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveDescendants(instance: Instance, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(instance:GetDescendants(), instance.DescendantAdded, instance.DescendantRemoving, fn)
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the property to observe
    @return Cleanup -- A function that will end the observation

    Note: If the property is not a valid property of the instance, this will throw an error.
]=]
local function ObserveProperty<T>(instance: Instance, name: string, fn: Handler<T>): Cleanup
    local cleanup = fn(instance[name] :: T)

    local function onChanged()
        if cleanup then
            cleanup()
        end

        cleanup = fn(instance[name] :: T)
    end

    local connection = instance:GetPropertyChangedSignal(name):Connect(onChanged)

    return function()
        connection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the attribute to observe
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveAttribute<T>(instance: Instance, name: string, fn: Handler<T>): Cleanup
    local cleanup = fn(instance:GetAttribute(name) :: T)

    local function onChanged()
        if cleanup then
            cleanup()
        end

        cleanup = fn(instance:GetAttribute(name) :: T)
    end

    local connection = instance:GetAttributeChangedSignal(name):Connect(onChanged)

    return function()
        connection:Disconnect()

        if cleanup then
            cleanup()
        end
    end
end

local Instance = {
    Child = ObserveChild,
    Children = ObserveChildren,
    Descendants = ObserveDescendants,
    Property = ObserveProperty,
    Attribute = ObserveAttribute,
}

return Instance