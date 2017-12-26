import UIKit
import XCTest
import XestiMonitors

public class Tests: XCTestCase {

    override public func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of
        // each test method in the class.
    }

    override public func tearDown() {
        // Put teardown code here. This method is called after the invocation
        // of each test method in the class.
        super.tearDown()
    }

    public func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    public func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
