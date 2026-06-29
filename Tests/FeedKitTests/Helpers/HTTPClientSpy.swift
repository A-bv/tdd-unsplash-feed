import Foundation
@testable import FeedKit

/// Test double that records requested URLs and returns a stubbed result,
/// so `RemoteFeedLoader` can be driven without real networking.
final class HTTPClientSpy: HTTPClient {
    private(set) var requestedURLs = [URL]()
    private var stub: Result<(Data, HTTPURLResponse), Error> = .failure(NSError(domain: "unstubbed", code: 0))

    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        requestedURLs.append(url)
        return try stub.get()
    }

    func stub(error: Error) {
        stub = .failure(error)
    }

    func stub(withStatusCode code: Int, data: Data) {
        let response = HTTPURLResponse(
            url: requestedURLs.last ?? URL(string: "https://any-url.com")!,
            statusCode: code,
            httpVersion: nil,
            headerFields: nil)!
        stub = .success((data, response))
    }
}
