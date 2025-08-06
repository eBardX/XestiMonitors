// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class BackgroundRefreshMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(app as any AppProtocol)

        app.backgroundRefreshStatus = .restricted

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_statusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStatus: UIBackgroundRefreshStatus = .available
        var expectedEvent: BackgroundRefreshMonitor.Event?
        let monitor = BackgroundRefreshMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateStatusDidChange(to: expectedStatus)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .statusDidChange(status) = event {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testStatus() {
        let expectedStatus: UIBackgroundRefreshStatus = .denied
        let monitor = BackgroundRefreshMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateStatusDidChange(to: expectedStatus)

        XCTAssertEqual(monitor.status, expectedStatus)
    }

    // MARK: Private Instance Methods

    private func _simulateStatusDidChange(to status: UIBackgroundRefreshStatus) {
        app.backgroundRefreshStatus = status

        notificationCenter.post(name: UIApplication.backgroundRefreshStatusDidChangeNotification,
                                object: app)
    }
}
