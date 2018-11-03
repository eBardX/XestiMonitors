//
//  SignificantLocationMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class SignificantLocationMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { self.locationManager }
    }

    func testIsAvailable_false() {
        let monitor = SignificantLocationMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateSignificantLocation(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = SignificantLocationMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateSignificantLocation(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = makeError()
        var expectedEvent: SignificantLocationMonitor.Event?
        let monitor = SignificantLocationMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateSignificantLocation(error: expectedError)
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

    func testMonitor_location() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLocation = CLLocation()
        var expectedEvent: SignificantLocationMonitor.Event?
        let monitor = SignificantLocationMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateSignificantLocation(expectedLocation)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .location(location) = info {
            XCTAssertEqual(location, expectedLocation)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func makeError() -> NSError {
        return NSError(domain: "CLErrorDomain",
                       code: CLError.Code.network.rawValue)
    }
}
