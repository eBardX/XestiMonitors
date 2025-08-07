// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class VisitMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { self.locationManager }
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = _makeError()
        var expectedEvent: VisitMonitor.Event?
        let monitor = VisitMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateVisit(error: expectedError)
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

    func testMonitor_visit() {
        let expectation = self.expectation(description: "Handler called")
        let expectedVisit = CLVisit()
        var expectedEvent: VisitMonitor.Event?
        let monitor = VisitMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateVisit(expectedVisit)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .visit(visit) = info {
            XCTAssertEqual(visit, expectedVisit)
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
