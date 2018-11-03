//
//  TextInputModeMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-04-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class TextInputModeMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let textInputMode = UITextInputMode()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextInputModeMonitor.Event?
        let monitor = TextInputModeMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, textInputMode)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: UITextInputMode.currentInputModeDidChangeNotification,
                                object: textInputMode)
    }
}
