// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class CalenderDayMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_changed() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: CalendarDayMonitor.Event?
        let monitor = CalendarDayMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(.changed, event)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateChanged() {
        notificationCenter.post(name: .NSCalendarDayChanged, object: nil)
    }
}
