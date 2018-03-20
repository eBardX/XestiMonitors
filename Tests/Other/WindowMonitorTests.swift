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
    
    private func simulateDidBecomeVisible() {
        
        notificationCenter.post(name: .UIWindowDidBecomeVisible, object: self.window)
    }
    
    
}
