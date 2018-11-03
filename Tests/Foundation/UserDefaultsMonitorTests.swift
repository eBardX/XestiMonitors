//
//  UserDefaultsMonitorTests.swift
//  XestiMonitorsTests
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

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UserDefaultsMonitor.Event?
        #if os(iOS) || os(tvOS) || os(watchOS)
        let monitor = UserDefaultsMonitor(userDefaults: userDefaults,
                                          options: .didChange,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }
        #else
        let monitor = UserDefaultsMonitor(userDefaults: userDefaults,
                                          queue: .main) { event in
                                            XCTAssertEqual(OperationQueue.current, .main)

                                            expectedEvent = event
                                            expectation.fulfill()
        }
        #endif

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

    #if os(iOS) || os(tvOS) || os(watchOS)
    func testMonitor_sizeLimitExceeded() {
        if #available(iOS 9.3, *) {
            let expectation = self.expectation(description: "Handler called")
            var expectedEvent: UserDefaultsMonitor.Event?
            let monitor = UserDefaultsMonitor(userDefaults: userDefaults,
                                              options: .sizeLimitExceeded,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

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
    }
    #endif

    private func simulateDidChange() {
        notificationCenter.post(name: UserDefaults.didChangeNotification,
                                object: userDefaults)
    }

    #if os(iOS) || os(tvOS) || os(watchOS)
    @available(iOS 9.3, *)
    private func simulateSizeLimitExceeded() {
        notificationCenter.post(name: UserDefaults.sizeLimitExceededNotification,
                                object: userDefaults)
    }
    #endif
}
