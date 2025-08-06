// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class TimeMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(app as any AppProtocol)

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_significantChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TimeMonitor.Event?
        let monitor = TimeMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSignificantChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .significantChange)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateSignificantChange() {
        notificationCenter.post(name: UIApplication.significantTimeChangeNotification,
                                object: app)
    }
}
