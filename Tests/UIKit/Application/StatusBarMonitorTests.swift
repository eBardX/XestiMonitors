//
//  StatusBarMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class StatusBarMonitorTests: XCTestCase {
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        ApplicationInjector.inject = { self.application }

        application.statusBarFrame = .zero
        application.statusBarOrientation = .unknown

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testFrame() {
        let expectedFrame = CGRect(x: 10, y: 20, width: 30, height: 40)
        let monitor = StatusBarMonitor(options: .didChangeFrame,
                                       queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateDidChangeFrame(to: expectedFrame)

        XCTAssertEqual(monitor.frame, expectedFrame)
    }

    func testMonitor_didChangeFrame() {
        let expectation = self.expectation(description: "Handler called")
        let expectedFrame = CGRect(x: 1, y: 2, width: 3, height: 4)
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .didChangeFrame,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChangeFrame(to: expectedFrame)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChangeFrame(frame) = event {
            XCTAssertEqual(frame, expectedFrame)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didChangeOrientation() {
        let expectation = self.expectation(description: "Handler called")
        let expectedOrientation: UIInterfaceOrientation = .portraitUpsideDown
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .didChangeOrientation,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChangeOrientation(to: expectedOrientation)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChangeOrientation(orientation) = event {
            XCTAssertEqual(orientation, expectedOrientation)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willChangeFrame() {
        let expectation = self.expectation(description: "Handler called")
        let expectedFrame = CGRect(x: 4, y: 3, width: 2, height: 1)
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .willChangeFrame,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillChangeFrame(to: expectedFrame)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willChangeFrame(frame) = event {
            XCTAssertEqual(frame, expectedFrame)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willChangeFrame_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedFrame = CGRect(x: 4, y: 3, width: 2, height: 1)
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .willChangeFrame,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillChangeFrame(to: expectedFrame,
                                badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willChangeFrame(frame) = event {
            XCTAssertNotEqual(frame, expectedFrame)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willChangeOrientation() {
        let expectation = self.expectation(description: "Handler called")
        let expectedOrientation: UIInterfaceOrientation = .landscapeLeft
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .willChangeOrientation,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillChangeOrientation(to: expectedOrientation)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willChangeOrientation(orientation) = event {
            XCTAssertEqual(orientation, expectedOrientation)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willChangeOrientation_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedOrientation: UIInterfaceOrientation = .landscapeLeft
        var expectedEvent: StatusBarMonitor.Event?
        let monitor = StatusBarMonitor(options: .willChangeOrientation,
                                       queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillChangeOrientation(to: expectedOrientation,
                                      badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willChangeOrientation(orientation) = event {
            XCTAssertNotEqual(orientation, expectedOrientation)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testOrientation() {
        let expectedOrientation: UIInterfaceOrientation = .landscapeLeft
        let monitor = StatusBarMonitor(options: .didChangeOrientation,
                                       queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateDidChangeOrientation(to: expectedOrientation)

        XCTAssertEqual(monitor.orientation, expectedOrientation)
    }

    private func simulateDidChangeFrame(to frame: CGRect) {
        application.statusBarFrame = frame

        notificationCenter.post(name: .UIApplicationDidChangeStatusBarFrame,
                                object: application,
                                userInfo: [UIApplicationStatusBarFrameUserInfoKey: NSValue(cgRect: frame)])
    }

    private func simulateDidChangeOrientation(to orientation: UIInterfaceOrientation) {
        application.statusBarOrientation = orientation

        notificationCenter.post(name: .UIApplicationDidChangeStatusBarOrientation,
                                object: application,
                                userInfo: [UIApplicationStatusBarOrientationUserInfoKey: NSNumber(value: orientation.rawValue)])
    }

    private func simulateWillChangeFrame(to frame: CGRect,
                                         badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIApplicationStatusBarFrameUserInfoKey: NSValue(cgRect: frame)]
        }

        notificationCenter.post(name: .UIApplicationWillChangeStatusBarFrame,
                                object: application,
                                userInfo: userInfo)
    }

    private func simulateWillChangeOrientation(to orientation: UIInterfaceOrientation,
                                               badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIApplicationStatusBarOrientationUserInfoKey: NSNumber(value: orientation.rawValue)]
        }

        notificationCenter.post(name: .UIApplicationWillChangeStatusBarOrientation,
                                object: application,
                                userInfo: userInfo)
    }
}
