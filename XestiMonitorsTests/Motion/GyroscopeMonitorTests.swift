//
//  GyroscopeMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class GyroscopeMonitorTests: XCTestCase {

    let motionManager = MockMotionManager()

    func testInfo_data() {

        let expectedData = CMGyroData()
        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { _ in }

        motionManager.updateGyroscope(data: expectedData)

        if case let .data(data) = monitor.info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected info")
        }

    }

    func testInfo_unknown() {

        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { _ in }

        motionManager.updateGyroscope(data: nil)

        if case .unknown = monitor.info {
        } else {
            XCTFail("Unexpected info")
        }

    }

    func testIsAvailable_false() {

        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { _ in }

        motionManager.updateGyroscope(available: false)

        XCTAssertFalse(monitor.isAvailable)

    }

    func testIsAvailable_true() {

        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { _ in }

        motionManager.updateGyroscope(available: true)

        XCTAssertTrue(monitor.isAvailable)

    }

    func testMonitor_data() {

        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMGyroData()
        var expectedEvent: GyroscopeMonitor.Event?
        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateGyroscope(data: expectedData)
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
        var expectedEvent: GyroscopeMonitor.Event?
        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateGyroscope(error: expectedError)
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
        var expectedEvent: GyroscopeMonitor.Event?
        let monitor = GyroscopeMonitor(motionManager: motionManager,
                                       queue: .main,
                                       interval: 1) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        motionManager.updateGyroscope(data: nil)
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
