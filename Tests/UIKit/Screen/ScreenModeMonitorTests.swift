//
//  ScreenModeMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-03-31.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenModeMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let screen = UIScreen()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenModeMonitor.Event?
        let monitor = ScreenModeMonitor(screen: screen,
                                        queue: .main) { event  in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: .UIScreenModeDidChange,
                                object: screen)
    }
}
