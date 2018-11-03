//
//  ExtensionHostMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Rose Maina on 2018-05-16.
//
// © 2018 J. G. Pusey (see LICENSE.md)
//

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
        let monitor = ExtensionHostMonitor(context: context,
                                           options: .didBecomeActive,
                                           queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeActive()
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
        let monitor = ExtensionHostMonitor(context: context,
                                           options: .didEnterBackground,
                                           queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidEnterBackground()
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
        let monitor = ExtensionHostMonitor(context: context,
                                           options: .willEnterForeground,
                                           queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillEnterForeground()
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
        let monitor = ExtensionHostMonitor(context: context,
                                           options: .willResignActive,
                                           queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillResignActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willResignActive(test) = event {
            XCTAssertEqual(test, context)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidBecomeActive() {
        notificationCenter.post(name: .NSExtensionHostDidBecomeActive,
                                object: context)
    }

    private func simulateDidEnterBackground() {
        notificationCenter.post(name: .NSExtensionHostDidEnterBackground,
                                object: context)
    }

    private func simulateWillEnterForeground() {
        notificationCenter.post(name: .NSExtensionHostWillEnterForeground,
                                object: context)
    }

    private func simulateWillResignActive() {
        notificationCenter.post(name: .NSExtensionHostWillResignActive,
                                object: context)
    }
}
