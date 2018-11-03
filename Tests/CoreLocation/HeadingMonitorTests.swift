//
//  HeadingMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class HeadingMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { self.locationManager }
    }

    func testDismissCalibrationDisplay() {
        locationManager.hideHeadingCalibrationDisplay()

        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.shouldDisplayCalibration = true

        locationManager.showHeadingCalibrationDisplay()

        monitor.dismissCalibrationDisplay()

        XCTAssertFalse(locationManager.isHeadingCalibrationDisplayVisible)
    }

    func testFilter_get() {
        let expectedFilter: CLLocationDegrees = 13
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.headingFilter = expectedFilter

        XCTAssertEqual(monitor.filter, expectedFilter)
    }

    func testFilter_set() {
        let expectedFilter: CLLocationDegrees = 31
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.filter = expectedFilter

        XCTAssertEqual(locationManager.headingFilter, expectedFilter)
    }

    func testHeading_nil() {
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateHeading(forceHeading: nil)

        XCTAssertNil(monitor.heading)
    }

    func testHeading_nonnil() {
        let expectedHeading = CLHeading()
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateHeading(forceHeading: expectedHeading)

        if let heading = monitor.heading {
            XCTAssertEqual(heading, expectedHeading)
        } else {
            XCTFail("Unexpected heading")
        }
    }

    func testIsAvailable_false() {
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateHeading(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateHeading(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = makeError()
        var expectedEvent: HeadingMonitor.Event?
        let monitor = HeadingMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateHeading(error: expectedError)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .error(error) = info {
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_heading() {
        let expectation = self.expectation(description: "Handler called")
        let expectedHeading = CLHeading()
        var expectedEvent: HeadingMonitor.Event?
        let monitor = HeadingMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateHeading(expectedHeading)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .heading(heading) = info {
            XCTAssertEqual(heading, expectedHeading)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testOrientation_get() {
        let expectedOrientation: CLDeviceOrientation = .landscapeLeft
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.headingOrientation = expectedOrientation

        XCTAssertEqual(monitor.orientation, expectedOrientation)
    }

    func testOrientation_set() {
        let expectedOrientation: CLDeviceOrientation = .landscapeRight
        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.orientation = expectedOrientation

        XCTAssertEqual(locationManager.headingOrientation, expectedOrientation)
    }

    func testShouldDisplayCalibration_false() {
        locationManager.hideHeadingCalibrationDisplay()

        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.shouldDisplayCalibration = false

        locationManager.showHeadingCalibrationDisplay()

        XCTAssertFalse(locationManager.isHeadingCalibrationDisplayVisible)
    }

    func testShouldDisplayCalibration_true() {
        locationManager.hideHeadingCalibrationDisplay()

        let monitor = HeadingMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.shouldDisplayCalibration = true

        locationManager.showHeadingCalibrationDisplay()

        XCTAssertTrue(locationManager.isHeadingCalibrationDisplayVisible)
    }

    private func makeError() -> NSError {
        return NSError(domain: "CLErrorDomain",
                       code: CLError.Code.network.rawValue)
    }
}
