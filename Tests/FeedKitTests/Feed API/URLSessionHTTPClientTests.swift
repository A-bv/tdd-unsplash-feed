import XCTest
@testable import FeedKit

final class URLSessionHTTPClientTests: XCTestCase {

    override func tearDown() {
        URLProtocolStub.reset()
        super.tearDown()
    }

    func test_getFromURL_performsGETRequestWithURL() async {
        let url = URL(string: "https://api.unsplash.com/photos")!
        var observedRequest: URLRequest?
        URLProtocolStub.observeRequests { observedRequest = $0 }
        URLProtocolStub.stub(data: nil, response: anyHTTPURLResponse(url), error: nil)

        _ = try? await makeSUT().get(from: url)

        XCTAssertEqual(observedRequest?.url, url)
        XCTAssertEqual(observedRequest?.httpMethod, "GET")
    }

    func test_getFromURL_failsOnRequestError() async {
        let injectedError = anyNSError()
        URLProtocolStub.stub(data: nil, response: nil, error: injectedError)

        do {
            _ = try await makeSUT().get(from: anyURL())
            XCTFail("Expected request to fail with \(injectedError)")
        } catch {
            let nsError = error as NSError
            XCTAssertEqual(nsError.domain, injectedError.domain)
            XCTAssertEqual(nsError.code, injectedError.code)
        }
    }

    func test_getFromURL_succeedsOnHTTPResponseWithData() async throws {
        let url = anyURL()
        let expectedData = Data("a feed".utf8)
        URLProtocolStub.stub(data: expectedData, response: anyHTTPURLResponse(url, code: 200), error: nil)

        let (data, response) = try await makeSUT().get(from: url)

        XCTAssertEqual(data, expectedData)
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.url, url)
    }

    func test_getFromURL_failsOnNonHTTPURLResponse() async {
        let url = anyURL()
        let nonHTTP = URLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
        URLProtocolStub.stub(data: Data(), response: nonHTTP, error: nil)

        do {
            _ = try await makeSUT().get(from: url)
            XCTFail("Expected failure on non-HTTP response")
        } catch {
            // success
        }
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient(session: URLProtocolStub.makeSession())
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    private func anyURL() -> URL {
        URL(string: "https://any-url.com")!
    }

    private func anyHTTPURLResponse(_ url: URL, code: Int = 200) -> HTTPURLResponse {
        HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
    }
}
