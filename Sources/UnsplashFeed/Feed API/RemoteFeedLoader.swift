import Foundation

/// Loads the Unsplash feed over HTTP.
public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() async throws -> [UnsplashImage] {
        do {
            _ = try await client.get(from: url)
        } catch {
            throw Error.connectivity
        }
        return []
    }
}
