//
//  HTTPCookiesStorageMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Angie Mugo on 2018-05-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class HTTPCookiesStorageMonitorTests: XCTestCase {
    let cookieStorage = HTTPCookieStorage()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_acceptPolicyChanged() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: HTTPCookiesStorageMonitor.Event?
        let monitor = HTTPCookiesStorageMonitor(cookieStorage: cookieStorage,
                                                options: .acceptPolicyChanged,
                                                queue: .main) { event in
                                                    XCTAssertEqual(OperationQueue.current, .main)

                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateAcceptPolicyChanged()
        waitForExpectations(timeout: 1)
        monitor.startMonitoring()

        if let event = expectedEvent,
            case let .acceptPolicyChanged(test) = event {
            XCTAssertEqual(test, cookieStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_cookiesChanged() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: HTTPCookiesStorageMonitor.Event?
        let monitor = HTTPCookiesStorageMonitor(cookieStorage: cookieStorage,
                                                options: .cookiesChanged,
                                                queue: .main) { event in
                                                    XCTAssertEqual(OperationQueue.current, .main)

                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulatecookiesChanged()
        waitForExpectations(timeout: 1)
        monitor.startMonitoring()

        if let event = expectedEvent,
            case let .cookiesChanged(test) = event {
            XCTAssertEqual(test, cookieStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateAcceptPolicyChanged() {
        notificationCenter.post(name: .NSHTTPCookieManagerAcceptPolicyChanged,
                                object: cookieStorage)
    }

    private func simulatecookiesChanged() {
        notificationCenter.post(name: .NSHTTPCookieManagerCookiesChanged,
                                object: cookieStorage)
    }
}
