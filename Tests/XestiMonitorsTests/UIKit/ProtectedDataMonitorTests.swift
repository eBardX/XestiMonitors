// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ProtectedDataMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(app as any AppProtocol)

        app.isProtectedDataAvailable = false

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didBecomeAvailable() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ProtectedDataMonitor.Event?
        let monitor = ProtectedDataMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeAvailable()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .didBecomeAvailable)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testIsContentAccessible() {
        let expectedIsContentAccessible: Bool = true
        let monitor = ProtectedDataMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        app.isProtectedDataAvailable = true

        XCTAssertEqual(monitor.isContentAccessible, expectedIsContentAccessible)
    }

    func testMonitor_willBecomeUnavailable() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ProtectedDataMonitor.Event?
        let monitor = ProtectedDataMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillBecomeUnavailable()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .willBecomeUnavailable)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBecomeAvailable() {
        notificationCenter.post(name: UIApplication.protectedDataDidBecomeAvailableNotification,
                                object: app)
    }

    private func _simulateWillBecomeUnavailable() {
        notificationCenter.post(name: UIApplication.protectedDataWillBecomeUnavailableNotification,
                                object: app)
    }
}
