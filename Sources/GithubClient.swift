import Foundation

struct GithubClient {
    private let urlSession = URLSession.shared
    private let configurations: Configurations
    private let logger: Logger

    init(
        configurations: Configurations,
        logger: Logger
    ) {
        self.configurations = configurations
        self.logger = logger
    }

    func downloadContents(for contentLocation: ContentLocation) async throws -> [Content] {
        var request = URLRequest(url: contentLocation.url)
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "Bearer \(configurations.githubToken)",
        ]
        let (data, _) = try await urlSession.data(for: request)
        let decoder = JSONDecoder()
        let singleFileContent = resultify {
            let content = try decoder.decode(Content.self, from: data)
            return [content]
        }
        let fileListContent = resultify {
            try decoder.decode([Content].self, from: data)
        }

        if let contents = (try? singleFileContent.get()) ?? (try? fileListContent.get()) {
            return contents
        }
        else if let response = try? decoder.decode(RemoteResponse.self, from: data),
                response.status != 200
        {
            throw response
        }
        else {
            return []
        }
    }

    func downloadRawContent(for file: File) async throws -> String {
        let contentLocation = try ContentLocation(urlString: file.url)

        var request = URLRequest(url: contentLocation.url)
        request.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3.raw",
            "Authorization": "Bearer \(configurations.githubToken)",
        ]
        let (data, _) = try await urlSession.data(for: request)

        guard let rawContent = String(data: data, encoding: .utf8) else {
            throw .message("Failed to decode raw content for \(file.path)")
        }
        return rawContent
    }
}
