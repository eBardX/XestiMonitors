// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ProximityMonitorTests: XCTestCase {
    let device = MockDevice()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(device as any DeviceProtocol)

        device.proximityState = false

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testIsAvailable() {
        let monitor = ProximityMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        device.isProximityMonitoringEnabled = false

        XCTAssertFalse(device.isProximityMonitoringEnabled)
        XCTAssertTrue(monitor.isAvailable)
        XCTAssertFalse(device.isProximityMonitoringEnabled)
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: Bool = true
        var expectedEvent: ProximityMonitor.Event?
        let monitor = ProximityMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateStateDidChange(to: expectedState)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .stateDidChange(state) = event {
            XCTAssertEqual(state, expectedState)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testState() {
        let expectedState: Bool = true
        let monitor = ProximityMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    // MARK: Private Instance Methods

    private func _simulateStateDidChange(to state: Bool) {
        device.proximityState = state

        notificationCenter.post(name: UIDevice.proximityStateDidChangeNotification,
                                object: device)
    }
}
