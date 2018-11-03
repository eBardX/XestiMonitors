//
//  SystemClockMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-06-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class SystemClockMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: SystemClockMonitor.Event?
        let monitor = SystemClockMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(.didChange, event)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateDidChange() {
        notificationCenter.post(name: .NSSystemClockDidChange,
                                object: nil)
    }
}
