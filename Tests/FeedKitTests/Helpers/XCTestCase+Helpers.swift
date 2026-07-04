import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension XCTestCase {
    /// Fails the test if `instance` has not been deallocated by teardown,
    /// catching retain cycles in the system under test.
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        let box = WeakBox(instance)
        addTeardownBlock {
            XCTAssertNil(box.value, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

/// Holds a weak reference so the teardown closure can capture something
/// `Sendable` instead of the tracked (non-Sendable) instance directly.
private final class WeakBox: @unchecked Sendable {
    weak var value: AnyObject?
    init(_ value: AnyObject) { self.value = value }
}
