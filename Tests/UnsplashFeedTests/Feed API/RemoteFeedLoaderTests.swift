import XCTest
@testable import UnsplashFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() async throws {
        let url = URL(string: "https://api.unsplash.com/photos")!
        let (sut, client) = makeSUT(url: url)
        client.stub(withStatusCode: 200, data: makeItemsJSON([]))

        _ = try await sut.load()

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() async throws {
        let url = URL(string: "https://api.unsplash.com/photos")!
        let (sut, client) = makeSUT(url: url)
        client.stub(withStatusCode: 200, data: makeItemsJSON([]))

        _ = try await sut.load()
        _ = try await sut.load()

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://api.unsplash.com/photos")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: items)
    }
}
