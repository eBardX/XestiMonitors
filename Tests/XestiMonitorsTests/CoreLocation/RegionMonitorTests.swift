// © 2018–2025 John Gary Pusey (see LICENSE.md)

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class RegionMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(locationManager as any LocationManagerProtocol)
    }

    func testIsActivelyMonitored_false() {
        let monitor = RegionMonitor(region: _makeCircularRegion("bogus")) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.startMonitoring()
        locationManager.stopMonitoring(for: monitor.region)

        XCTAssertFalse(monitor.isActivelyMonitored)
    }

    func testIsActivelyMonitored_true() {
        let monitor = RegionMonitor(region: _makeCircularRegion("bogus")) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        monitor.startMonitoring()

        XCTAssertTrue(monitor.isActivelyMonitored)
    }

    func testIsAvailable_false() {
        let monitor = RegionMonitor(region: _makeCircularRegion("bogus")) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateRegion(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = RegionMonitor(region: _makeCircularRegion("bogus")) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        locationManager.updateRegion(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMaximumMonitoringDistance() {
        let monitor = RegionMonitor(region: _makeCircularRegion("bogus")) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        XCTAssertEqual(monitor.maximumMonitoringDistance, locationManager.maximumRegionMonitoringDistance)
    }

    func testMonitor_error1() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        let expectedError = _makeError()
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(expectedRegion,
                                     error: expectedError)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .error(error, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_error2() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        let expectedError = _makeError()
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(error: expectedError)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .error(error, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_error3() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        let expectedError = _makeError()
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(nil,
                                     error: expectedError)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .error(error, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_regionState_enter() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(enter: expectedRegion)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .regionState(state, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(state, .inside)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_regionState_exit() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(exit: expectedRegion)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .regionState(state, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(state, .outside)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_regionState_request() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        let expectedState = CLRegionState.inside
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.requestState()
        locationManager.updateRegion(state: expectedState)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .regionState(state, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(state, expectedState)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_regionState_start() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = _makeCircularRegion("bogus")
        var expectedEvent: RegionMonitor.Event?
        let monitor = RegionMonitor(region: expectedRegion) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateRegion(start: expectedRegion)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event,
           case let .regionState(state, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertEqual(state, .unknown)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _makeCircularRegion(_ identifier: String) -> CLCircularRegion {
        CLCircularRegion(center: CLLocationCoordinate2DMake(100, 100),
                         radius: 100,
                         identifier: identifier)
    }

    private func _makeError() -> NSError {
        NSError(domain: "CLErrorDomain",
                code: CLError.Code.network.rawValue)
    }
}
