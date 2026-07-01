import Foundation
@testable import FeedKit

/// Test double that records requested URLs and returns a stubbed result,
/// so `RemoteFeedLoader` can be driven without real networking.
final class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()

    private enum Stub {
        case failure(Error)
        case success(data: Data, statusCode: Int)
    }
    private var stub: Stub = .failure(NSError(domain: "unstubbed", code: 0))

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        switch stub {
        case let .failure(error):
            throw error
        case let .success(data, statusCode):
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil)!
            return (data, response)
        }
    }

    func stub(error: Error) {
        stub = .failure(error)
    }

    func stub(withStatusCode code: Int, data: Data) {
        stub = .success(data: data, statusCode: code)
    }
}
