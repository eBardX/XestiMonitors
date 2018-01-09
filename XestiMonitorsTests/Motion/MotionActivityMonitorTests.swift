//
//  MotionActivityMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class MotionActivityMonitorTests: XCTestCase {
    let motionActivityManager = MockMotionActivityManager()

    override func setUp() {
        super.setUp()

        MotionActivityManagerInjector.motionActivityManager = motionActivityManager
    }

    func testIsAvailable_false() {
        let monitor = MotionActivityMonitor(queue: .main) { _ in }

        motionActivityManager.updateMotionActivity(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = MotionActivityMonitor(queue: .main) { _ in }

        motionActivityManager.updateMotionActivity(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

    func testMonitor_data() {
        let expectation = self.expectation(description: "Handler called")
        let expectedData = CMMotionActivity()
        var expectedEvent: MotionActivityMonitor.Event?
        let monitor = MotionActivityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionActivityManager.updateMotionActivity(data: expectedData)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event,
            case let .activity(data) = info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_unknown() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MotionActivityMonitor.Event?
        let monitor = MotionActivityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        motionActivityManager.updateMotionActivity(data: nil)
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
        let expectedData = [CMMotionActivity()]
        var expectedEvent: MotionActivityMonitor.Event?
        let monitor = MotionActivityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        motionActivityManager.updateMotionActivity(queryData: expectedData)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didQuery(info) = event,
            case let .activities(data) = info {
            XCTAssertEqual(data, expectedData)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testQuery_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = NSError(domain: CMErrorDomain,
                                    code: Int(CMErrorUnknown.rawValue))
        var expectedEvent: MotionActivityMonitor.Event?
        let monitor = MotionActivityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        motionActivityManager.updateMotionActivity(queryError: expectedError)
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
        var expectedEvent: MotionActivityMonitor.Event?
        let monitor = MotionActivityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.query(from: Date(),
                      to: Date())
        motionActivityManager.updateMotionActivity(queryData: nil)
        waitForExpectations(timeout: 1)

        if let event = expectedEvent,
            case let .didQuery(info) = event,
            case .unknown = info {
        } else {
            XCTFail("Unexpected event")
        }
    }
}
