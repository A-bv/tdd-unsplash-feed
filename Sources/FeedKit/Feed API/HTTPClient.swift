import Foundation

/// Performs HTTP requests on behalf of the API layer.
///
/// Abstracting the network behind a protocol lets `RemoteFeedLoader` be
/// tested without hitting the real Unsplash servers.
public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
