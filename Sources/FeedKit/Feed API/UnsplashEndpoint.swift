import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Builds URLs for the Unsplash REST API.
///
/// Authentication uses the `client_id` query parameter, which Unsplash
/// accepts for public (read-only) endpoints. This keeps the `HTTPClient`
/// free of any auth concerns.
public enum UnsplashEndpoint {
    case photos(accessKey: String, page: Int = 1, perPage: Int = 10)

    private static let baseURL = URL(string: "https://api.unsplash.com")!

    public var url: URL {
        switch self {
        case let .photos(accessKey, page, perPage):
            var components = URLComponents(
                url: Self.baseURL.appendingPathComponent("photos"),
                resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "client_id", value: accessKey),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
            return components.url!
        }
    }
}
