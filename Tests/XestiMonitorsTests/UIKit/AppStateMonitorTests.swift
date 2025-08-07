// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ApplicationStateMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        AppInjector.inject = { self.app }

        app.applicationState = .inactive

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didBecomeActive() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBecomeActive()
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
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidEnterBackground()
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
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFinishLaunching()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didFinishLaunching(launchOptions) = event {
            XCTAssertNil(launchOptions)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willEnterForeground() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillEnterForeground()
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
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillResignActive()
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
        var expectedEvent: AppStateMonitor.Event?
        let monitor = AppStateMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillTerminate()
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
        let monitor = AppStateMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateDidEnterBackground()

        XCTAssertEqual(monitor.state, expectedState)
    }

    private func _simulateDidBecomeActive() {
        app.applicationState = .active

        notificationCenter.post(name: UIApplication.didBecomeActiveNotification,
                                object: app)
    }

    // MARK: Private Instance Methods

    private func _simulateDidEnterBackground() {
        app.applicationState = .background

        notificationCenter.post(name: UIApplication.didEnterBackgroundNotification,
                                object: app)
    }

    private func _simulateDidFinishLaunching() {
        notificationCenter.post(name: UIApplication.didFinishLaunchingNotification,
                                object: app)
    }

    private func _simulateWillEnterForeground() {
        notificationCenter.post(name: UIApplication.willEnterForegroundNotification,
                                object: app)
    }

    private func _simulateWillResignActive() {
        notificationCenter.post(name: UIApplication.willResignActiveNotification,
                                object: app)
    }

    private func _simulateWillTerminate() {
        notificationCenter.post(name: UIApplication.willTerminateNotification,
                                object: app)
    }
}
