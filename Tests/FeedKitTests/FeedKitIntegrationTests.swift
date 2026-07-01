import XCTest
@testable import FeedKit

/// Integration tests for the composition root. These drive the *real*
/// `FeedKit.makeRemoteFeedLoader` — endpoint + URLSession client + loader +
/// mapper wired together — against a `URLProtocol`-stubbed session, so no
/// live network is hit while still exercising the assembled stack.
final class FeedKitIntegrationTests: XCTestCase {

    override func tearDown() {
        URLProtocolStub.reset()
        super.tearDown()
    }

    func test_makeRemoteFeedLoader_deliversMappedImagesThroughFullStack() async throws {
        var observedRequest: URLRequest?
        URLProtocolStub.observeRequests { observedRequest = $0 }
        URLProtocolStub.stub(data: Data(unsplashPhotosJSON.utf8), response: ok(), error: nil)

        let sut = FeedKit.makeRemoteFeedLoader(accessKey: "TEST_KEY", session: URLProtocolStub.makeSession())
        let images = try await sut.load()

        // The mapper produced the domain model from the endpoint's response...
        XCTAssertEqual(images.map(\.id), ["abc"])
        XCTAssertEqual(images.first?.authorName, "Jane Doe")
        XCTAssertEqual(images.first?.description, "a scenic mountain view") // alt_description fallback

        // ...and the request actually routed through UnsplashEndpoint.
        XCTAssertEqual(observedRequest?.url?.host, "api.unsplash.com")
        XCTAssertEqual(observedRequest?.url?.path, "/photos")
        XCTAssertTrue(observedRequest?.url?.query?.contains("client_id=TEST_KEY") ?? false)
    }

    // MARK: - Helpers

    private func ok() -> HTTPURLResponse {
        HTTPURLResponse(url: URL(string: "https://api.unsplash.com/photos")!,
                        statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

    private let unsplashPhotosJSON = """
    [
      {
        "id": "abc",
        "description": null,
        "alt_description": "a scenic mountain view",
        "urls": { "regular": "https://images.unsplash.com/photo-abc" },
        "user": { "name": "Jane Doe" }
      }
    ]
    """
}
