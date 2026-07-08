import XCTest
@testable import UnsplashFeed

final class UnsplashEndpointTests: XCTestCase {

    func test_photos_buildsExpectedURL() throws {
        let url = UnsplashEndpoint.photos(accessKey: "MY_KEY").url

        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        XCTAssertEqual(components.scheme, "https")
        XCTAssertEqual(components.host, "api.unsplash.com")
        XCTAssertEqual(components.path, "/photos")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "client_id" })?.value, "MY_KEY")
    }

    func test_photos_includesPaginationParameters() throws {
        let url = UnsplashEndpoint.photos(accessKey: "k", page: 2, perPage: 30).url

        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "page" })?.value, "2")
        XCTAssertEqual(components.queryItems?.first(where: { $0.name == "per_page" })?.value, "30")
    }
}
