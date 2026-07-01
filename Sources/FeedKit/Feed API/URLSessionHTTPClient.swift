import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// `HTTPClient` backed by `URLSession`. This is the only place in the
/// package that talks to the real network.
public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession

    private struct UnexpectedValuesRepresentation: Error {}

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UnexpectedValuesRepresentation()
        }
        return (data, httpResponse)
    }
}
