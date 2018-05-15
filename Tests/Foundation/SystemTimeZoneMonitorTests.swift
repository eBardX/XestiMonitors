//
//  SystemTimeZoneMonitorTests.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class SystemTimeZoneMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_TimeZoneDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: SystemTimeZoneMonitor.Event?
        let monitor = SystemTimeZoneMonitor(queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateTimeZoneDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(.didChange, event)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateTimeZoneDidChange() {
        notificationCenter.post(name: .NSSystemTimeZoneDidChange,
                                object: nil)
    }
}
