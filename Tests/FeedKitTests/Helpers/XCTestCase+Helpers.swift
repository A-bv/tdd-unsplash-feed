import XCTest

extension XCTestCase {
    /// Fails the test if `instance` has not been deallocated by teardown,
    /// catching retain cycles in the system under test.
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}
