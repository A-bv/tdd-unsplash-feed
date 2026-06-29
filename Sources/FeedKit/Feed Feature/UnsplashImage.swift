import Foundation

/// A single image in an Unsplash feed.
///
/// This is a pure value type: two images are equal when all of their
/// fields are equal (value semantics), unlike a model identified by a
/// freshly generated `UUID`.
public struct UnsplashImage: Equatable {
    public let id: String
    public let description: String?
    public let url: URL
    public let authorName: String

    public init(id: String, description: String?, url: URL, authorName: String) {
        self.id = id
        self.description = description
        self.url = url
        self.authorName = authorName
    }
}
