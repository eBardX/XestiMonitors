//
//  ScreenshotMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenshotMonitorTests: XCTestCase {
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        ApplicationInjector.inject = { return self.application }

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_userDidTake() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenshotMonitor.Event?
        let monitor = ScreenshotMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateUserDidTake()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .userDidTake)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateUserDidTake() {
        notificationCenter.post(name: .UIApplicationUserDidTakeScreenshot,
                                object: application)
    }
}
