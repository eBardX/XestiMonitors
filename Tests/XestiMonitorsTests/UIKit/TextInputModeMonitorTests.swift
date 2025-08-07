// © 2018–2025 John Gary Pusey (see LICENSE.md)

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
        let monitor = TextInputModeMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, textInputMode)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidChange() {
        notificationCenter.post(name: UITextInputMode.currentInputModeDidChangeNotification,
                                object: textInputMode)
    }
}
