import XCTest
@testable import FeedKit

final class FeedKitTests: XCTestCase {
    func test_loadUnsplashImage_success() throws {
        let feedLoader = MockFeedLoader()
        let expected = UnsplashImage()
        feedLoader.loadUnsplashImageResult = .success(expected)
        
        let sut = FeedKit(feedLoader: feedLoader)
        
        let result = try sut.loadUnsplashImage()
        XCTAssertEqual(expected, result)
    }
    
    func test_loadUnsplashImage_failure() throws {
        let feedLoader = MockFeedLoader()
        let expected = NSError()
        feedLoader.loadUnsplashImageResult = .failure(expected)
        
        let sut = FeedKit(feedLoader: feedLoader)

        XCTAssertThrowsError(try sut.loadUnsplashImage())
    }
}

protocol FeedLoader {
    func loadUnsplashImage() throws -> UnsplashImage
}

final class RemoteFeedLoader: FeedLoader {
    func loadUnsplashImage() throws -> UnsplashImage {
        UnsplashImage()
    }
}

final class LocalFeedLoader: FeedLoader {
    func loadUnsplashImage() throws -> UnsplashImage {
        UnsplashImage()
    }
}

final class MockFeedLoader: FeedLoader {
    var loadUnsplashImageResult: Result<UnsplashImage, Error>!
    
    func loadUnsplashImage() throws -> UnsplashImage {
        /*
        switch loadUnsplashImageResult {
        case .success(let image):
            return image
        case .failure(let error):
            throw error
        case .none:
            assertionFailure()
        }*/
        
        try loadUnsplashImageResult.get()
    }
}

final class FeedKit {
    let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadUnsplashImage() throws -> UnsplashImage {
        try feedLoader.loadUnsplashImage()
    }
}

struct UnsplashImage: Equatable {
    let id = UUID()
}
