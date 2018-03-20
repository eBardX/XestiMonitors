//
//  WindowMonitorTests.swift
//  XestiMonitors-iOS
//
//  Created by Martin Mungai on 20/03/2018.
//
//  © 2018 J. G. Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class WindowMonitorTests: XCTestCase {
    
    let notificationCenter = MockNotificationCenter()
    let window = UIWindow()
    
    override func setUp() {
        super.setUp()
        
        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }
    
    func testMonitorDidBecomeVisible() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(queue: .main, window: self.window, options: .didBecomeVisible) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidBecomeVisible()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        if let event = expectedEvent,
            case let .didBecomeVisible(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    
    func testMonitorDidBecomeHidden() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(queue: .main, window: self.window, options: .didBecomeHidden) { event in
            expectedEvent = event
            expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidBecomeHidden()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        if let event = expectedEvent,
            case let .didBecomeHidden(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    
    func testMonitorDidBecomeKey() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(queue: .main, window: self.window, options: .didBecomeKey) { event in
            expectedEvent = event
            expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidBecomeKey()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        if let event = expectedEvent,
            case let .didBecomeKey(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    
    func testMonitorDidResignKey() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: WindowMonitor.Event?
        let monitor = WindowMonitor(queue: .main, window: self.window, options: .didResignKey) { event in
            expectedEvent = event
            expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidResignKey()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        if let event = expectedEvent,
            case let .didResignKey(test) = event {
            XCTAssertEqual(test, window)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    
    private func simulateDidBecomeVisible() {
        notificationCenter.post(name: .UIWindowDidBecomeVisible, object: self.window)
    }
    
    private func simulateDidBecomeHidden() {
        notificationCenter.post(name: .UIWindowDidBecomeHidden, object: self.window)
    }
    
    private func simulateDidBecomeKey() {
        notificationCenter.post(name: .UIWindowDidBecomeKey, object: self.window)
    }
    
    private func simulateDidResignKey() {
        notificationCenter.post(name: .UIWindowDidResignKey, object: self.window)
    }
    
    
}
