import Foundation

/// Composition root: assembles the pieces into a ready-to-use `FeedLoader`
/// backed by the live Unsplash API.
///
/// ```swift
/// let loader = UnsplashFeed.makeRemoteFeedLoader(accessKey: "YOUR_UNSPLASH_ACCESS_KEY")
/// let images = try await loader.load()
/// ```
public enum UnsplashFeed {
    public static func makeRemoteFeedLoader(
        accessKey: String,
        page: Int = 1,
        perPage: Int = 10,
        session: URLSession = .shared
    ) -> FeedLoader {
        let url = UnsplashEndpoint.photos(accessKey: accessKey, page: page, perPage: perPage).url
        let client = URLSessionHTTPClient(session: session)
        return RemoteFeedLoader(url: url, client: client)
    }
}
