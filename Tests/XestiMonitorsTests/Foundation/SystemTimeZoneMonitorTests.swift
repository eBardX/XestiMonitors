// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class SystemTimeZoneMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: SystemTimeZoneMonitor.Event?
        let monitor = SystemTimeZoneMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(.didChange, event)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateDidChange() {
        notificationCenter.post(name: .NSSystemTimeZoneDidChange,
                                object: nil)
    }
}
