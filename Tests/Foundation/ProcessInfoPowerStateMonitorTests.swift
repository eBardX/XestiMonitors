//
//  ProcessInfoPowerStateMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class ProcessInfoPowerStateMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let processInfo = MockProcessInfo()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }

        ProcessInfoInjector.inject = { return self.processInfo }

        processInfo.isLowPowerModeEnabled = false
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: Bool = true
        var expectedEvent: ProcessInfoPowerStateMonitor.Event?
        let monitor = ProcessInfoPowerStateMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange(to: expectedState)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, expectedState)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testState() {
        let expectedState: Bool = true
        let monitor = ProcessInfoPowerStateMonitor(queue: .main) { _ in }

        simulateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateDidChange(to state: Bool) {
        processInfo.isLowPowerModeEnabled = state

        notificationCenter.post(name: .NSProcessInfoPowerStateDidChange,
                                object: processInfo)
    }
}
