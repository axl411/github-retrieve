struct File: Decodable {
    let name: String
    let path: String
    let url: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case name, path, url
        case htmlURL = "html_url"
    }
}
