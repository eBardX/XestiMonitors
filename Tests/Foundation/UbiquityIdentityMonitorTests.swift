//
//  UbiquityIdentityMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-03-14.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation
import XCTest
@testable import XestiMonitors

internal class UbiquityIdentityMonitorTests: XCTestCase {
    let fileManager = MockFileManager()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        FileManagerInjector.inject = { return self.fileManager }

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange_nil() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UbiquityIdentityMonitor.Event?
        let monitor = UbiquityIdentityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange(to: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(token) = event {
            XCTAssertNil(token)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didChange_nonNil() {
        let expectation = self.expectation(description: "Handler called")
        let expectedToken = "bogus"
        var expectedEvent: UbiquityIdentityMonitor.Event?
        let monitor = UbiquityIdentityMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange(to: expectedToken as AnyObject)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event,
            let actualToken = test as? String {
            XCTAssertEqual(actualToken, expectedToken)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidChange(to token: AnyObject?) {
        fileManager.ubiquityIdentityToken = token as? (NSCoding & NSCopying & NSObjectProtocol)

        notificationCenter.post(name: .NSUbiquityIdentityDidChange,
                                object: nil)
    }
}
