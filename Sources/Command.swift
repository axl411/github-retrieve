import ArgumentParser

@main
struct Command: AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "github-retrieve",
        abstract: "Retrieve raw contents of files from a GitHub repo and print to stdout."
    )

    @Option(
        help: "Custom GitHub host if running for GitHub Enterprise. Either use this option or provide an environment variable \(Configurations.githubHostEnv). Example value: \"git.mycorp.com\""
    )
    var githubHost: String?

    @Option(
        help: "GitHub access token. Either use this option or provide an environment variable \(Configurations.githubTokenEnv)."
    )
    var githubToken: String?

    @Option(
        help: "Specify the file postfixes to filter what files to retrieve. If not specified, all file types will be retrieved. Note: explicitly specified paths for the command will always be retrieved. Example value: \"--file-postfixes-to-retrieve .swift --file-postfixes-to-retrieve .md --file-postfixes-to-retrieve BUILD\""
    )
    var filePostfixesToRetrieve: [String] = []

    @Argument(help: "The repo to fetch from. Example value: \"axl411/github-retrieve\"")
    var repo: String

    @Argument(
        help: "File or directory paths in the repo"
    )
    var paths: [String]

    func run() async throws {
        let logger = Logger()
        let configurations = try Configurations(
            logger: logger,
            githubHost: githubHost,
            githubToken: githubToken,
            filePostfixesToRetrieve: filePostfixesToRetrieve
        )
        let client = GithubClient(configurations: configurations, logger: logger)
        let retriever = Retriever(
            githubClient: client,
            logger: logger,
            configurations: configurations
        )

        try await retriever.retrieve(repo: repo, paths: paths)
    }
}
