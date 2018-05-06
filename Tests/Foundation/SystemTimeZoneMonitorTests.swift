//
//  SystemTimeZoneMonitorTests.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-10
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

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: SystemTimeZoneMonitor.Event?
        let monitor = SystemTimeZoneMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .didChange)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateDidChange() {
        notificationCenter.post(name: .NSSystemTimeZoneDidChange, object: nil)
    }
}
