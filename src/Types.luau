-- Function Types
export type Cleanup = () -> ()
export type Callback<T...> = (T...) -> ()

export type Handler<T...> = (T...) -> Cleanup?

-- Trait Types
export type Connection<C> = {
    Disconnect: (self: Connection<C>) -> (),
} & C

export type Signal<S, C, T...> = {
    Connect: (self: Signal<S, C, T...>, callback: Callback<T...>) -> Connection<C>,
} & S

export type RBXSignal<T...> = Signal<RBXScriptSignal, RBXScriptConnection, T...>

return nil