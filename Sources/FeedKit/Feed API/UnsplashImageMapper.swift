import Foundation

/// Maps a raw HTTP response from the Unsplash `/photos` endpoint into the
/// domain `[UnsplashImage]`, isolating the API's JSON shape from the rest
/// of the app.
enum UnsplashImageMapper {
    private struct RemoteImage: Decodable {
        let id: String
        let description: String?
        let altDescription: String?
        let urls: URLs
        let user: User

        struct URLs: Decodable { let regular: URL }
        struct User: Decodable { let name: String }

        enum CodingKeys: String, CodingKey {
            case id, description, urls, user
            case altDescription = "alt_description"
        }

        var model: UnsplashImage {
            // Unsplash usually leaves `description` null and carries the
            // human-readable text in `alt_description`; fall back to it.
            UnsplashImage(
                id: id,
                description: description ?? altDescription,
                url: urls.regular,
                authorName: user.name)
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [UnsplashImage] {
        guard response.statusCode == 200,
              let items = try? JSONDecoder().decode([RemoteImage].self, from: data) else {
            throw RemoteFeedLoader.Error.invalidData
        }
        return items.map(\.model)
    }
}
