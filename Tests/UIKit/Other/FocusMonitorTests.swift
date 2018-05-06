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

internal class FocusMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    #if os(tvOS)
    let context = UIFocusUpdateContext()
    #else
    let context = UIFocusUpdateContext.make()
    #endif
    let coordinator = UIFocusAnimationCoordinator()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didUpdate() {
        if #available(iOS 11.0, tvOS 11.0, *) {
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
    }

    func testMonitor_didUpdate_badUserInfo() {
        if #available(iOS 11.0, tvOS 11.0, *) {
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
    }

    func testMonitor_movementDidFail() {
        if #available(iOS 11.0, tvOS 11.0, *) {
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
    }

    private func simulateDidUpdate(badUserInfo: Bool = false) {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let userInfo: [AnyHashable: Any]?

            if badUserInfo {
                userInfo = nil
            } else {
                userInfo = [UIFocusUpdateAnimationCoordinatorKey: coordinator,
                            UIFocusUpdateContextKey: context]
            }

            notificationCenter.post(name: .UIFocusDidUpdate,
                                    object: nil,
                                    userInfo: userInfo)
        }
    }

    private func simulateMovementDidFail() {
        if #available(iOS 11.0, tvOS 11.0, *) {
            let userInfo = [UIFocusUpdateContextKey: context]

            notificationCenter.post(name: .UIFocusMovementDidFail,
                                    object: nil,
                                    userInfo: userInfo)
        }
    }
}
