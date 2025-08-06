//// © 2018–2025 John Gary Pusey (see LICENSE.md)
//
// import CoreLocation
// import XCTest
// @testable import XestiMonitors
//
// internal class BeaconRangingMonitorTests: XCTestCase {
//    let locationManager = MockLocationManager()
//
//    override func setUp() {
//        super.setUp()
//
//        DependencyResolver.register(locationManager as any LocationManagerProtocol)
//    }
//
//    func testIsActivelyRanged_false() {
//        let monitor = BeaconRangingMonitor(region: _makeBeaconRegion("bogus")) { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//        }
//
//        monitor.startMonitoring()
//        locationManager.stopRangingBeacons(in: monitor.region)
//
//        XCTAssertFalse(monitor.isActivelyRanged)
//    }
//
//    func testIsActivelyRanged_true() {
//        let monitor = BeaconRangingMonitor(region: _makeBeaconRegion("bogus")) { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//        }
//
//        monitor.startMonitoring()
//
//        XCTAssertTrue(monitor.isActivelyRanged)
//    }
//
//    func testIsAvailable_false() {
//        let monitor = BeaconRangingMonitor(region: _makeBeaconRegion("bogus")) { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//        }
//
//        locationManager.updateBeaconRanging(available: false)
//
//        XCTAssertFalse(monitor.isAvailable)
//    }
//
//    func testIsAvailable_true() {
//        let monitor = BeaconRangingMonitor(region: _makeBeaconRegion("bogus")) { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//        }
//
//        locationManager.updateBeaconRanging(available: true)
//
//        XCTAssertTrue(monitor.isAvailable)
//    }
//
//    func testMonitor_beacons() {
//        let expectation = self.expectation(description: "Handler called")
//        let expectedRegion = _makeBeaconRegion("bogus")
//        var expectedEvent: BeaconRangingMonitor.Event?
//        let monitor = BeaconRangingMonitor(region: expectedRegion) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        locationManager.updateBeaconRanging(beacons: [],
//                                            in: expectedRegion)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .didUpdate(info) = event,
//           case let .beacons(beacons, region) = info {
//            XCTAssertEqual(region, expectedRegion)
//            XCTAssertTrue(beacons.isEmpty)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_error1() {
//        let expectation = self.expectation(description: "Handler called")
//        let expectedRegion = _makeBeaconRegion("bogus")
//        let expectedError = _makeError()
//        var expectedEvent: BeaconRangingMonitor.Event?
//        let monitor = BeaconRangingMonitor(region: expectedRegion) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        locationManager.updateBeaconRanging(error: expectedError,
//                                            for: expectedRegion)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .didUpdate(info) = event,
//           case let .error(error, region) = info {
//            XCTAssertEqual(region, expectedRegion)
//            XCTAssertEqual(error as NSError, expectedError)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_error2() {
//        let expectation = self.expectation(description: "Handler called")
//        let expectedRegion = _makeBeaconRegion("bogus")
//        let expectedError = _makeError()
//        var expectedEvent: BeaconRangingMonitor.Event?
//        let monitor = BeaconRangingMonitor(region: expectedRegion) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        locationManager.updateBeaconRanging(error: expectedError)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .didUpdate(info) = event,
//           case let .error(error, region) = info {
//            XCTAssertEqual(region, expectedRegion)
//            XCTAssertEqual(error as NSError, expectedError)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    // MARK: Private Instance Methods
//
//    private func _makeBeaconRegion(_ identifier: String) -> CLBeaconRegion {
//        CLBeaconRegion(uuid: UUID(),
//                       identifier: identifier)
//    }
//
//    private func _makeError() -> NSError {
//        NSError(domain: "CLErrorDomain",
//                code: CLError.Code.network.rawValue)
//    }
// }
