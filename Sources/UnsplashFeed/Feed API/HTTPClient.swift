import Foundation

/// Performs HTTP requests on behalf of the API layer.
public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
