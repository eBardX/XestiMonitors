//
//  CalendarDayMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-05-28.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class CalenderDayMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_changed() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: CalendarDayMonitor.Event?
        let monitor = CalendarDayMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(.changed, event)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateChanged() {
        notificationCenter.post(name: .NSCalendarDayChanged, object: nil)
    }
}
