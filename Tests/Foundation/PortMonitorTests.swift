//
//  PortMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class PortMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let port = Port()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PortMonitor.Event?
        let monitor = PortMonitor(port: port,
                                  queue: .main) { event in
                                    expectedEvent = event
                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeInvalid()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBecomeInvalid(test) = event {
            XCTAssertEqual(test, port)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidBecomeInvalid() {
        notificationCenter.post(name: Port.didBecomeInvalidNotification,
                                object: port)
    }
}
