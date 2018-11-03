//
//  DocumentStateMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-16.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class DocumentStateMonitorTests: XCTestCase {
    let document = UIDocument(fileURL: Bundle.main.bundleURL)
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: DocumentStateMonitor.Event?
        let monitor = DocumentStateMonitor(document: document,
                                           queue: .main) { event in
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
            XCTAssertEqual(test, document)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: .UIDocumentStateChanged,
                                object: document)
    }
}
