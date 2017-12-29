//
//  ApplicationStateMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ApplicationStateMonitorTests: XCTestCase {

    let application = UIApplication.shared  // MockApplication()
    let notificationCenter = MockNotificationCenter()

    func testMonitor_didBecomeActive() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidBecomeActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didBecomeActive = event {
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testMonitor_didEnterBackground() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidEnterBackground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .didEnterBackground = event {
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testMonitor_didFinishLaunching() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidFinishLaunching()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didFinishLaunching(options) = event {
            XCTAssertNil(options)
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testMonitor_willEnterForeground() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillEnterForeground()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willEnterForeground = event {
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testMonitor_willResignActive() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillResignActive()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willResignActive = event {
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testMonitor_willTerminate() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ApplicationStateMonitor.Event?
        let monitor = ApplicationStateMonitor(notificationCenter: notificationCenter,
                                              queue: .main,
                                              application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillTerminate()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case .willTerminate = event {
        } else {
            XCTFail("Unexpected event")
        }

    }

    private func simulateDidBecomeActive() {

        notificationCenter.post(name: .UIApplicationDidBecomeActive,
                                object: application)

    }

    private func simulateDidEnterBackground() {

        notificationCenter.post(name: .UIApplicationDidEnterBackground,
                                object: application)

    }

    private func simulateDidFinishLaunching() {

        notificationCenter.post(name: .UIApplicationDidFinishLaunching,
                                object: application)

    }

    private func simulateWillEnterForeground() {

        notificationCenter.post(name: .UIApplicationWillEnterForeground,
                                object: application)

    }

    private func simulateWillResignActive() {

        notificationCenter.post(name: .UIApplicationWillResignActive,
                                object: application)

    }

    private func simulateWillTerminate() {

        notificationCenter.post(name: .UIApplicationWillTerminate,
                                object: application)

    }

}
