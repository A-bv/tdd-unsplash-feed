# Engineering decisions

The senior calls that shaped FeedKit, and — just as important — what was
deliberately left out. Each was made and approved intentionally; they are
settled, not open questions. Recorded so the reasoning outlives the chat.

---

### 1. North star: a TDD / clean-architecture showcase
Not a minimal one-file utility, and not a broadly-depended-on library. The
value is demonstrating test-driven design and clean boundaries — so the
protocols, dependency injection, and test doubles **are** the point, and stay.
Collapsing them to a 20-line fetch would delete the reason the repo exists.

### 2. Keep it minimal *for that goal* — descope feature growth
Deliberately **not** built: error payloads, request metadata on `HTTPClient`,
pagination, rate-limit/auth error distinctions, DocC site. Each turns FeedKit
into a bigger library, which cuts against "simplest possible showcase." The
clean typed errors (`.connectivity` / `.invalidData`) are the idiomatic
Essential-Developer boundary and are kept as-is.

### 3. The git history is the product — rebuilt to show Red→Green→Refactor
The feature originally landed in one squashed commit, hiding the method. It was
reconstructed as a linear, green-per-step TDD history so a reader can *watch*
the design emerge. Rebuilt on a branch, reviewed, then promoted to `main`; the
original history is preserved under the tag `archive/pre-tdd-rewrite`.

### 4. Direct-to-`main`, with per-commit human review
Chosen over a PR flow. It's a solo showcase: the human approval gate on every
commit provides the review, and CI gates every push. One commit per change,
plain-language messages.

### 5. Cross-platform, verified — not asserted
FeedKit is pure Foundation (no UIKit), so it should run on Apple platforms and
Linux. Rather than claim it, CI builds and tests on **both macOS and Linux**.
This surfaced and fixed a real portability bug (networking types live in
`FoundationNetworking` on Linux).

### 6. Swift 6 language mode
Adopted so strict-concurrency safety is a first-class, enforced rule across the
whole package — not an experimental flag on part of it, which read as
unfinished for a 2026 showcase. **Cost accepted:** building requires a Swift 6
toolchain, and macOS CI runs on a Swift 6 runner.

### 7. The Unsplash key is the honest floor — no fake "keyless" path
Using the real Unsplash API requires a (free) access key; that's Unsplash's
rule, not clutter. We do **not** hardcode a shared key or bolt on a second
provider to dodge it. Building and testing the package needs **no** key (the
suite is hermetic); a key is only needed to fetch live images.

### 8. Live API test is opt-in
The end-to-end test that hits real Unsplash is skipped unless
`UNSPLASH_ACCESS_KEY` is set, so ordinary and CI runs stay offline and
deterministic — while anyone can still prove real fetching with one command.
