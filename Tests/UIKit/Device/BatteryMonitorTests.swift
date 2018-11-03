//
//  BatteryMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class BatteryMonitorTests: XCTestCase {
    let device = MockDevice()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DeviceInjector.inject = { self.device }

        device.batteryLevel = 0
        device.batteryState = .unknown

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testLevel() {
        let expectedLevel: Float = 75
        let monitor = BatteryMonitor(options: .levelDidChange,
                                     queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateLevelDidChange(to: expectedLevel)

        XCTAssertEqual(monitor.level, expectedLevel)
    }

    func testMonitor_levelDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLevel: Float = 50
        var expectedEvent: BatteryMonitor.Event?
        let monitor = BatteryMonitor(options: .levelDidChange,
                                     queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateLevelDidChange(to: expectedLevel)
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
        let monitor = BatteryMonitor(options: .stateDidChange,
                                     queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateStateDidChange(to: expectedState)
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
        let monitor = BatteryMonitor(options: .stateDidChange,
                                     queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateLevelDidChange(to level: Float) {
        device.batteryLevel = level

        notificationCenter.post(name: UIDevice.batteryLevelDidChangeNotification,
                                object: device)
    }

    private func simulateStateDidChange(to state: UIDevice.BatteryState) {
        device.batteryState = state

        notificationCenter.post(name: UIDevice.batteryStateDidChangeNotification,
                                object: device)
    }
}
