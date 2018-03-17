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

    func testMonitor_contentsDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let expectedTypesAdded = ["String"]
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .didChange,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange(contents: expectedTypesAdded)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(info) = event {
            XCTAssertEqual(info.typesAdded, expectedTypesAdded)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_contentsDidRemove() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let expectedTypesRemoved = ["String"]
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .didRemove,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidRemove(contents: expectedTypesRemoved)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didRemove(info) = event {
            XCTAssertEqual(info.typesRemoved, expectedTypesRemoved)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidChange(contents: [String]) {
        let userInfo: [AnyHashable: Any]?

        userInfo = makeUserInfo(typesAdded: contents,
                                typesRemoved: nil)

        notificationCenter.post(name: .UIPasteboardChanged,
                                object: pasteboard,
                                userInfo: userInfo)
    }

    private func simulateDidRemove(contents: [String]) {
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
