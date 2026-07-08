/// Loads a feed of Unsplash images. Callers depend on this behaviour,
/// not on a concrete source.
public protocol FeedLoader {
    func load() async throws -> [UnsplashImage]
}
