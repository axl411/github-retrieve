import Foundation

func resultify<T>(_ block: () throws -> T) -> Result<T, Error> {
    do {
        let value = try block()
        return .success(value)
    } catch {
        return .failure(error)
    }
}
