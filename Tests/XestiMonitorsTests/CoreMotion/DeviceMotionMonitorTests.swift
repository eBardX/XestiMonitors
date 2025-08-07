// © 2017–2025 John Gary Pusey (see LICENSE.md)

import CoreMotion
import XCTest
@testable import XestiMonitors

internal class DeviceMotionMonitorTests: XCTestCase {
    let motionManager = MockMotionManager()

    override func setUp() {
        super.setUp()

        MotionManagerInjector.inject = { self.motionManager }
    }

//    func testInfo_data() {
//        let expectedData = _makeMotionData()
//        let monitor = DeviceMotionMonitor(interval: 1,
//                                          using: .xArbitraryZVertical,
//                                          queue: .main) { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//        }
//
//        motionManager.updateDeviceMotion(data: expectedData)
//
//        if case let .data(actualData) = monitor.info {
//            XCTAssertEqual(actualData, expectedData)
//        } else {
//            XCTFail("Unexpected info")
//        }
//    }

    func testInfo_unknown() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateDeviceMotion(data: nil)

        if case .unknown = monitor.info {
        } else {
            XCTFail("Unexpected info")
        }
    }

    func testIsAvailable_false() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateDeviceMotion(available: false)

        XCTAssertFalse(monitor.isAvailable)
    }

    func testIsAvailable_true() {
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        motionManager.updateDeviceMotion(available: true)

        XCTAssertTrue(monitor.isAvailable)
    }

//    func testMonitor_data() {
//        let expectation = self.expectation(description: "Handler called")
//        let expectedData = _makeMotionData()
//        var expectedEvent: DeviceMotionMonitor.Event?
//        let monitor = DeviceMotionMonitor(interval: 1,
//                                          using: .xArbitraryZVertical,
//                                          queue: .main) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        motionManager.updateDeviceMotion(data: expectedData)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .didUpdate(info) = event,
//           case let .data(actualData) = info {
//            XCTAssertEqual(actualData, expectedData)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }

    func testMonitor_error() {
        let expectation = self.expectation(description: "Handler called")
        let expectedError = NSError(domain: CMErrorDomain,
                                    code: Int(CMErrorUnknown.rawValue))
        var expectedEvent: DeviceMotionMonitor.Event?
        let monitor = DeviceMotionMonitor(interval: 1,
                                          using: .xArbitraryZVertical,
                                          queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

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
            XCTAssertEqual(OperationQueue.current, .main)

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

    // MARK: Private Instance Methods

    private func _makeMotionData() -> CMDeviceMotion {
        CMDeviceMotion()    // this blows up on XCTAssertEqual
    }
}
