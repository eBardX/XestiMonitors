//
//  ContentSizeCategoryMonitorTests.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-04-11.
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ContentSizeCategoryMonitorTests: XCTestCase {
    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        ApplicationInjector.inject = { return self.application }
        application.preferredContentSizeCategory = .medium
        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_ContentSizeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedContentSize: UIContentSizeCategory = .extraLarge
        var expectedEvent: ContentSizeCategoryMonitor.Event?
        let monitor = ContentSizeCategoryMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateContentSizeDidChange(to: expectedContentSize)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent, case let .didChange(contentSize) = event {
            XCTAssertEqual(contentSize, expectedContentSize)
        } else {
            XCTFail("Unexpected event")
        }
    }
    
    private func simulateContentSizeDidChange(to contentSize: UIContentSizeCategory) {
        application.preferredContentSizeCategory = contentSize
        notificationCenter.post(name: .UIContentSizeCategoryDidChange, object: application)
    }
}
