import Foundation

struct ContentLocation {
    let url: URL

    init(path: String, baseURLString: String, repo: String) throws {
        let urlString = "\(baseURLString)/repos/\(repo)/contents/\(path)"
        guard let url = URL(string: urlString) else {
            throw .message("Invalid URL: \(urlString)")
        }
        self.url = url
    }

    init(urlString: String) throws {
        guard let url = URL(string: urlString) else {
            throw .message("Invalid URL: \(urlString)")
        }
        self.url = url
    }
}
