import Foundation

final class Retriever {
    private let githubClient: GithubClient
    private let logger: Logger
    private let configurations: Configurations

    init(
        githubClient: GithubClient,
        logger: Logger,
        configurations: Configurations
    ) {
        self.githubClient = githubClient
        self.logger = logger
        self.configurations = configurations
    }

    func retrieve(
        repo: String,
        paths: [String]
    ) async throws {
        let locations = try paths.map {
            try ContentLocation(
                path: $0,
                baseURLString: configurations.baseURLString,
                repo: repo
            )
        }
        try await retrieve(locations: locations)
    }

    private func retrieve(locations: [ContentLocation]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for location in locations {
                group.addTask { [self] in
                    let contents = try await githubClient.downloadContents(for: location)
                    try await retrieve(contents: contents)
                }
            }
            try await group.waitForAll()
        }
    }

    private func retrieve(
        contents: [Content]
    ) async throws {
        await withThrowingTaskGroup(of: Void.self) { group in
            for content in contents {
                group.addTask { [self] in
                    switch content {
                    case let .directory(directory):
                        let childContents = try await githubClient.downloadContents(
                            for: try ContentLocation(urlString: directory.url)
                        )
                        try await retrieve(contents: childContents)

                    case let .file(file):
                        if configurations.shouldRetrieveFilePath(file.path) {
                            await logger.logStdout(try await retrieveContent(for: file))
                        }
                    }
                }
            }
        }
    }

    private func retrieveContent(for file: File) async throws -> String {
        """
        ⬇️
        File path: \(file.path)
        File url: \(file.htmlURL)
        File contents:
        ```
        \(try await githubClient.downloadRawContent(for: file))
        ```
        ⬆️
        """
    }
}
