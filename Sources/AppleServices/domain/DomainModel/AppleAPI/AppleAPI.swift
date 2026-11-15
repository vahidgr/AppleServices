/// One documented integration surface for an Apple service.
public struct AppleAPI: Hashable, Sendable {
    public let name: String
    public let framework: String
    public let summary: String
    public let availability: String
    public let documentationURL: String

    public init(
        name: String,
        framework: String,
        summary: String,
        availability: String,
        documentationURL: String
    ) {
        self.name = name
        self.framework = framework
        self.summary = summary
        self.availability = availability
        self.documentationURL = documentationURL
    }
}
