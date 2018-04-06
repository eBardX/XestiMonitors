//
//  WindowMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Martin Mungai on 2018-03-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class WindowMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let window = UIWindow()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }

    func testMonitor_didBecomeHidden() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(window: self.window,
                                    options: .didBecomeHidden,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeHidden()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBecomeHidden(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didBecomeKey() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(window: self.window,
                                    options: .didBecomeKey,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeKey()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBecomeKey(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didBecomeVisible() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(window: self.window,
                                    options: .didBecomeVisible,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeVisible()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBecomeVisible(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didResignKey() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(window: self.window,
                                    options: .didResignKey,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidResignKey()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didResignKey(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidBecomeHidden() {
        notificationCenter.post(name: .UIWindowDidBecomeHidden,
                                object: window)
    }

    private func simulateDidBecomeKey() {
        notificationCenter.post(name: .UIWindowDidBecomeKey,
                                object: window)
    }

    private func simulateDidBecomeVisible() {
        notificationCenter.post(name: .UIWindowDidBecomeVisible,
                                object: window)
    }

    private func simulateDidResignKey() {
        notificationCenter.post(name: .UIWindowDidResignKey,
                                object: window)
    }
}
