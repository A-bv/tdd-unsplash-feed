# TDD Walkthrough

This repository is meant to be read **through its commits**. The feature
was grown one behaviour at a time following Red → Green → Refactor: each
commit adds a failing test and the minimum code to make it pass, so the
history *is* the story of the design.

Browse it with:

```bash
git log --oneline --reverse
```

## The journey

1. **chore: scaffold Swift package** — an empty library to grow into.
2. **feat: create RemoteFeedLoader without requesting on init** — the
   first behaviour: creating the loader must not touch the network.
3. **feat: request feed data from the URL on load** — `load()` asks the
   client for the URL, once per call.
4. **feat: report connectivity error when the client fails** — client
   failures become a typed `.connectivity` error.
5. **feat: reject non-200 responses as invalid data** — only a 200 is a
   valid feed.
6. **feat: map a 200 response into feed images** — decode the payload;
   bad JSON is `.invalidData`, an empty list yields no items.
7. **feat: fall back to alt_description when description is null** — a
   real Unsplash quirk, driven by a test.
8. **refactor: extract JSON mapping into UnsplashImageMapper** — with
   tests green, split parsing away from the loader.
9. **feat: add URLSession-backed HTTP client** — the real network
   boundary, tested against a `URLProtocol` stub.
10. **feat: build Unsplash endpoint URLs** — auth and pagination live
    here, not in the client.
11. **feat: add composition root with integration test** — one factory
    wires it all together, covered end to end.
12. **fix: propagate cancellation instead of masking it** — a
    correctness gap found later, fixed test-first.
13. **refactor: make public types Sendable** — harden the async surface
    under strict concurrency.

## Design principles the tests enforce

- **Depend on abstractions.** `FeedLoader` and `HTTPClient` are
  protocols, so the loader is tested with an in-memory spy and no real
  requests are made in unit tests.
- **Typed errors.** `.connectivity` vs `.invalidData` instead of leaking
  `NSError`.
- **One network boundary.** Only `URLSessionHTTPClient` touches the real
  network, and it is tested through a `URLProtocol` stub.
- **No test code in the shipped library.**
