import Foundation

final class Configurations {
    static let githubHostEnv = "GIT_RETRIEVE_GITHUB_HOST"
    static let githubTokenEnv = "GIT_RETRIEVE_GITHUB_TOKEN"

    private let logger: Logger

    let githubHost: String?

    let githubToken: String

    var baseURLString: String {
        "https://\(githubHost.map({ $0 + "/api/v3" }) ?? "api.github.com")"
    }

    let filePostfixesToRetrieve: [String]

    init(
        logger: Logger,
        githubHost: String?,
        githubToken: String?,
        filePostfixesToRetrieve: [String]
    ) throws {
        self.logger = logger

        self.githubHost = githubHost ?? ProcessInfo.processInfo.environment[Self.githubHostEnv]

        guard let token = githubToken ?? ProcessInfo.processInfo.environment[Self.githubTokenEnv] else {
            throw .message("GitHub token not found.")
        }
        self.githubToken = token

        self.filePostfixesToRetrieve = filePostfixesToRetrieve
    }

    func shouldRetrieveFilePath(_ path: String) -> Bool {
        if filePostfixesToRetrieve.isEmpty {
            true
        }
        else {
            filePostfixesToRetrieve.contains(where: path.hasSuffix)
        }
    }
}
