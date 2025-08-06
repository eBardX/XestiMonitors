// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class PortMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let port = Port()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PortMonitor.Event?
        let monitor = PortMonitor(port: port) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeInvalid()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didBecomeInvalid(test) = event {
            XCTAssertEqual(test, port)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBecomeInvalid() {
        notificationCenter.post(name: Port.didBecomeInvalidNotification,
                                object: port)
    }
}
