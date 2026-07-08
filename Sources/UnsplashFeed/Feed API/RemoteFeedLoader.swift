import Foundation

/// Loads the Unsplash feed over HTTP.
public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() async throws -> [UnsplashImage] {
        let response: HTTPURLResponse
        do {
            (_, response) = try await client.get(from: url)
        } catch {
            throw Error.connectivity
        }

        guard response.statusCode == 200 else {
            throw Error.invalidData
        }
        return []
    }
}
