//
//  MenuControllerMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Paul Nyondo on 2018-04-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class MenuControllerMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let menuController = UIMenuController.shared

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didHideMenu() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MenuControllerMonitor.Event?
        let monitor = MenuControllerMonitor(options: .all,
                                            queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidHideMenu()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didHideMenu(test) = event {
            XCTAssertEqual(test, menuController)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didShowMenu() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MenuControllerMonitor.Event?
        let monitor = MenuControllerMonitor(options: .all,
                                            queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidShowMenu()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didShowMenu(test) = event {
            XCTAssertEqual(test, menuController)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_menuDidChangeFrame() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MenuControllerMonitor.Event?
        let monitor = MenuControllerMonitor(options: .all,
                                            queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateMenuDidChangeFrame()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .menuFrameDidChange(test) = event {
            XCTAssertEqual(test, menuController)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willHideMenu() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MenuControllerMonitor.Event?
        let monitor = MenuControllerMonitor(options: .all,
                                            queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillHideMenu()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willHideMenu(test) = event {
            XCTAssertEqual(test, menuController)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willShowMenu() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MenuControllerMonitor.Event?
        let monitor = MenuControllerMonitor(options: .all,
                                            queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillShowMenu()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willShowMenu(test) = event {
            XCTAssertEqual(test, menuController)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidHideMenu() {
        notificationCenter.post(name: UIMenuController.didHideMenuNotification,
                                object: menuController)
    }

    private func simulateDidShowMenu() {
        notificationCenter.post(name: UIMenuController.didShowMenuNotification,
                                object: menuController)
    }

    private func simulateMenuDidChangeFrame() {
        notificationCenter.post(name: UIMenuController.menuFrameDidChangeNotification,
                                object: menuController)
    }

    private func simulateWillHideMenu() {
        notificationCenter.post(name: UIMenuController.willHideMenuNotification,
                                object: menuController)
    }

    private func simulateWillShowMenu() {
        notificationCenter.post(name: UIMenuController.willShowMenuNotification,
                                object: menuController)
    }
}
