// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class BatteryMonitorTests: XCTestCase {
    let device = MockDevice()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(device as any DeviceProtocol)

        device.batteryLevel = 0
        device.batteryState = .unknown

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testLevel() {
        let expectedLevel: Float = 75
        let monitor = BatteryMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateLevelDidChange(to: expectedLevel)

        XCTAssertEqual(monitor.level, expectedLevel)
    }

    func testMonitor_levelDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLevel: Float = 50
        var expectedEvent: BatteryMonitor.Event?
        let monitor = BatteryMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateLevelDidChange(to: expectedLevel)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .levelDidChange(level) = event {
            XCTAssertEqual(level, expectedLevel)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: UIDevice.BatteryState = .charging
        var expectedEvent: BatteryMonitor.Event?
        let monitor = BatteryMonitor { event in
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
        let expectedState: UIDevice.BatteryState = .full
        let monitor = BatteryMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    // MARK: Private Instance Methods

    private func _simulateLevelDidChange(to level: Float) {
        device.batteryLevel = level

        notificationCenter.post(name: UIDevice.batteryLevelDidChangeNotification,
                                object: device)
    }

    private func _simulateStateDidChange(to state: UIDevice.BatteryState) {
        device.batteryState = state

        notificationCenter.post(name: UIDevice.batteryStateDidChangeNotification,
                                object: device)
    }
}
