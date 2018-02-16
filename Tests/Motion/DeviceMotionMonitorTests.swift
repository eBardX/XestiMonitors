//
//  DeviceMotionMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class DeviceMotionMonitorTests: XCTestCase {
    let motionManager = MockMotionManager()

    override func setUp() {
        super.setUp()

        MotionManagerInjector.inject = { return self.motionManager }
    }

    func testInfo_data() {
        let expectedData = CMDeviceMotion()
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in }

        motionManager.updateDeviceMotion(data: expectedData)

        if case let .data(data) = monitor.info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected info")
        }
    }

    func testInfo_unknown() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in }

        motionManager.updateDeviceMotion(data: nil)

        if case .unknown = monitor.info {
        } else {
            XCTFail("Unexpected info")
        }
    }

    func testIsAvailable_false() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in }

        motionManager.updateDeviceMotion(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in }

        motionManager.updateDeviceMotion(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_data() {
        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMDeviceMotion()
        var expectedEvent: DeviceMotionMonitor.Event?
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateDeviceMotion(data: expectedData)
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
        var expectedEvent: DeviceMotionMonitor.Event?
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateDeviceMotion(error: expectedError)
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
        var expectedEvent: DeviceMotionMonitor.Event?
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateDeviceMotion(data: nil)
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
