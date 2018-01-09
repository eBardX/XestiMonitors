//
//  ProximityMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ProximityMonitorTests: XCTestCase {
    let device = MockDevice()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DeviceInjector.device = device

        device.proximityState = false

        NotificationCenterInjector.notificationCenter = notificationCenter
    }

    func testIsAvailable() {
        let monitor = ProximityMonitor(queue: .main) { _ in }

        device.isProximityMonitoringEnabled = false

        XCTAssertFalse(device.isProximityMonitoringEnabled)
        XCTAssertTrue(monitor.isAvailable)
        XCTAssertFalse(device.isProximityMonitoringEnabled)
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: Bool = true
        var expectedEvent: ProximityMonitor.Event?
        let monitor = ProximityMonitor(queue: .main) { event in
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
        let expectedState: Bool = true
        let monitor = ProximityMonitor(queue: .main) { _ in }

        simulateStateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateStateDidChange(to state: Bool) {
        device.proximityState = state

        notificationCenter.post(name: .UIDeviceProximityStateDidChange,
                                object: device)
    }
}
