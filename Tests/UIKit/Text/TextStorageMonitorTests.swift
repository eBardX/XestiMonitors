//
//  TextStorageMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-04-24.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class TextStorageMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let textStorage = NSTextStorage()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didProcessEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextStorageMonitor.Event?
        let monitor = TextStorageMonitor(textStorage: textStorage,
                                         options: .didProcessEditing,
                                         queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidProcessEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didProcessEditing(test) = event {
            XCTAssertEqual(test, textStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willProcessEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextStorageMonitor.Event?
        let monitor = TextStorageMonitor(textStorage: textStorage,
                                         options: .willProcessEditing,
                                         queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillProcessEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willProcessEditing(test) = event {
            XCTAssertEqual(test, textStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidProcessEditing() {
        notificationCenter.post(name: NSTextStorage.didProcessEditingNotification,
                                object: textStorage)
    }

    private func simulateWillProcessEditing() {
        notificationCenter.post(name: NSTextStorage.willProcessEditingNotification,
                                object: textStorage)
    }
}
