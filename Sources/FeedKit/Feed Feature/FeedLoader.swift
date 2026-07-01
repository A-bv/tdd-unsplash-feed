/// Loads a feed of Unsplash images.
///
/// The feature is defined as an abstraction so that callers depend on the
/// behaviour ("give me a feed") rather than a concrete source (network,
/// cache, test double, ...).
public protocol FeedLoader: Sendable {
    func load() async throws -> [UnsplashImage]
}
