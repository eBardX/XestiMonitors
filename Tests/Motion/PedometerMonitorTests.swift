//
//  PedometerMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class PedometerMonitorTests: XCTestCase {
    let pedometer = MockPedometer()

    override func setUp() {
        super.setUp()

        PedometerInjector.pedometer = pedometer
    }

    func testIsCadenceAvailable_false() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(cadenceAvailable: false)

        XCTAssertFalse(monitor.isCadenceAvailable)
    }

    func testIsCadenceAvailable_true() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(cadenceAvailable: true)

        XCTAssertTrue(monitor.isCadenceAvailable)
    }

    func testIsDistanceAvailable_false() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(distanceAvailable: false)

        XCTAssertFalse(monitor.isDistanceAvailable)
    }

    func testIsDistanceAvailable_true() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(distanceAvailable: true)

        XCTAssertTrue(monitor.isDistanceAvailable)
    }

    func testIsFloorCountingAvailable_false() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(floorCountingAvailable: false)

        XCTAssertFalse(monitor.isFloorCountingAvailable)
    }

    func testIsFloorCountingAvailable_true() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(floorCountingAvailable: true)

        XCTAssertTrue(monitor.isFloorCountingAvailable)
    }

    func testIsPaceAvailable_false() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(paceAvailable: false)

        XCTAssertFalse(monitor.isPaceAvailable)
    }

    func testIsPaceAvailable_true() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(paceAvailable: true)

        XCTAssertTrue(monitor.isPaceAvailable)
    }

    func testIsStepCountingAvailable_false() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(stepCountingAvailable: false)

        XCTAssertFalse(monitor.isStepCountingAvailable)
    }

    func testIsStepCountingAvailable_true() {
        let monitor = PedometerMonitor(queue: .main) { _ in }

        pedometer.updatePedometer(stepCountingAvailable: true)

        XCTAssertTrue(monitor.isStepCountingAvailable)
    }

    func testMonitor_data() {
        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMPedometerData()
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        pedometer.updatePedometer(data: expectedData)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .data(data) = info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = NSError(domain: CMErrorDomain,
                                    code: Int(CMErrorUnknown.rawValue))
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        pedometer.updatePedometer(error: expectedError)
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

    func testMonitor_unknown() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        pedometer.updatePedometer(data: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case .unknown = info {
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testQuery_data() {
        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMPedometerData()
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        pedometer.updatePedometer(queryData: expectedData)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didQuery(info) = event,
            case let .data(data) = info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testQuery_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = NSError(domain: CMErrorDomain,
                                    code: Int(CMErrorUnknown.rawValue))
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        pedometer.updatePedometer(queryError: expectedError)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didQuery(info) = event,
            case let .error(error) = info {
            XCTAssertEqual(error as NSError, expectedError)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testQuery_unknown() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PedometerMonitor.Event?
        let monitor = PedometerMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        pedometer.updatePedometer(queryData: nil)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didQuery(info) = event,
            case .unknown = info {
        } else {
            XCTFail("Unexpected event")
        }
    }
}
