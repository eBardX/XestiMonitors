// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class SystemClockMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: SystemClockMonitor.Event?
        let monitor = SystemClockMonitor { event in
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
        notificationCenter.post(name: .NSSystemClockDidChange,
                                object: nil)
    }
}
