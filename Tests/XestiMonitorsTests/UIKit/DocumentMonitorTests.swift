// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class DocumentMonitorTests: XCTestCase {
    let document = UIDocument(fileURL: Bundle.main.bundleURL)
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: DocumentMonitor.Event?
        let monitor = DocumentMonitor(document: document) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateStateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .stateDidChange(test) = event {
            XCTAssertEqual(test, document)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateStateDidChange() {
        notificationCenter.post(name: UIDocument.stateChangedNotification,
                                object: document)
    }
}
