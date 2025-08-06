// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class AccessibilityAnnouncementMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didFinish() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStringValue: String = "This is a test"
        let expectedWasSuccessful: Bool = true
        var expectedEvent: AccessibilityAnnouncementMonitor.Event?
        let monitor = AccessibilityAnnouncementMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFinish(stringValue: expectedStringValue,
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
        let monitor = AccessibilityAnnouncementMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFinish(stringValue: expectedStringValue,
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

    // MARK: Private Instance Methods

    private func _simulateDidFinish(stringValue: String,
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
