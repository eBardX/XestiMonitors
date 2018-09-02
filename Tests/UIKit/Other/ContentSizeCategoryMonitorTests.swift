//
//  ContentSizeCategoryMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Angie Mugo on 2018-04-11.
//
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

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_contentSizeDidChange_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = ContentSizeCategoryMonitor(queue: .main) { _ in
            XCTAssertEqual(OperationQueue.current, .main)

            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateContentSizeCategoryDidChange(to: .extraExtraExtraLarge,
                                             badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_contentSizeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedContentSizeCategory: UIContentSizeCategory = .extraLarge
        var expectedEvent: ContentSizeCategoryMonitor.Event?
        let monitor = ContentSizeCategoryMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateContentSizeCategoryDidChange(to: expectedContentSizeCategory)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, expectedContentSizeCategory)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func test_preferred() {
        let expectedContentSizeCategory: UIContentSizeCategory = .small
        let monitor = ContentSizeCategoryMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        simulateContentSizeCategoryDidChange(to: expectedContentSizeCategory)

        XCTAssertEqual(monitor.preferred, expectedContentSizeCategory)
    }

    private func simulateContentSizeCategoryDidChange(to category: UIContentSizeCategory,
                                                      badUserInfo: Bool = false) {
        application.preferredContentSizeCategory = category

        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIContentSizeCategoryNewValueKey: category.rawValue]
        }

        notificationCenter.post(name: .UIContentSizeCategoryDidChange,
                                object: application,
                                userInfo: userInfo)
    }
}
