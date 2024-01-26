export type Cleanup = () -> ()
export type Handler<T> = (value: T) -> Cleanup?

return nil