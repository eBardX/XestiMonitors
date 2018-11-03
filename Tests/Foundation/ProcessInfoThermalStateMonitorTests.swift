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

internal class ProcessInfoThermalStateMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let processInfo = MockProcessInfo()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }

        ProcessInfoInjector.inject = { self.processInfo }

        processInfo.rawThermalState = 0
    }

    func testMonitor_didChange() {
        if #available(iOS 11.0, OSX 10.10.3, tvOS 11.0, *) {
            let expectation = self.expectation(description: "Handler called")
            let expectedState: ProcessInfo.ThermalState = .serious
            var expectedEvent: ProcessInfoThermalStateMonitor.Event?
            let monitor = ProcessInfoThermalStateMonitor(queue: .main) { event in
                XCTAssertEqual(OperationQueue.current, .main)

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
    }

    func testState() {
        if #available(iOS 11.0, OSX 10.10.3, tvOS 11.0, *) {
            let expectedState: ProcessInfo.ThermalState = .critical
            let monitor = ProcessInfoThermalStateMonitor(queue: .main) { _ in
                XCTAssertEqual(OperationQueue.current, .main)
            }

            simulateDidChange(to: expectedState)

            XCTAssertEqual(monitor.state, expectedState)
        }
    }

    @available(iOS 11.0, OSX 10.10.3, tvOS 11.0, *)
    private func simulateDidChange(to state: ProcessInfo.ThermalState) {
        processInfo.rawThermalState = state.rawValue

        notificationCenter.post(name: ProcessInfo.thermalStateDidChangeNotification,
                                object: processInfo)
    }
}
