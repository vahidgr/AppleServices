/// An Apple app or service and its documented developer integration surfaces.
public struct AppleService: Hashable, Sendable {
    public let name: String
    public let summary: String
    public let apis: [AppleAPI]

    public init(name: String, summary: String, apis: [AppleAPI]) {
        self.name = name
        self.summary = summary
        self.apis = apis
    }
}
