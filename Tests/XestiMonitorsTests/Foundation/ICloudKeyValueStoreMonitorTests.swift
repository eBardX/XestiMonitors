// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class ICloudKeyValueStoreMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let ubiquitousKeyValueStore = NSUbiquitousKeyValueStore.default // MockUbiquitousKeyValueStore()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_accountChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["fee", "fie", "foe", "fum"]
        var expectedEvent: ICloudKeyValueStoreMonitor.Event?
        let monitor = ICloudKeyValueStoreMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateAccountChange(changedKeys: expectedChangedKeys)
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

        let monitor = ICloudKeyValueStoreMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)

            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateBogus(true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_bogus2() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = ICloudKeyValueStoreMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)

            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateBogus(false)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_initialSyncChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedChangedKeys = ["john", "paul", "george", "ringo"]
        var expectedEvent: ICloudKeyValueStoreMonitor.Event?
        let monitor = ICloudKeyValueStoreMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateInitialSyncChange(changedKeys: expectedChangedKeys)
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
        var expectedEvent: ICloudKeyValueStoreMonitor.Event?
        let monitor = ICloudKeyValueStoreMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateQuotaViolationChange(changedKeys: expectedChangedKeys)
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
        var expectedEvent: ICloudKeyValueStoreMonitor.Event?
        let monitor = ICloudKeyValueStoreMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateServerChange(changedKeys: expectedChangedKeys)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .serverChange(changedKeys) = event {
            XCTAssertEqual(changedKeys, expectedChangedKeys)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _makeUserInfo(changeReason: Int,
                               changedKeys: [String]) -> [AnyHashable: Any] {
        [NSUbiquitousKeyValueStoreChangedKeysKey: changedKeys,
         NSUbiquitousKeyValueStoreChangeReasonKey: changeReason]
    }

    private func _simulateAccountChange(changedKeys: [String]) {
        let userInfo = _makeUserInfo(changeReason: NSUbiquitousKeyValueStoreAccountChange,
                                     changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func _simulateBogus(_ includeUserInfo: Bool) {
        let userInfo = includeUserInfo ? _makeUserInfo(changeReason: 666,
                                                       changedKeys: ["bogus"]) : nil

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func _simulateInitialSyncChange(changedKeys: [String]) {
        let userInfo = _makeUserInfo(changeReason: NSUbiquitousKeyValueStoreInitialSyncChange,
                                     changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func _simulateQuotaViolationChange(changedKeys: [String]) {
        let userInfo = _makeUserInfo(changeReason: NSUbiquitousKeyValueStoreQuotaViolationChange,
                                     changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }

    private func _simulateServerChange(changedKeys: [String]) {
        let userInfo = _makeUserInfo(changeReason: NSUbiquitousKeyValueStoreServerChange,
                                     changedKeys: changedKeys)

        notificationCenter.post(name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                object: ubiquitousKeyValueStore,
                                userInfo: userInfo)
    }
}
