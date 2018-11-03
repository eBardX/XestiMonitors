//
//  URLCredentialStorageMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Angie Mugo on 2018-05-29.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class URLCredentialStorageMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let credentialStorage = URLCredentialStorage.shared

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_changed() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: URLCredentialStorageMonitor.Event?
        let monitor = URLCredentialStorageMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateChanged()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .changed(test) = event {
            XCTAssertEqual(test, credentialStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateChanged() {
        notificationCenter.post(name: .NSURLCredentialStorageChanged,
                                object: credentialStorage)
    }
}
