//
//  CurrentLocaleMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-05-28.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class CurrentLocaleMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: CurrentLocaleMonitor.Event?
        let monitor = CurrentLocaleMonitor(queue: .main) { event in
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

    private func simulateDidChange() {
        notificationCenter.post(name: NSLocale.currentLocaleDidChangeNotification,
                                object: nil)
    }
}
