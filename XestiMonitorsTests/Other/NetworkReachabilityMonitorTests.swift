//
//  NetworkReachabilityMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import SystemConfiguration
import XCTest
@testable import XestiMonitors

internal class NetworkReachabilityMonitorTests: XCTestCase {
    let networkReachability = MockNetworkReachability()

    override func setUp() {
        super.setUp()

        NetworkReachabilityInjector.networkReachability = networkReachability

        networkReachability.updateFlags(nil)
    }

    func testIsReachable_false() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .notReachable)

        XCTAssertFalse(monitor.isReachable)
    }

    func testIsReachable_true1() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWiFi)

        XCTAssertTrue(monitor.isReachable)
    }

    func testIsReachable_true2() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWWAN)

        XCTAssertTrue(monitor.isReachable)
    }

    func testIsReachableViaWiFi_false() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWWAN)

        XCTAssertFalse(monitor.isReachableViaWiFi)
    }

    func testIsReachableViaWiFi_true() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWiFi)

        XCTAssertTrue(monitor.isReachableViaWiFi)
    }

    func testIsReachableViaWWAN_false() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWiFi)

        XCTAssertFalse(monitor.isReachableViaWWAN)
    }

    func testIsReachableViaWWAN_true() throws {
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: .reachableViaWWAN)

        XCTAssertTrue(monitor.isReachableViaWWAN)
    }

    func testMonitor_statusDidChange() throws {
        let expectation = self.expectation(description: "Handler called")

        //
        // Handler is always called once immediately upon start of monitoring,
        // and then if/when status changes thereafter:
        //
        expectation.expectedFulfillmentCount = 2

        let expectedStatus: NetworkReachabilityMonitor.Status = .reachableViaWiFi
        var expectedEvent: NetworkReachabilityMonitor.Event?
        let monitor = try NetworkReachabilityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateStatusDidChange(to: expectedStatus)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .statusDidChange(status) = event {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_statusDidChange_name() throws {
        let expectation = self.expectation(description: "Handler called")

        //
        // Handler is always called once immediately upon start of monitoring,
        // and then if/when status changes thereafter:
        //
        expectation.expectedFulfillmentCount = 2

        let expectedStatus: NetworkReachabilityMonitor.Status = .reachableViaWWAN
        var expectedEvent: NetworkReachabilityMonitor.Event?
        let monitor = try NetworkReachabilityMonitor(name: "bogus",
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateStatusDidChange(to: expectedStatus)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .statusDidChange(status) = event {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testStatus_notReachable1() throws {
        let expectedStatus: NetworkReachabilityMonitor.Status = .notReachable
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: expectedStatus,
                                using: [.connectionRequired,
                                        .reachable])

        XCTAssertEqual(monitor.status, expectedStatus)
    }

    func testStatus_notReachable2() throws {
        let expectedStatus: NetworkReachabilityMonitor.Status = .notReachable
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: expectedStatus,
                                using: [.connectionRequired,
                                        .interventionRequired,
                                        .reachable])

        XCTAssertEqual(monitor.status, expectedStatus)
    }

    func testStatus_notReachable3() throws {
        let expectedStatus: NetworkReachabilityMonitor.Status = .notReachable
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: expectedStatus,
                                using: [.connectionRequired,
                                        .connectionOnDemand,
                                        .connectionOnTraffic,
                                        .reachable])

        XCTAssertNotEqual(monitor.status, expectedStatus)
    }

    func testStatus_unknown() throws {
        let expectedStatus: NetworkReachabilityMonitor.Status = .unknown
        let monitor = try NetworkReachabilityMonitor(queue: .main) { _ in }

        simulateStatusDidChange(to: expectedStatus)

        XCTAssertEqual(monitor.status, expectedStatus)
    }

    private func defaultFlags(for status: NetworkReachabilityMonitor.Status) -> SCNetworkReachabilityFlags? {
        switch status {
        case .notReachable:
            return []

        case .reachableViaWiFi:
            return .reachable

        case .reachableViaWWAN:
            return [.isWWAN, .reachable]

        case .unknown:
            return nil
        }
    }

    private func simulateStatusDidChange(to status: NetworkReachabilityMonitor.Status,
                                         using flags: SCNetworkReachabilityFlags? = nil) {
        networkReachability.updateFlags(flags ?? defaultFlags(for: status))
    }
}
