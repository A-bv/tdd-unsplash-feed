# UnsplashFeed

A small Swift package that loads an image feed from the [Unsplash API](https://unsplash.com/developers), built **strictly test-first**. The point is the method — TDD — not the feature.

## Watch it get built, test-first

Read the commits from the beginning:

```bash
git log --oneline --reverse
```

Each one is a single **Red → Green → Refactor** step: a failing test, the least code to make it pass, then a tidy-up. Only the last two commits — this README and CI — are **non-TDD**.

## Run the tests

```bash
swift test
```

Offline and fast: the network layer is tested against a stub, so no key or internet is needed.

## Use it

```swift
import UnsplashFeed

let loader = UnsplashFeed.makeRemoteFeedLoader(accessKey: "YOUR_UNSPLASH_KEY")
let images = try await loader.load()   // [UnsplashImage]
```

A free [Unsplash access key](https://unsplash.com/oauth/applications) is only needed to fetch real images — not to build or test.
