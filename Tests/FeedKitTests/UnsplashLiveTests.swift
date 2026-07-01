import XCTest
@testable import FeedKit

/// End-to-end test against the *real* Unsplash API.
///
/// It is skipped unless `UNSPLASH_ACCESS_KEY` is set, so ordinary and CI
/// runs stay hermetic (no live network, no flakiness, no secrets needed).
/// To prove the package actually fetches images, run:
///
/// ```bash
/// UNSPLASH_ACCESS_KEY=your_key swift test
/// ```
final class UnsplashLiveTests: XCTestCase {

    func test_load_fetchesRealImagesFromUnsplash() async throws {
        guard let key = ProcessInfo.processInfo.environment["UNSPLASH_ACCESS_KEY"],
              !key.isEmpty else {
            throw XCTSkip("Set UNSPLASH_ACCESS_KEY to run the live Unsplash test")
        }

        let loader = FeedKit.makeRemoteFeedLoader(accessKey: key)

        let images = try await loader.load()

        XCTAssertFalse(images.isEmpty, "Expected Unsplash to return at least one image")
        XCTAssertTrue(
            images.allSatisfy { $0.url.scheme?.hasPrefix("http") == true },
            "Expected every image to carry a usable http(s) URL")
        XCTAssertTrue(
            images.allSatisfy { !$0.authorName.isEmpty },
            "Expected every image to carry an author name")
    }
}
