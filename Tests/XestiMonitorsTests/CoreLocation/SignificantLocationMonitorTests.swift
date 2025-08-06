// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class SignificantLocationMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(locationManager as any LocationManagerProtocol)
    }

    func testIsAvailable_false() {
        let monitor = SignificantLocationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateSignificantLocation(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = SignificantLocationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateSignificantLocation(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = _makeError()
        var expectedEvent: SignificantLocationMonitor.Event?
        let monitor = SignificantLocationMonitor { event in
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
        let monitor = SignificantLocationMonitor { event in
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

    // MARK: Private Instance Methods

    private func _makeError() -> NSError {
        NSError(domain: "CLErrorDomain",
                code: CLError.Code.network.rawValue)
    }
}
