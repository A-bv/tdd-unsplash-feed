# Fetching images from Unsplash using TDD

A small Swift package that loads a photo feed from the [Unsplash API](https://unsplash.com/developers), built test-first.

[![CI](https://github.com/A-bv/tdd-unsplash-feed/actions/workflows/ci.yml/badge.svg)](https://github.com/A-bv/tdd-unsplash-feed/actions/workflows/ci.yml)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-F05138?logo=swift&logoColor=white)
![iOS 15+ | macOS 12+](https://img.shields.io/badge/platform-iOS%2015%2B%20%7C%20macOS%2012%2B-007AFF?logo=apple&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-compatible-success)
[![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey)](LICENSE)

<p align="center">
  <img src=".github/demo.gif" alt="A sample app loading a photo feed from Unsplash" width="300">
</p>

## Install

In Xcode, open File, Add Package Dependencies, and paste this URL:

```
https://github.com/A-bv/tdd-unsplash-feed
```

## Usage

Register your app at [unsplash.com/oauth/applications](https://unsplash.com/oauth/applications) to get a free Access Key. Then create a loader and show the photos.

```swift
import SwiftUI
import UnsplashFeed

struct FeedView: View {
    @State private var images: [UnsplashImage] = []
    let loader = UnsplashFeed.makeRemoteFeedLoader(accessKey: "YOUR_ACCESS_KEY")

    var body: some View {
        List(images, id: \.id) { image in
            AsyncImage(url: image.url) { $0.resizable().scaledToFill() } placeholder: { ProgressView() }
                .frame(height: 200)
        }
        .task { images = (try? await loader.load()) ?? [] }
    }
}
```

## How it was built with TDD

TDD means you write a failing test first, then the smallest code that makes it pass, then you clean up. The three steps are Red (a failing test), Green (make it pass), Refactor (tidy up).

Small example. First the test, which fails because the behavior does not exist yet:

```swift
func test_load_deliversConnectivityErrorOnClientError() async {
    let (sut, client) = makeSUT()
    client.stub(error: anyNSError())

    await assertThrows(RemoteFeedLoader.Error.connectivity) {
        _ = try await sut.load()
    }
}
```

Then the code that makes it pass:

```swift
do {
    _ = try await client.get(from: url)
} catch {
    throw Error.connectivity
}
```

Follow the whole feature in the [commit history](https://github.com/A-bv/tdd-unsplash-feed/commits/main). Each feature commit shows its Red (the failing test) and Green (the code that passes it), and the refactor commits show the Refactor step.

## The design

Writing tests first led to clean, swappable pieces.

- FeedLoader and HTTPClient are protocols, so tests use a stub and never hit the network.
- One type does the networking, one type parses the JSON.
- Errors are typed, connectivity or invalidData, instead of raw errors.

## Tests

16 tests, fully offline. The network is faked with a stub, so no key or internet is needed.

## License

MIT. See [LICENSE](LICENSE).
