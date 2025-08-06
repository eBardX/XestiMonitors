// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class TextViewMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let textView = UITextView()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didBeginEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textView: textView) { event in
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
            XCTAssertEqual(test, textView)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textView: textView) { event in
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
            XCTAssertEqual(test, textView)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didEndEditing() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: TextViewMonitor.Event?
        let monitor = TextViewMonitor(textView: textView) { event in
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
            XCTAssertEqual(test, textView)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidBeginEditing() {
        notificationCenter.post(name: UITextView.textDidBeginEditingNotification,
                                object: textView)
    }

    private func _simulateDidChange() {
        notificationCenter.post(name: UITextView.textDidChangeNotification,
                                object: textView)
    }

    private func _simulateDidEndEditing() {
        notificationCenter.post(name: UITextView.textDidEndEditingNotification,
                                object: textView)
    }
}
