//
//  AccessibilityAnnouncementMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class AccessibilityAnnouncementMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didFinish() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStringValue: String = "This is a test"
        let expectedWasSuccessful: Bool = true
        var expectedEvent: AccessibilityAnnouncementMonitor.Event?
        let monitor = AccessibilityAnnouncementMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFinish(stringValue: expectedStringValue,
                          wasSuccessful: expectedWasSuccessful)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinish(info) = event {
            XCTAssertEqual(info.stringValue, expectedStringValue)
            XCTAssertEqual(info.wasSuccessful, expectedWasSuccessful)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didFinish_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStringValue: String = " "
        let expectedWasSuccessful: Bool = false
        var expectedEvent: AccessibilityAnnouncementMonitor.Event?
        let monitor = AccessibilityAnnouncementMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFinish(stringValue: expectedStringValue,
                          wasSuccessful: expectedWasSuccessful,
                          badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinish(info) = event {
            XCTAssertEqual(info.stringValue, expectedStringValue)
            XCTAssertEqual(info.wasSuccessful, expectedWasSuccessful)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidFinish(stringValue: String,
                                   wasSuccessful: Bool,
                                   badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIAccessibility.announcementStringValueUserInfoKey: stringValue,
                        UIAccessibility.announcementWasSuccessfulUserInfoKey: NSNumber(value: wasSuccessful)]
        }

        notificationCenter.post(name: UIAccessibility.announcementDidFinishNotification,
                                object: nil,
                                userInfo: userInfo)
    }
}
