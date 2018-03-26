//
//  TextViewMonitorTests.swift
//  XestiMonitorsTests-iOS
//
//  Created by kayeli dennis on 2018-03-27.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

class TextViewMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let textview = UITextView()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }

    func testMonitor_didBeginEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textview: self.textview,
                                    options: .didBeginEditing,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBeginEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBeginEditing(view) = event {
            XCTAssertEqual(view, textview)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didEndEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textview: self.textview,
                                      options: .didEndEditing,
                                      queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidEndEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didEndEditing(view) = event {
            XCTAssertEqual(view, textview)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_textDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textview: self.textview,
                                      options: .textDidChange,
                                      queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .textDidChange(view) = event {
            XCTAssertEqual(view, textview)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidBeginEditing() {
        notificationCenter.post(name: .UITextViewTextDidBeginEditing,
                                object: textview)
    }

    private func simulateDidEndEditing() {
        notificationCenter.post(name: .UITextViewTextDidEndEditing,
                                object: textview)
    }

    private func simulateDidChange() {
        notificationCenter.post(name: .UITextViewTextDidChange,
                                object: textview)
    }
}
