//
//  PasteboardMonitorTests.swift
//  XestiMonitors-iOS
//
//  Created by Paul nyondo on 15/03/2018.
//  Copyright © 2018 Xesticode. All rights reserved.
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class PasteboardMonitorTests: XCTestCase {
    let pasteboard = MockPasteboard()
    let notificationCenter = MockNotificationCenter()
    
    override func setUp() {
        super.setUp()
        
        NotificationCenterInjector.inject =  {
            return self.notificationCenter
        }
    }
    
    func testMonitor_contentsDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent,
            case let .didChange(board) = event {
            XCTAssertEqual(board, pasteboard)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    func testMonitor_contentsDidRemove() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: PasteboardMonitor.Event?
        let monitor = PasteboardMonitor(pasteboard: pasteboard,
                                        queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        monitor.startMonitoring()
        simulateDidRemove()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent,
            case let .didRemove(board) = event {
            XCTAssertEqual(board, pasteboard)
        } else {
            XCTFail("Unexpected Event")
        }
    }
    
    private func simulateDidChange() {
        notificationCenter.post(name: .UIPasteboardChanged,
                                object: pasteboard)
    }
    
    private func simulateDidRemove(){
        notificationCenter.post(name: .UIPasteboardRemoved,
                                object: pasteboard)
    }

}


