//
//  ApplicationStateMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ApplicationStateMonitorTests: XCTestCase {
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        ApplicationInjector.inject = { return self.application }

        application.applicationState = .inactive

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didBecomeActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .didBecomeActive,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didBecomeActive = event {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didEnterBackground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .didEnterBackground,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidEnterBackground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didEnterBackground = event {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didFinishLaunching() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .didFinishLaunching,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFinishLaunching()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinishLaunching(options) = event {
            XCTAssertNil(options)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willEnterForeground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .willEnterForeground,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillEnterForeground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willEnterForeground = event {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willResignActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .willResignActive,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillResignActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willResignActive = event {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willTerminate() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .willTerminate,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillTerminate()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willTerminate = event {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testState() {
        let expectedState: UIApplicationState = .background
        let monitor = ApplicationStateMonitor(options: .didEnterBackground,
                                              queue: .main) { _ in }

        simulateDidEnterBackground()

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateDidBecomeActive() {
        application.applicationState = .active

        notificationCenter.post(name: .UIApplicationDidBecomeActive,
                                object: application)
    }

    private func simulateDidEnterBackground() {
        application.applicationState = .background

        notificationCenter.post(name: .UIApplicationDidEnterBackground,
                                object: application)
    }

    private func simulateDidFinishLaunching() {
        notificationCenter.post(name: .UIApplicationDidFinishLaunching,
                                object: application)
    }

    private func simulateWillEnterForeground() {
        notificationCenter.post(name: .UIApplicationWillEnterForeground,
                                object: application)
    }

    private func simulateWillResignActive() {
        notificationCenter.post(name: .UIApplicationWillResignActive,
                                object: application)
    }

    private func simulateWillTerminate() {
        notificationCenter.post(name: .UIApplicationWillTerminate,
                                object: application)
    }
}
