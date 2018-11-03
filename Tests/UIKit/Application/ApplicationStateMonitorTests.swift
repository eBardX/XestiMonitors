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

        ApplicationInjector.inject = { self.application }

        application.applicationState = .inactive

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didBecomeActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(options: .didBecomeActive,
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
                                                XCTAssertEqual(OperationQueue.current, .main)

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
                                                XCTAssertEqual(OperationQueue.current, .main)

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
                                                XCTAssertEqual(OperationQueue.current, .main)

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
                                                XCTAssertEqual(OperationQueue.current, .main)

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
        let expectedState: UIApplication.State = .background
        let monitor = ApplicationStateMonitor(options: .didEnterBackground,
                                              queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateDidEnterBackground()

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func simulateDidBecomeActive() {
        application.applicationState = .active

        notificationCenter.post(name: UIApplication.didBecomeActiveNotification,
                                object: application)
    }

    private func simulateDidEnterBackground() {
        application.applicationState = .background

        notificationCenter.post(name: UIApplication.didEnterBackgroundNotification,
                                object: application)
    }

    private func simulateDidFinishLaunching() {
        notificationCenter.post(name: UIApplication.didFinishLaunchingNotification,
                                object: application)
    }

    private func simulateWillEnterForeground() {
        notificationCenter.post(name: UIApplication.willEnterForegroundNotification,
                                object: application)
    }

    private func simulateWillResignActive() {
        notificationCenter.post(name: UIApplication.willResignActiveNotification,
                                object: application)
    }

    private func simulateWillTerminate() {
        notificationCenter.post(name: UIApplication.willTerminateNotification,
                                object: application)
    }
}
