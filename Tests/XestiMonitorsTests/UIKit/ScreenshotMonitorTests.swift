// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenshotMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(app as any AppProtocol)

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_userDidTake() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenshotMonitor.Event?
        let monitor = ScreenshotMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateUserDidTake()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .userDidTake)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateUserDidTake() {
        notificationCenter.post(name: UIApplication.userDidTakeScreenshotNotification,
                                object: app)
    }
}
