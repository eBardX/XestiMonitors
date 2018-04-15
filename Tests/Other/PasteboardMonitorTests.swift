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
    let pasteboard = UIPasteboard(name: UIPasteboardName("bogus"),
                                  create: true) ?? .general
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }

    func testMonitor_changed1() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let expectedTypesAdded = ["a", "b", "c"]
        let expectedTypesRemoved = ["d", "e"]
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .changed,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged(typesAdded: expectedTypesAdded,
                        typesRemoved: expectedTypesRemoved)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .changed(pb, changes) = event {
            XCTAssertEqual(pb, pasteboard)
            XCTAssertEqual(changes.typesAdded, expectedTypesAdded)
            XCTAssertEqual(changes.typesRemoved, expectedTypesRemoved)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_changed2() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .changed,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged(typesAdded: nil,
                        typesRemoved: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .changed(pb, changes) = event {
            XCTAssertEqual(pb, pasteboard)
            XCTAssertEqual(changes.typesAdded, [])
            XCTAssertEqual(changes.typesRemoved, [])
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_removed() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        options: .removed,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateRemoved()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .removed(pb) = event {
            XCTAssertEqual(pb, pasteboard)
        } else {
            XCTFail("Unexpected Event")
        }
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

    private func simulateChanged(typesAdded: [String]?,
                                 typesRemoved: [String]?) {
        let userInfo = makeUserInfo(typesAdded: typesAdded,
                                    typesRemoved: typesRemoved)

        notificationCenter.post(name: .UIPasteboardChanged,
                                object: pasteboard,
                                userInfo: userInfo)
    }

    private func simulateRemoved() {
        notificationCenter.post(name: .UIPasteboardRemoved,
                                object: pasteboard,
                                userInfo: nil)
    }
}
