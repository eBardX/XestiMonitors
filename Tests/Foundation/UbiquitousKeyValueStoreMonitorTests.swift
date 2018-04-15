//
//  UbiquitousKeyValueStoreMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-14.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class UbiquitousKeyValueStoreMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.`default`   // MockUbiquitousKeyValueStore()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_accountChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["fee", "fie", "foe", "fum"]
        var expectedEvent: UbiquitousKeyValueStoreMonitor.Event?
        let monitor = UbiquitousKeyValueStoreMonitor(options: .accountChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateAccountChange(changedKeys: expectedChangedKeys)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .accountChange(changedKeys) = event {
            XCTAssertEqual(changedKeys, expectedChangedKeys)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_bogus1() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = UbiquitousKeyValueStoreMonitor(options: .all,
                                                     queue: .main) { _ in
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateBogus(true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_bogus2() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = UbiquitousKeyValueStoreMonitor(options: .all,
                                                     queue: .main) { _ in
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateBogus(false)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_initialSyncChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["john", "paul", "george", "ringo"]
        var expectedEvent: UbiquitousKeyValueStoreMonitor.Event?
        let monitor = UbiquitousKeyValueStoreMonitor(options: .initialSyncChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateInitialSyncChange(changedKeys: expectedChangedKeys)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .initialSyncChange(changedKeys) = event {
            XCTAssertEqual(changedKeys, expectedChangedKeys)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_quotaViolationChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["larry", "moe", "curly"]
        var expectedEvent: UbiquitousKeyValueStoreMonitor.Event?
        let monitor = UbiquitousKeyValueStoreMonitor(options: .quotaViolationChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateQuotaViolationChange(changedKeys: expectedChangedKeys)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .quotaViolationChange(changedKeys) = event {
            XCTAssertEqual(changedKeys, expectedChangedKeys)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_serverChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["tweedle-dee", "tweedle-dum"]
        var expectedEvent: UbiquitousKeyValueStoreMonitor.Event?
        let monitor = UbiquitousKeyValueStoreMonitor(options: .serverChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateServerChange(changedKeys: expectedChangedKeys)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .serverChange(changedKeys) = event {
            XCTAssertEqual(changedKeys, expectedChangedKeys)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func makeUserInfo(changeReason: Int,
                              changedKeys: [String]) -> [AnyHashable: Any] {
        return [NSUbiquitousKeyValueStoreChangedKeysKey: changedKeys,
                NSUbiquitousKeyValueStoreChangeReasonKey: changeReason]
    }

    private func simulateBogus(_ includeUserInfo: Bool) {
        let userInfo = includeUserInfo ? makeUserInfo(changeReason: 666,
                                                      changedKeys: ["bogus"]) : nil

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func simulateAccountChange(changedKeys: [String]) {
        let userInfo = makeUserInfo(changeReason: NSUbiquitousKeyValueStoreAccountChange,
                                    changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func simulateInitialSyncChange(changedKeys: [String]) {
        let userInfo = makeUserInfo(changeReason: NSUbiquitousKeyValueStoreInitialSyncChange,
                                    changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func simulateQuotaViolationChange(changedKeys: [String]) {
        let userInfo = makeUserInfo(changeReason: NSUbiquitousKeyValueStoreQuotaViolationChange,
                                    changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func simulateServerChange(changedKeys: [String]) {
        let userInfo = makeUserInfo(changeReason: NSUbiquitousKeyValueStoreServerChange,
                                    changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }
}
