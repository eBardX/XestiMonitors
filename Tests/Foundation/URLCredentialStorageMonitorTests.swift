//
//  URLCredentialStorageMonitorTests.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-29.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class URLCredentialStorageMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let urlCredentialStorage = URLCredentialStorage.shared

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: URLCredentialStorageMonitor.Event?
        let monitor = URLCredentialStorageMonitor(queue: .main) { event in
                                                     expectedEvent = event
                                                     expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateURLCredentialsStorageDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .changed(test) = event {
            XCTAssertEqual(test, urlCredentialStorage)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func simulateURLCredentialsStorageDidChange() {
        notificationCenter.post(name: .NSURLCredentialStorageChanged,
                                object: URLCredentialStorage.shared)
    }
}
