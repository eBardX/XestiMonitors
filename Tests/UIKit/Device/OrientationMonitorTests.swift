//
//  OrientationMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class OrientationMonitorTests: XCTestCase {
    let device = MockDevice()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DeviceInjector.inject = { self.device }

        device.orientation = .unknown

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedOrientation: UIDeviceOrientation = .portrait
        var expectedEvent: OrientationMonitor.Event?
        let monitor = OrientationMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange(to: expectedOrientation)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(orientation) = event {
            XCTAssertEqual(orientation, expectedOrientation)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testOrientation() {
        let expectedOrientation: UIDeviceOrientation = .landscapeRight
        let monitor = OrientationMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateDidChange(to: expectedOrientation)

        XCTAssertEqual(monitor.orientation, expectedOrientation)
    }

    private func simulateDidChange(to orientation: UIDeviceOrientation) {
        device.orientation = orientation

        notificationCenter.post(name: UIDevice.orientationDidChangeNotification,
                                object: device)
    }
}
