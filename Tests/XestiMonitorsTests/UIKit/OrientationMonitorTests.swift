// © 2017–2025 John Gary Pusey (see LICENSE.md)

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
        let monitor = OrientationMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange(to: expectedOrientation)
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
        let monitor = OrientationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateDidChange(to: expectedOrientation)

        XCTAssertEqual(monitor.orientation, expectedOrientation)
    }

    // MARK: Private Instance Methods

    private func _simulateDidChange(to orientation: UIDeviceOrientation) {
        device.orientation = orientation

        notificationCenter.post(name: UIDevice.orientationDidChangeNotification,
                                object: device)
    }
}
