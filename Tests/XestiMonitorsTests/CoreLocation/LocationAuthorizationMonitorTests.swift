// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class LocationAuthorizationMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(locationManager as any LocationManagerProtocol)
    }

    func testIsEnabled_false() {
        let monitor = LocationAuthorizationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateLocationServices(enabled: false)

        XCTAssertFalse(monitor.isEnabled)
    }

    func testIsEnabled_true() {
        let monitor = LocationAuthorizationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateLocationServices(enabled: true)

        XCTAssertTrue(monitor.isEnabled)
    }

#if os(iOS) || os(watchOS)
    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = _makeError()
        var expectedEvent: LocationAuthorizationMonitor.Event?
        let monitor = LocationAuthorizationMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.requestAlways()
        locationManager.updateAuthorization(error: expectedError)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .error(error) = info {
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }
#endif

#if os(iOS) || os(watchOS)
    func testMonitor_status_always() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStatus = CLAuthorizationStatus.authorizedAlways
        var expectedEvent: LocationAuthorizationMonitor.Event?
        let monitor = LocationAuthorizationMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.requestAlways()
        locationManager.updateAuthorization(status: expectedStatus)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .status(status) = info {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }
    }
#endif

    func testMonitor_status_denied() {
        let expectedStatus = CLAuthorizationStatus.denied
        let monitor = LocationAuthorizationMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateAuthorization(forceStatus: expectedStatus)

        XCTAssertEqual(monitor.status, expectedStatus)
    }

#if os(iOS) || os(tvOS) || os(watchOS)
    func testMonitor_status_whenInUse() {
        let expectation = self.expectation(description: "Handler called")
        let expectedStatus = CLAuthorizationStatus.authorizedWhenInUse
        var expectedEvent: LocationAuthorizationMonitor.Event?
        let monitor = LocationAuthorizationMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.requestWhenInUse()
        locationManager.updateAuthorization(status: expectedStatus)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .status(status) = info {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }
    }
#endif

    // MARK: Private Instance Methods

    private func _makeError() -> NSError {
        NSError(domain: "CLErrorDomain",
                code: CLError.Code.network.rawValue)
    }
}
