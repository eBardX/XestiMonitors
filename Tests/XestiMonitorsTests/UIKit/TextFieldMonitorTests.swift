// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class TextFieldMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let textField = UITextField()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didBeginEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldMonitor.Event?
        let monitor = TextFieldMonitor(textField: textField) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidBeginEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .textDidBeginEditing(test) = event {
            XCTAssertEqual(test, textField)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldMonitor.Event?
        let monitor = TextFieldMonitor(textField: textField) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .textDidChange(test) = event {
            XCTAssertEqual(test, textField)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didEndEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextFieldMonitor.Event?
        let monitor = TextFieldMonitor(textField: textField) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidEndEditing()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .textDidEndEditing(test) = event {
            XCTAssertEqual(test, textField)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBeginEditing() {
        notificationCenter.post(name: UITextField.textDidBeginEditingNotification,
                                object: textField)
    }

    private func _simulateDidChange() {
        notificationCenter.post(name: UITextField.textDidChangeNotification,
                                object: textField)
    }

    private func _simulateDidEndEditing() {
        notificationCenter.post(name: UITextField.textDidEndEditingNotification,
                                object: textField)
    }
}
