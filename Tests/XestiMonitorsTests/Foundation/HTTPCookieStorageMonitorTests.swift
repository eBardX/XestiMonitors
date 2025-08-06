// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class HTTPCookiesStorageMonitorTests: XCTestCase {
    let cookieStorage = HTTPCookieStorage()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_acceptPolicyChanged() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: HTTPCookiesStorageMonitor.Event?
        let monitor = HTTPCookiesStorageMonitor(cookieStorage: cookieStorage) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateAcceptPolicyChanged()
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
        let monitor = HTTPCookiesStorageMonitor(cookieStorage: cookieStorage) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulatecookiesChanged()
        waitForExpectations(timeout: 1)
        monitor.startMonitoring()

        if let event = expectedEvent,
           case let .cookiesChanged(test) = event {
            XCTAssertEqual(test, cookieStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateAcceptPolicyChanged() {
        notificationCenter.post(name: .NSHTTPCookieManagerAcceptPolicyChanged,
                                object: cookieStorage)
    }

    private func _simulatecookiesChanged() {
        notificationCenter.post(name: .NSHTTPCookieManagerCookiesChanged,
                                object: cookieStorage)
    }
}
