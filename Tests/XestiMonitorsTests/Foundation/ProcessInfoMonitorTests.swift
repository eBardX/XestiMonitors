// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class ProcessInfoMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let processInfo = MockProcessInfo()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)

        DependencyResolver.register(processInfo as any ProcessInfoProtocol)

        processInfo.isLowPowerModeEnabled = false
        processInfo.rawThermalState = 0
    }

    func testMonitor_powerStateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: Bool = true
        var expectedEvent: ProcessInfoMonitor.Event?
        let monitor = ProcessInfoMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulatePowerStateDidChange(to: expectedState)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .powerStateDidChange(test) = event {
            XCTAssertEqual(test, expectedState)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_thermalStateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: ProcessInfo.ThermalState = .serious
        var expectedEvent: ProcessInfoMonitor.Event?
        let monitor = ProcessInfoMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateThermalStateDidChange(to: expectedState)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .thermalStateDidChange(test) = event {
            XCTAssertEqual(test, expectedState)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testPowerState() {
        let expectedState: Bool = true
        let monitor = ProcessInfoMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulatePowerStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.isLowPowerModeEnabled, expectedState)
    }

    func testThermalState() {
        let expectedState: ProcessInfo.ThermalState = .critical
        let monitor = ProcessInfoMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateThermalStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.thermalState, expectedState)
    }

    private func _simulatePowerStateDidChange(to isLowPowerModeEnabled: Bool) {
        processInfo.isLowPowerModeEnabled = isLowPowerModeEnabled

        notificationCenter.post(name: .NSProcessInfoPowerStateDidChange,
                                object: processInfo)
    }

    private func _simulateThermalStateDidChange(to thermalState: ProcessInfo.ThermalState) {
        processInfo.rawThermalState = thermalState.rawValue

        notificationCenter.post(name: ProcessInfo.thermalStateDidChangeNotification,
                                object: processInfo)
    }
}
