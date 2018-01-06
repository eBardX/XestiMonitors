//
//  ProtectedDataMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ProtectedDataMonitorTests: XCTestCase {
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()
    
    override func setUp() {
        super.setUp()
        
        ApplicationInjector.application = application
        
        application.isProtectedDataAvailable = false
        
        NotificationCenterInjector.notificationCenter = notificationCenter
    }
    
    func testMonitor_didBecomeAvailable() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ProtectedDataMonitor.Event?
        let monitor = ProtectedDataMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }
        
        monitor.startMonitoring()
        simulateDidBecomeAvailable()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent {
            XCTAssertEqual(event, .didBecomeAvailable)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    func testIsContentAccessible() {
        let expectedIsContentAccessible: Bool = true
        let monitor = ProtectedDataMonitor(queue: .main) { _ in }
        
        application.isProtectedDataAvailable = true
        
        XCTAssertEqual(monitor.isContentAccessible, expectedIsContentAccessible)
    }
    
    func testMonitor_willBecomeUnavailable() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ProtectedDataMonitor.Event?
        let monitor = ProtectedDataMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }
        
        monitor.startMonitoring()
        simulateWillBecomeUnavailable()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent {
            XCTAssertEqual(event, .willBecomeUnavailable)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    private func simulateDidBecomeAvailable() {
        notificationCenter.post(name: .UIApplicationProtectedDataDidBecomeAvailable,
                                object: application)
    }
    
    private func simulateWillBecomeUnavailable() {
        notificationCenter.post(name: .UIApplicationProtectedDataWillBecomeUnavailable,
                                object: application)
    }
}
