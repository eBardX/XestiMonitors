//
//  PasteboardMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-03-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class PasteboardMonitorTests: XCTestCase {
    let pasteboard = MockPasteboard()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }

    func testMonitor_contentsChanged() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let expectedTypesAdded = ["String"]
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .changed,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged(contents: expectedTypesAdded)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .changed(info) = event {
            XCTAssertEqual(info.typesAdded, expectedTypesAdded)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_contentsRemoved() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let expectedTypesRemoved = ["String"]
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .removed,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateRemoved(contents: expectedTypesRemoved)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .removed(board) = event {
            XCTAssertEqual(board, pasteboard)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateChanged(contents: [String]) {
        let userInfo: [AnyHashable: Any]?

        userInfo = makeUserInfo(typesAdded: contents,
                                typesRemoved: nil)

        notificationCenter.post(name: .UIPasteboardChanged,
                                object: pasteboard,
                                userInfo: userInfo)
    }

    private func simulateRemoved(contents: [String]) {
        let userInfo: [AnyHashable: Any]?

        userInfo = makeUserInfo(typesAdded: nil,
                                typesRemoved: contents)

        notificationCenter.post(name: .UIPasteboardRemoved,
                                object: pasteboard,
                                userInfo: userInfo)
    }

    private func makeUserInfo(typesAdded: [String]?,
                              typesRemoved: [String]?) -> [AnyHashable: Any] {
        var userInfo: [AnyHashable: Any] = [:]

        if let typesAdded = typesAdded {
            userInfo[UIPasteboardChangedTypesAddedKey] = typesAdded
        }

        if let typesRemoved = typesRemoved {
            userInfo[UIPasteboardChangedTypesRemovedKey] = typesRemoved
        }

        return userInfo
    }
}
