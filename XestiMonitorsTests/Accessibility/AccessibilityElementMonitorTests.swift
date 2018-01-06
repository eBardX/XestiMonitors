//
//  AccessibilityElementMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class AccessibilityElementMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    func testMonitor_didFinish() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAssistiveTechnology: String? = "VoiceOver"
        let expectedFocusedElement: Any? = UITextField()
        let expectedUnfocusedElement: Any? = UIButton()
        var expectedEvent: AccessibilityElementMonitor.Event?
        let monitor = AccessibilityElementMonitor(notificationCenter: notificationCenter,
                                                  queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFocus(assistiveTechnology: expectedAssistiveTechnology,
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
        let monitor = AccessibilityElementMonitor(notificationCenter: notificationCenter,
                                                  queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFocus(assistiveTechnology: expectedAssistiveTechnology,
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

    private func simulateDidFocus(assistiveTechnology: String?,
                                  focusedElement: Any?,
                                  unfocusedElement: Any?,
                                  badUserInfo: Bool = false) {
        var userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [:]

            if let value = assistiveTechnology {
                userInfo?[UIAccessibilityAssistiveTechnologyKey] = value
            }

            if let value = focusedElement {
                userInfo?[UIAccessibilityFocusedElementKey] = value
            }

            if let value = unfocusedElement {
                userInfo?[UIAccessibilityUnfocusedElementKey] = value
            }
        }

        notificationCenter.post(name: .UIAccessibilityElementFocused,
                                object: nil,
                                userInfo: userInfo)
    }
}
