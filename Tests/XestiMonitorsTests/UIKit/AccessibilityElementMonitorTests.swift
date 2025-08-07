// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class AccessibilityElementMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didFinish() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAssistiveTechnology: String? = "VoiceOver"
        let expectedFocusedElement: Any? = UITextField()
        let expectedUnfocusedElement: Any? = UIButton()
        var expectedEvent: AccessibilityElementMonitor.Event?
        let monitor = AccessibilityElementMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFocus(assistiveTechnology: expectedAssistiveTechnology,
                          focusedElement: expectedFocusedElement,
                          unfocusedElement: expectedUnfocusedElement)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didFocus(info) = event {
            XCTAssertEqual(info.assistiveTechnology, expectedAssistiveTechnology)

            if let obj1 = info.focusedElement as AnyObject?,
               let obj2 = expectedFocusedElement as AnyObject? {
                XCTAssert(obj1 === obj2)
            }

            if let obj1 = info.unfocusedElement as AnyObject?,
               let obj2 = expectedUnfocusedElement as AnyObject? {
                XCTAssert(obj1 === obj2)
            }
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didFinish_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAssistiveTechnology: String? = nil
        let expectedFocusedElement: Any? = nil
        let expectedUnfocusedElement: Any? = nil
        var expectedEvent: AccessibilityElementMonitor.Event?
        let monitor = AccessibilityElementMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFocus(assistiveTechnology: expectedAssistiveTechnology,
                          focusedElement: expectedFocusedElement,
                          unfocusedElement: expectedUnfocusedElement,
                          badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didFocus(info) = event {
            XCTAssertEqual(info.assistiveTechnology, expectedAssistiveTechnology)

            if let obj1 = info.focusedElement as AnyObject?,
               let obj2 = expectedFocusedElement as AnyObject? {
                XCTAssert(obj1 === obj2)
            }

            if let obj1 = info.unfocusedElement as AnyObject?,
               let obj2 = expectedUnfocusedElement as AnyObject? {
                XCTAssert(obj1 === obj2)
            }
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidFocus(assistiveTechnology: String?,
                                   focusedElement: Any?,
                                   unfocusedElement: Any?,
                                   badUserInfo: Bool = false) {
        var userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [:]

            if let value = assistiveTechnology {
                userInfo?[UIAccessibility.assistiveTechnologyUserInfoKey] = value
            }

            if let value = focusedElement {
                userInfo?[UIAccessibility.focusedElementUserInfoKey] = value
            }

            if let value = unfocusedElement {
                userInfo?[UIAccessibility.unfocusedElementUserInfoKey] = value
            }
        }

        notificationCenter.post(name: UIAccessibility.elementFocusedNotification,
                                object: nil,
                                userInfo: userInfo)
    }
}
