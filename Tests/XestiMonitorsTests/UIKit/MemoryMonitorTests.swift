// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class MemoryMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        AppInjector.inject = { self.app }

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didReceiveWarning() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MemoryMonitor.Event?
        let monitor = MemoryMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidReceiveMemoryWarning()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .didReceiveWarning)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidReceiveMemoryWarning() {
        notificationCenter.post(name: UIApplication.didReceiveMemoryWarningNotification,
                                object: app)
    }
}
