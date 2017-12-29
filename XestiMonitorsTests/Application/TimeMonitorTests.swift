//
//  TimeMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class TimeMonitorTests: XCTestCase {

    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    func testMonitor_significantChange() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TimeMonitor.Event?
        let monitor = TimeMonitor(notificationCenter: notificationCenter,
                                  queue: .main) { event in
                                    expectedEvent = event
                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSignificantChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .significantChange)
        } else {
            XCTFail("Unexpected event")
        }

    }

    private func simulateSignificantChange() {

        notificationCenter.post(name: .UIApplicationSignificantTimeChange,
                                object: application)

    }

}
