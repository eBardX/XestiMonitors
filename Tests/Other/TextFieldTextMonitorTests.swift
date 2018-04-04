//
//  TextFieldTextMonitorTests.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-04-04.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class TextFieldTextMonitorTests: XCTestCase {
    
    let notificationCenter = MockNotificationCenter()
    let textField = UITextField()
    
    override func setUp() {
        super.setUp()
        
        NotificationCenterInjector.inject = { return self.notificationCenter }
    }
    
    func testMonitor_didBeginEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldTextMonitor.Event?
        let monitor = TextFieldTextMonitor(textField: self.textField,
                                           options: .didBeginEditing,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        
        monitor.startMonitoring()
        simulateDidBeginEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent, case let .didBeginEditing(view) = event {
            XCTAssertEqual(view, textField)
        } else {
            XCTFail("Unexpected event")
        }
        
    }
    
    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldTextMonitor.Event?
        let monitor = TextFieldTextMonitor(textField: self.textField,
                                           options: .didChange,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        
        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent, case let .didChange(view) = event {
            XCTAssertEqual(view, textField)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    func testMonitor_didEndEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldTextMonitor.Event?
        let monitor = TextFieldTextMonitor(textField: textField,
                                           options: .didEndEditing,
                                           queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }
        
        monitor.startMonitoring()
        simulateDidEndEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
        
        if let event = expectedEvent,
            case let .didEndEditing(view) = event {
            XCTAssertEqual(view, textField)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    private func simulateDidBeginEditing() {
        notificationCenter.post(name: .UITextFieldTextDidBeginEditing,
                                object: textField)
    }
    
    private func simulateDidChange() {
        notificationCenter.post(name: .UITextFieldTextDidChange,
                                object: textField)
    }
    
    private func simulateDidEndEditing() {
        notificationCenter.post(name: .UITextFieldTextDidEndEditing,
                                object: textField)
    }
}
