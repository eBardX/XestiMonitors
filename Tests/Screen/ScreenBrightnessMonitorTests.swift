//
//  ScreenBrightnessMonitorTests.swift
//  XestiMonitors
//
+//  Created by Paul Nyondo on 2018-03-25.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ScreenBrightnessMonitorTests:XCTestCase {
    
    let notificationCenter = MockNotificationCenter()
    let screen = MockScreen()
    
    override func setUp() {
        super.setUp()
        
        NotificationCenterInjector.inject = {
            return self.notificationCenter
        }
    }
    
    func testMonitor_brightnessDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ScreenBrightnessMonitor.Event?
        let monitor = ScreenBrightnessMonitor(screen: screen,
                                              queue: .main){ event  in
                                                expectedEvent = event
                                                expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent,
            case let .didChange(uiscreen) = event {
            XCTAssertEqual(uiscreen, screen)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    private func simulateDidChange() {
        notificationCenter.post(name: .UIScreenBrightnessDidChange,
                                object: screen)
    }
    
    
}

