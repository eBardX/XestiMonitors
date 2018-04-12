//
//  FocusMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-04-09.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

// swiftlint:disable explicit_top_level_acl

@available(iOS 11.0, tvOS 11.0, *)
internal class FocusMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    #if os(tvOS)
    let context = UIFocusUpdateContext()
    let coordinator = UIFocusAnimationCoordinator()
    #endif

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    #if os(tvOS)
    func testMonitor_didUpdate() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FocusMonitor.Event?
        let monitor = FocusMonitor(options: .didUpdate,
                                   queue: .main) { event in
                                    expectedEvent = event
                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidUpdate()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUpdate(info) = event {
            XCTAssertEqual(info.context, context)
            XCTAssertEqual(info.coordinator, coordinator)
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    func testMonitor_didUpdate_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = FocusMonitor(options: .didUpdate,
                                   queue: .main) { _ in
                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidUpdate(badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    #if os(tvOS)
    func testMonitor_movementDidFail() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FocusMonitor.Event?
        let monitor = FocusMonitor(options: .movementDidFail,
                                   queue: .main) { event in
                                    expectedEvent = event
                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateMovementDidFail()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .movementDidFail(info) = event {
            XCTAssertEqual(info.context, context)
        } else {
            XCTFail("Unexpected event")
        }
    }
    #endif

    private func simulateDidUpdate(badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            #if os(tvOS)
            userInfo = [UIFocusUpdateAnimationCoordinatorKey: coordinator,
                        UIFocusUpdateContextKey: context]
            #else
            userInfo = nil
            #endif
        }

        notificationCenter.post(name: .UIFocusDidUpdate,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateMovementDidFail() {
        let userInfo: [AnyHashable: Any]?

        #if os(tvOS)
        userInfo = [UIFocusUpdateContextKey: context]
        #else
        userInfo = nil
        #endif

        notificationCenter.post(name: .UIFocusMovementDidFail,
                                object: nil,
                                userInfo: userInfo)
    }
}

// swiftlint:enable explicit_top_level_acl
