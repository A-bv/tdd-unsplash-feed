import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Performs HTTP requests on behalf of the API layer.
///
/// Abstracting the network behind a protocol lets `RemoteFeedLoader` be
/// tested without hitting the real Unsplash servers, and lets the concrete
/// networking technology (URLSession today, something else tomorrow) change
/// without touching the loader.
public protocol HTTPClient: Sendable {
    /// Returns the response body and the HTTP response, or throws on
    /// connectivity failure.
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
