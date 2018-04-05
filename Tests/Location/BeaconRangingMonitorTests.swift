//
//  BeaconRangingMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import XCTest
@testable import XestiMonitors

internal class BeaconRangingMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { return self.locationManager }
    }

    func testIsActivelyRanged_false() {
        let monitor = BeaconRangingMonitor(region: makeBeaconRegion("bogus"),
                                           queue: .main) { _ in }

        monitor.startMonitoring()
        locationManager.stopRangingBeacons(in: monitor.region)

        XCTAssertFalse(monitor.isActivelyRanged)
    }

    func testIsActivelyRanged_true() {
        let monitor = BeaconRangingMonitor(region: makeBeaconRegion("bogus"),
                                           queue: .main) { _ in }

        monitor.startMonitoring()

        XCTAssertTrue(monitor.isActivelyRanged)
    }

    func testIsAvailable_false() {
        let monitor = BeaconRangingMonitor(region: makeBeaconRegion("bogus"),
                                           queue: .main) { _ in }

        locationManager.updateBeaconRanging(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = BeaconRangingMonitor(region: makeBeaconRegion("bogus"),
                                           queue: .main) { _ in }

        locationManager.updateBeaconRanging(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_beacons() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = makeBeaconRegion("bogus")
        var expectedEvent: BeaconRangingMonitor.Event?
        let monitor = BeaconRangingMonitor(region: expectedRegion,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateBeaconRanging(beacons: [],
                                            in: expectedRegion)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .beacons(beacons, region) = info {
            XCTAssertEqual(region, expectedRegion)
            XCTAssertTrue(beacons.isEmpty)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_error1() {
        let expectation = self.expectation(description: "Handler called")
        let expectedRegion = makeBeaconRegion("bogus")
        let expectedError = makeError()
        var expectedEvent: BeaconRangingMonitor.Event?
        let monitor = BeaconRangingMonitor(region: expectedRegion,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateBeaconRanging(error: expectedError,
                                            for: expectedRegion)
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
        let expectedRegion = makeBeaconRegion("bogus")
        let expectedError = makeError()
        var expectedEvent: BeaconRangingMonitor.Event?
        let monitor = BeaconRangingMonitor(region: expectedRegion,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateBeaconRanging(error: expectedError)
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

    private func makeBeaconRegion(_ identifier: String) -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: UUID(),
                              identifier: identifier)
    }

    private func makeError() -> NSError {
        return NSError(domain: "CLErrorDomain",
                       code: CLError.Code.network.rawValue)
    }
}
