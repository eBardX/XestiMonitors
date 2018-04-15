//
//  VisitMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class VisitMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { return self.locationManager }
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = makeError()
        var expectedEvent: VisitMonitor.Event?
        let monitor = VisitMonitor(queue: .main) { event in
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
        let monitor = VisitMonitor(queue: .main) { event in
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

    private func makeError() -> NSError {
        return NSError(domain: "CLErrorDomain",
                       code: CLError.Code.network.rawValue)
    }
}
