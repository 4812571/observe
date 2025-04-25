local Types = require(script.Parent.Types)

type Cleanup = Types.Cleanup
type Handler<T...> = Types.Handler<T...>
type Signal<S, C, T...> = Types.Signal<S, C, T...>
type RBXSignal<T...> = Types.RBXSignal<T...>

local Signal = require(script.Parent.Signal)
local ObserveAddedRemovedSignals = Signal.AddedRemovedSignals

local State = require(script.Parent.State)
local ObserveValue = State.Value
local ObserveClearableValue = State.ClearableValue

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

    local cleanup, onChild = ObserveClearableValue(child, fn)

    local function onChildAdded(added: Instance)
        -- If there is already a currently observed child, we don't need to do anything.
        if child then
            return
        end

        -- Store the current child and update the clearable value.
        child = added
        onChild(child)
    end

    local function onChildRemoved(removed: Instance)
        -- If the removed child is not the currently observed child, it can be safely ignored.
        if removed ~= child then
            return
        end

        -- Look for another child with the same name and update the clearable value.
        child = instance:FindFirstChild(name)
        onChild(child)
    end

    local addedConnection = instance.ChildAdded:Connect(onChildAdded)
    local removedConnection = instance.ChildRemoved:Connect(onChildRemoved)

    return function()
        addedConnection:Disconnect()
        removedConnection:Disconnect()

        cleanup()
    end
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for every child of the instance
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveChildren(instance: Instance, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(instance:GetChildren(), instance.ChildAdded :: RBXSignal<Instance>, instance.ChildRemoved :: RBXSignal<Instance>, fn)
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param fn Handler<Instance> -- Called for every descendant of the instance
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveDescendants(instance: Instance, fn: Handler<Instance>): Cleanup
    return ObserveAddedRemovedSignals(instance:GetDescendants(), instance.DescendantAdded :: RBXSignal<Instance>, instance.DescendantRemoving :: RBXSignal<Instance>, fn)
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the property to observe
    @return Cleanup -- A function that will end the observation

    Note: If the property is not a valid property of the instance, this will throw an error.
]=]
local function ObserveProperty<T>(instance: Instance, name: string, fn: Handler<T>): Cleanup
    local cleanup, onChanged = ObserveValue((instance :: any)[name] :: T, fn)

    local connection = instance:GetPropertyChangedSignal(name):Connect(function()
        onChanged((instance :: any)[name] :: T)
    end)

    return function()
        connection:Disconnect()

        cleanup()
    end
end

--[=[
    @within Observe
    @param instance Instance -- The instance to observe
    @param name string -- The name of the attribute to observe
    @return Cleanup -- A function that will end the observation
]=]
local function ObserveAttribute<T>(instance: Instance, name: string, fn: Handler<T>): Cleanup
    local cleanup, onChanged = ObserveValue(instance:GetAttribute(name) :: T, fn)

    local connection = instance:GetAttributeChangedSignal(name):Connect(function()
        onChanged(instance:GetAttribute(name) :: T)
    end)

    return function()
        connection:Disconnect()

        cleanup()
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