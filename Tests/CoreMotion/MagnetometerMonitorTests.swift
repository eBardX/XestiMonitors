//
//  MagnetometerMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class MagnetometerMonitorTests: XCTestCase {
    let motionManager = MockMotionManager()

    override func setUp() {
        super.setUp()

        MotionManagerInjector.inject = { self.motionManager }
    }

    func testInfo_data() {
        let expectedData = CMMagnetometerData()
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateMagnetometer(data: expectedData)

        if case let .data(data) = monitor.info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected info")
        }
    }

    func testInfo_unknown() {
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateMagnetometer(data: nil)

        if case .unknown = monitor.info {
        } else {
            XCTFail("Unexpected info")
        }
    }

    func testIsAvailable_false() {
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateMagnetometer(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateMagnetometer(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_data() {
        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMMagnetometerData()
        var expectedEvent: MagnetometerMonitor.Event?
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateMagnetometer(data: expectedData)
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
        var expectedEvent: MagnetometerMonitor.Event?
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateMagnetometer(error: expectedError)
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
        var expectedEvent: MagnetometerMonitor.Event?
        let monitor = MagnetometerMonitor(interval: 1,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateMagnetometer(data: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case .unknown = info {
        } else {
            XCTFail("Unexpected event")
        }
    }
}
