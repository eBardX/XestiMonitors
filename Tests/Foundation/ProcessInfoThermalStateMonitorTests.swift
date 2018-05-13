//
//  ProcessInfoThermalStateMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

@available(iOS 11.0, OSX 10.10.3, tvOS 11.0, *)
internal class ProcessInfoThermalStateMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let processInfo = MockProcessInfo()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }

        ProcessInfoInjector.inject = { return self.processInfo }

        processInfo.thermalState = .nominal
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedState: ProcessInfo.ThermalState = .serious
        var expectedEvent: ProcessInfoThermalStateMonitor.Event?
        let monitor = ProcessInfoThermalStateMonitor(queue: .main) { event in
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
        let expectedState: ProcessInfo.ThermalState = .critical
        let monitor = ProcessInfoThermalStateMonitor(queue: .main) { _ in }

        simulateDidChange(to: expectedState)

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateDidChange(to state: ProcessInfo.ThermalState) {
        processInfo.thermalState = state

        notificationCenter.post(name: ProcessInfo.thermalStateDidChangeNotification,
                                object: processInfo)
    }
}
