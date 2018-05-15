//
//  UserDefaultsMonitorTests.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-25.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class UserDefaultsMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let userDefaults = UserDefaults()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UserDefaultsMonitor.Event?
        let monitor = UserDefaultsMonitor(options: .didChange,
                                          queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, userDefaults)
        } else {
            XCTFail("Unexpected event")
        }
    }

    @available(iOS 9.3, *)
    func testMonitor_sizeLimitExceeded() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UserDefaultsMonitor.Event?
        let monitor = UserDefaultsMonitor(options: .sizeLimitExceeded,
                                          queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSizeLimitExceeded()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent,
            case let .sizeLimitExceeded(test) = event {
            XCTAssertEqual(test, userDefaults)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: UserDefaults.didChangeNotification, object: userDefaults)
    }

    @available(iOS 9.3, *)
    private func simulateSizeLimitExceeded() {
        notificationCenter.post(name: UserDefaults.sizeLimitExceededNotification, object: userDefaults)
    }
}
