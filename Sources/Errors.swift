struct GitHubRetrieveError: Error {
    let message: String
}

extension Error where Self == GitHubRetrieveError {
    static func message(_ message: String) -> Self {
        GitHubRetrieveError(message: message)
    }
}
