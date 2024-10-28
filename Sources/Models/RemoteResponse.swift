struct RemoteResponse: Codable, Error {
    let message: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case message
        case status
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decode(String.self, forKey: .message)
        let statusString = try container.decode(String.self, forKey: .status)
        status = Int(statusString) ?? 0
    }
}
