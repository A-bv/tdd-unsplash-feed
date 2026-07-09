import Foundation

/// Loads the Unsplash feed over HTTP.
public final class RemoteFeedLoader: FeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    private struct RemoteImage: Decodable {
        let id: String
        let description: String?
        let urls: URLs
        let user: User

        struct URLs: Decodable { let regular: URL }
        struct User: Decodable { let name: String }

        var model: UnsplashImage {
            UnsplashImage(id: id, description: description, url: urls.regular, authorName: user.name)
        }
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load() async throws -> [UnsplashImage] {
        let data: Data
        let response: HTTPURLResponse
        do {
            (data, response) = try await client.get(from: url)
        } catch {
            throw Error.connectivity
        }

        guard response.statusCode == 200,
              let items = try? JSONDecoder().decode([RemoteImage].self, from: data) else {
            throw Error.invalidData
        }
        return items.map(\.model)
    }
}
