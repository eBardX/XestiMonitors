//
//  ScreenCapturedMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-04-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenCapturedMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let screen = UIScreen()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange() {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let expectation = self.expectation(description: "Handler called")
            var expectedEvent: ScreenCapturedMonitor.Event?
            let monitor = ScreenCapturedMonitor(screen: screen,
                                                queue: .main) { event in
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
    }

    private func simulateDidChange() {
        if #available(iOS 11.0, tvOS 11.0, *) {
            notificationCenter.post(name: .UIScreenCapturedDidChange,
                                    object: screen)
        }
    }
}
