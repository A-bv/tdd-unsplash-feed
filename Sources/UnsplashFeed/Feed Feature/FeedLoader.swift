/// Loads a feed of Unsplash images.
///
/// The feature is defined as an abstraction so that callers depend on the
/// behaviour ("give me a feed") rather than a concrete source.
public protocol FeedLoader {
    func load() async throws -> [UnsplashImage]
}
