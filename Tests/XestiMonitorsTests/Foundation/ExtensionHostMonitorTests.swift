// © 2018–2025 John Gary Pusey (see LICENSE.md)

import XCTest
@testable import XestiMonitors

internal class ExtensionHostMonitorTests: XCTestCase {
    let context = NSExtensionContext()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didBecomeActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(context: context) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didBecomeActive(test) = event {
            XCTAssertEqual(test, context)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didEnterBackground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(context: context) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidEnterBackground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didEnterBackground(test) = event {
            XCTAssertEqual(test, context)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willEnterForeground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(context: context) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillEnterForeground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .willEnterForeground(test) = event {
            XCTAssertEqual(test, context)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willResignActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(context: context) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillResignActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .willResignActive(test) = event {
            XCTAssertEqual(test, context)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBecomeActive() {
        notificationCenter.post(name: .NSExtensionHostDidBecomeActive,
                                object: context)
    }

    private func _simulateDidEnterBackground() {
        notificationCenter.post(name: .NSExtensionHostDidEnterBackground,
                                object: context)
    }

    private func _simulateWillEnterForeground() {
        notificationCenter.post(name: .NSExtensionHostWillEnterForeground,
                                object: context)
    }

    private func _simulateWillResignActive() {
        notificationCenter.post(name: .NSExtensionHostWillResignActive,
                                object: context)
    }
}
