# FeedKit

A small Swift package that loads an image feed from the [Unsplash API](https://unsplash.com/developers) — built **strictly with Test-Driven Development (TDD)** as a learning exercise.

The point of this repo is less the feature itself and more the **method**: every line of production code exists because a failing test demanded it, following the **Red → Green → Refactor** cycle.

## Why this project exists

It's a hands-on demonstration of the TDD workflow popularised by [Essential Developer](https://www.essentialdeveloper.com/):

1. **🔴 Red** — write a failing test describing one desired behaviour.
2. **🟢 Green** — write the minimum production code to make it pass.
3. **🔵 Refactor** — clean up the design while the tests stay green.

The result is a decoupled, fully tested networking feature with zero test code leaking into the shipped library.

## Architecture

The package is organised by feature concern, depending on abstractions rather than concretions:

```
Sources/FeedKit
├── Feed Feature/              # The domain — no networking knowledge
│   ├── UnsplashImage.swift    #   Value-type model (value equality)
│   └── FeedLoader.swift       #   `load() async throws -> [UnsplashImage]`
├── Feed API/                  # The networking layer
│   ├── HTTPClient.swift       #   Abstraction over the network
│   ├── RemoteFeedLoader.swift #   FeedLoader over HTTP (typed errors)
│   ├── UnsplashImageMapper.swift  # Maps Unsplash JSON -> domain model
│   ├── URLSessionHTTPClient.swift # The only place touching the real network
│   └── UnsplashEndpoint.swift #   Builds Unsplash URLs (client_id auth)
└── FeedKit.swift              # Composition root / factory
```

Key design decisions:

- **`FeedLoader` is a protocol.** Callers depend on the behaviour, not the source — making it trivial to swap in a `RemoteFeedLoader`, a future cache, or a test double.
- **`HTTPClient` is a protocol.** `RemoteFeedLoader` is tested entirely against an in-memory spy; no real requests are made in unit tests.
- **Typed errors.** `RemoteFeedLoader.Error` distinguishes `.connectivity` from `.invalidData` instead of leaking `NSError`.
- **Value semantics.** `UnsplashImage` compares by its fields, not by an identity token.

## Usage

```swift
import FeedKit

// Composition root wires URLSession + endpoint + loader together.
let loader = FeedKit.makeRemoteFeedLoader(accessKey: "YOUR_UNSPLASH_ACCESS_KEY")

do {
    let images: [UnsplashImage] = try await loader.load()
    for image in images {
        print(image.authorName, image.url)
    }
} catch RemoteFeedLoader.Error.connectivity {
    print("No connection")
} catch RemoteFeedLoader.Error.invalidData {
    print("Server returned an unexpected response")
}
```

Get a free access key by registering an app at <https://unsplash.com/oauth/applications>.

## Installation

Add the package in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/A-bv/Feedkit.git", branch: "main")
]
```

> No versioned release is published yet, so the example pins the `main`
> branch. Once a release is tagged, switch to `from: "1.0.0"`.

Requires **Swift 5.9+**, macOS 12+ / iOS 15+ (for `async`/`await` `URLSession`).

## Running the tests

```bash
swift test
```

The suite covers the loader's full contract (request URL, connectivity failure, non-200 responses, invalid JSON, empty and populated feeds), the real `URLSession` client (via a `URLProtocol` stub, no live network), and the endpoint builder.

Continuous integration runs `swift build` + `swift test` on every push and pull request (see [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

## License

Released under the [MIT License](LICENSE).
