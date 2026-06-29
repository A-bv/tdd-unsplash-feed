import XCTest
@testable import FeedKit

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

    func test_load_deliversConnectivityErrorOnClientError() async {
        let (sut, client) = makeSUT()
        client.stub(error: anyNSError())

        await assertThrows(RemoteFeedLoader.Error.connectivity) {
            _ = try await sut.load()
        }
    }

    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() async {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]

        for code in samples {
            client.stub(withStatusCode: code, data: makeItemsJSON([]))

            await assertThrows(RemoteFeedLoader.Error.invalidData) {
                _ = try await sut.load()
            }
        }
    }

    func test_load_deliversInvalidDataErrorOn200ResponseWithInvalidJSON() async {
        let (sut, client) = makeSUT()
        client.stub(withStatusCode: 200, data: Data("invalid json".utf8))

        await assertThrows(RemoteFeedLoader.Error.invalidData) {
            _ = try await sut.load()
        }
    }

    func test_load_deliversNoItemsOn200ResponseWithEmptyJSONList() async throws {
        let (sut, client) = makeSUT()
        client.stub(withStatusCode: 200, data: makeItemsJSON([]))

        let result = try await sut.load()

        XCTAssertEqual(result, [])
    }

    func test_load_deliversItemsOn200ResponseWithJSONItems() async throws {
        let (sut, client) = makeSUT()

        let item1 = makeItem(
            id: "id-1",
            description: nil,
            url: URL(string: "https://images.unsplash.com/photo-1")!,
            authorName: "Author One")

        let item2 = makeItem(
            id: "id-2",
            description: "A lovely landscape",
            url: URL(string: "https://images.unsplash.com/photo-2")!,
            authorName: "Author Two")

        client.stub(withStatusCode: 200, data: makeItemsJSON([item1.json, item2.json]))

        let result = try await sut.load()

        XCTAssertEqual(result, [item1.model, item2.model])
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

    private func makeItem(
        id: String,
        description: String?,
        url: URL,
        authorName: String
    ) -> (model: UnsplashImage, json: [String: Any]) {
        let model = UnsplashImage(id: id, description: description, url: url, authorName: authorName)

        var json: [String: Any] = [
            "id": id,
            "urls": ["regular": url.absoluteString],
            "user": ["name": authorName]
        ]
        if let description { json["description"] = description }

        return (model, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        try! JSONSerialization.data(withJSONObject: items)
    }

    private func assertThrows<T>(
        _ expectedError: RemoteFeedLoader.Error,
        file: StaticString = #filePath,
        line: UInt = #line,
        when action: () async throws -> T
    ) async {
        do {
            _ = try await action()
            XCTFail("Expected to throw \(expectedError), but returned successfully", file: file, line: line)
        } catch let error as RemoteFeedLoader.Error {
            XCTAssertEqual(error, expectedError, file: file, line: line)
        } catch {
            XCTFail("Expected \(expectedError), got \(error) instead", file: file, line: line)
        }
    }
}
