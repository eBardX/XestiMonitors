// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let screen = UIScreen()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_brightnessDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenMonitor.Event?
        let monitor = ScreenMonitor(screen: screen) { event  in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateBrightnessDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .brightnessDidChange(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_capturedDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenMonitor.Event?
        let monitor = ScreenMonitor(screen: screen) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateCapturedDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .capturedDidChange(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_modeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenMonitor.Event?
        let monitor = ScreenMonitor(screen: screen) { event  in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateModeDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .modeDidChange(test) = event {
            XCTAssertEqual(test, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateBrightnessDidChange() {
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification,
                                object: screen)
    }

    private func _simulateCapturedDidChange() {
        notificationCenter.post(name: UIScreen.capturedDidChangeNotification,
                                object: screen)
    }

    private func _simulateModeDidChange() {
        notificationCenter.post(name: UIScreen.modeDidChangeNotification,
                                object: screen)
    }
}
