//
//  StandardLocationMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-22.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import CoreLocation
import XCTest
@testable import XestiMonitors

// swiftlint:disable type_body_length

internal class StandardLocationMonitorTests: XCTestCase {
    let locationManager = MockLocationManager()

    override func setUp() {
        super.setUp()

        LocationManagerInjector.inject = { return self.locationManager }
    }

    #if os(iOS) || os(watchOS)
    func testActivityType_get() {
        if #available(watchOS 4.0, *) {
            let expectedActivityType: CLActivityType = .automotiveNavigation
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            locationManager.activityType = expectedActivityType

            XCTAssertEqual(monitor.activityType, expectedActivityType)
        }
    }
    #endif

    #if os(iOS) || os(watchOS)
    func testActivityType_set() {
        if #available(watchOS 4.0, *) {
            let expectedActivityType: CLActivityType = .fitness
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            monitor.activityType = expectedActivityType

            XCTAssertEqual(locationManager.activityType, expectedActivityType)
        }
    }
    #endif

    #if os(iOS)
    func testAllowDeferredUpdates() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        monitor.startMonitoring()
        monitor.allowDeferredUpdates(untilTraveled: 500,
                                     timeout: 10)

        XCTAssertTrue(locationManager.isLocationUpdatesDeferred)
    }
    #endif

    #if os(iOS) || os(watchOS)
    func testAllowsBackgroundLocationUpdates_get() {
        if #available(watchOS 4.0, *) {
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            locationManager.allowsBackgroundLocationUpdates = true

            XCTAssertTrue(monitor.allowsBackgroundLocationUpdates)
        }
    }
    #endif

    #if os(iOS) || os(watchOS)
    func testAllowsBackgroundLocationUpdates_set() {
        if #available(watchOS 4.0, *) {
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            monitor.allowsBackgroundLocationUpdates = true

            XCTAssertTrue(locationManager.allowsBackgroundLocationUpdates)
        }
    }
    #endif

    #if os(iOS) || os(macOS)
    func testCanDeferUpdates_false() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.updateStandardLocation(canDeferUpdates: false)

        XCTAssertFalse(monitor.canDeferUpdates)
    }
    #endif

    #if os(iOS) || os(macOS)
    func testCanDeferUpdates_true() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.updateStandardLocation(canDeferUpdates: true)

        XCTAssertTrue(monitor.canDeferUpdates)
    }
    #endif

    func testDesiredAccuracy_get() {
        let expectedDesiredAccuracy: CLLocationAccuracy = 123
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.desiredAccuracy = expectedDesiredAccuracy

        XCTAssertEqual(monitor.desiredAccuracy, expectedDesiredAccuracy)
    }

    func testDesiredAccuracy_set() {
        let expectedDesiredAccuracy: CLLocationAccuracy = 321
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        monitor.desiredAccuracy = expectedDesiredAccuracy

        XCTAssertEqual(locationManager.desiredAccuracy, expectedDesiredAccuracy)
    }

    #if os(iOS)
    func testDisallowDeferredUpdates() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        monitor.startMonitoring()
        monitor.allowDeferredUpdates(untilTraveled: 0,
                                     timeout: 0)
        monitor.disallowDeferredUpdates()

        XCTAssertFalse(locationManager.isLocationUpdatesDeferred)
    }
    #endif

    func testDistanceFilter_get() {
        let expectedDistanceFilter: CLLocationDistance = 2_001
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.distanceFilter = expectedDistanceFilter

        XCTAssertEqual(monitor.distanceFilter, expectedDistanceFilter)
    }

    func testDistanceFilter_set() {
        let expectedDistanceFilter: CLLocationDistance = 1_002
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        monitor.distanceFilter = expectedDistanceFilter

        XCTAssertEqual(locationManager.distanceFilter, expectedDistanceFilter)
    }

    func testLocation_nil() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.updateStandardLocation(forceLocation: nil)

        XCTAssertNil(monitor.location)
    }

    func testLocation_nonnil() {
        let expectedLocation = CLLocation()
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.updateStandardLocation(forceLocation: expectedLocation)

        if let location = monitor.location {
            XCTAssertEqual(location, expectedLocation)
        } else {
            XCTFail("Unexpected location")
        }
    }

    #if os(iOS) || os(macOS)
    func testMonitor_didFinishDeferredUpdates_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = makeError()
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateStandardLocation(deferredError: expectedError)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinishDeferredUpdates(maybeError) = event,
            let error = maybeError {
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    #if os(iOS) || os(macOS)
    func testMonitor_didFinishDeferredUpdates_nil() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateStandardLocation(deferredError: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinishDeferredUpdates(error) = event {
            XCTAssertNil(error)
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    #if os(iOS)
    func testMonitor_didPauseUpdates() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.pauseStandardLocationUpdates()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didPauseUpdates = event {
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    #if os(iOS)
    func testMonitor_didResumeUpdates() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.resumeStandardLocationUpdates()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didResumeUpdates = event {
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    #if os(iOS) || os(macOS) || os(watchOS)
    func testMonitor_didUpdate_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = makeError()
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateStandardLocation(error: expectedError)
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
    #endif

    #if os(iOS) || os(macOS) || os(watchOS)
    func testMonitor_didUpdate_location() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLocation = CLLocation()
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        locationManager.updateStandardLocation(expectedLocation)
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
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    func testMonitor_requestLocation() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLocation = CLLocation()
        var expectedEvent: StandardLocationMonitor.Event?
        let monitor = StandardLocationMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.requestLocation()
        locationManager.updateStandardLocation(expectedLocation)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .location(location) = info {
            XCTAssertEqual(location, expectedLocation)
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    #if os(iOS)
    func testPausesLocationUpdatesAutomatically_get() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        locationManager.pausesLocationUpdatesAutomatically = true

        XCTAssertTrue(monitor.pausesLocationUpdatesAutomatically)
    }
    #endif

    #if os(iOS)
    func testPausesLocationUpdatesAutomatically_set() {
        let monitor = StandardLocationMonitor(queue: .main) { _ in }

        monitor.pausesLocationUpdatesAutomatically = true

        XCTAssertTrue(locationManager.pausesLocationUpdatesAutomatically)
    }
    #endif

    #if os(iOS)
    func testShowsBackgroundLocationIndicator_get() {
        if #available(iOS 11.0, *) {
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            locationManager.showsBackgroundLocationIndicator = true

            XCTAssertTrue(monitor.showsBackgroundLocationIndicator)
        }
    }
    #endif

    #if os(iOS)
    func testShowsBackgroundLocationIndicator_set() {
        if #available(iOS 11.0, *) {
            let monitor = StandardLocationMonitor(queue: .main) { _ in }

            monitor.showsBackgroundLocationIndicator = true

            XCTAssertTrue(locationManager.showsBackgroundLocationIndicator)
        }
    }
    #endif

    private func makeError() -> NSError {
        return NSError(domain: "CLErrorDomain",
                       code: CLError.Code.network.rawValue)
    }
}

// swiftlint:enable type_body_length
