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
    let notificationCenter = MockNotificationCenter()
    let extensionHost = NSExtensionContext()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didBecomeActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(extensionHost: self.extensionHost,
                                           options: .didBecomeActive,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didBecomeActive(test) = event {
            XCTAssertEqual(test, extensionHost)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didEnterBackground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(extensionHost: self.extensionHost,
                                           options: .didEnterBackground,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidEnterBackground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didEnterBackground(test) = event {
            XCTAssertEqual(test, extensionHost)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willEnterForeground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(extensionHost: self.extensionHost,
                                           options: .willEnterForeground,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillEnterForeground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willEnterForeground(test) = event {
            XCTAssertEqual(test, extensionHost)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willResignActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ExtensionHostMonitor.Event?
        let monitor = ExtensionHostMonitor(extensionHost: self.extensionHost,
                                           options: .willResignActive,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillResignActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willResignActive(test) = event {
            XCTAssertEqual(test, extensionHost)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidBecomeActive() {
        notificationCenter.post(name: .NSExtensionHostDidBecomeActive,
                                object: extensionHost)
    }

    private func simulateDidEnterBackground() {
        notificationCenter.post(name: .NSExtensionHostDidEnterBackground,
                                object: extensionHost)
    }

    private func simulateWillEnterForeground() {
        notificationCenter.post(name: .NSExtensionHostWillEnterForeground,
                                object: extensionHost)
    }

    private func simulateWillResignActive() {
        notificationCenter.post(name: .NSExtensionHostWillResignActive,
                                object: extensionHost)
    }
}
