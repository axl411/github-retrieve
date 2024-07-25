enum Content: Decodable {
    case directory(Directory)
    case file(File)

    enum CodingKeys: String, CodingKey {
        case name, path, url, type
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let type = try container.decode(ContentType.self, forKey: .type)
        switch type {
        case .file:
            self = .file(try File(from: decoder))

        case .dir:
            self = .directory(try Directory(from: decoder))
        }
    }
}
