-- Function Types
export type Cleanup = () -> ()
export type Callback<T...> = (T...) -> ()
export type Handler<T...> = (T...) -> Cleanup?

-- Trait Types
export type Connection = {
    Disconnect: (self: Connection) -> ()
}

export type Signal<T...> = {
    Connect: (self: Signal<T...>, callback: Callback<T...>) -> Connection | RBXScriptConnection,
}

return nil