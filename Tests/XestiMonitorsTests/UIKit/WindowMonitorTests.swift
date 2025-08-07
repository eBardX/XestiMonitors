// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class WindowMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let window = UIWindow()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didBecomeHidden() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(window: window) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeHidden()
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
        let monitor = WindowMonitor(window: window) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeKey()
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
        let monitor = WindowMonitor(window: window) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeVisible()
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
        let monitor = WindowMonitor(window: window) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidResignKey()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didResignKey(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBecomeHidden() {
        notificationCenter.post(name: UIWindow.didBecomeHiddenNotification,
                                object: window)
    }

    private func _simulateDidBecomeKey() {
        notificationCenter.post(name: UIWindow.didBecomeKeyNotification,
                                object: window)
    }

    private func _simulateDidBecomeVisible() {
        notificationCenter.post(name: UIWindow.didBecomeVisibleNotification,
                                object: window)
    }

    private func _simulateDidResignKey() {
        notificationCenter.post(name: UIWindow.didResignKeyNotification,
                                object: window)
    }
}
