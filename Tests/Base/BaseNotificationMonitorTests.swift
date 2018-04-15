//
//  BaseNotificationMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-04-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class BaseNotificationMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let notificationName = Notification.Name(rawValue: "Bogus")
    let notificationObject = NSObject()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_notificationFired() {
        let expectation = self.expectation(description: "Block called")
        var expectedNotification: Notification?
        let monitor = BaseNotificationMonitor(queue: .main)

        monitor.observe(notificationName,
                        object: notificationObject) { notification in
                            expectedNotification = notification
                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateNotificationFired()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let notification = expectedNotification {
            XCTAssertEqual(notification.name, notificationName)
            XCTAssertEqual(notification.object as? NSObject, notificationObject)
        } else {
            XCTFail("Unexpected notification")
        }
    }

    private func simulateNotificationFired() {
        notificationCenter.post(name: notificationName,
                                object: notificationObject)
    }
}
