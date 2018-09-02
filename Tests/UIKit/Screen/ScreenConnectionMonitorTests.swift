//
//  ScreenConnectionMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-04-04.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenConnectionMonitorTest: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let screen = UIScreen()

    override func setUp() {
        super.setUp()
        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didConnect() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenConnectionMonitor.Event?
        let monitor = ScreenConnectionMonitor(options: .didConnect,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidConnect()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didConnect(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didDisconnect() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenConnectionMonitor.Event?
        let monitor = ScreenConnectionMonitor(options: .didDisconnect,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidDisconnect()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didDisconnect(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidConnect() {
        notificationCenter.post(name: .UIScreenDidConnect,
                                object: screen)
    }

    private func simulateDidDisconnect() {
        notificationCenter.post(name: .UIScreenDidDisconnect,
                                object: screen)
    }
}
