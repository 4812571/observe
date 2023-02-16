-- General
export type AnyTable = {[any]: any}

-- Connection
type TableConnection = {
    Disconnect: (self: TableConnection) -> (),
}

export type Connection = RBXScriptConnection

-- Signal
type TableSignal<T> = {
    Connect: (self: TableSignal<T>, callback: (val: any) -> ()) -> Connection,
}

export type Signal<T> = RBXScriptSignal<T> & TableSignal<T>

-- Value
export type ValueBaseObject<T> = {
    Value: T,
    Changed: Signal<T>,
}

-- Callbacks
export type Cleanup = () -> ()
export type ValueObserverCallback<T> = (val: T) -> ()
export type TableObserverCallback<T> = (val: T) -> Cleanup?

return true