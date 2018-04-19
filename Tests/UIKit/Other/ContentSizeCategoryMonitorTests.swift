//
//  ContentSizeCategoryMonitorTests.swift
//  XestiMonitorsTests
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

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func test_preferredContentSizeCategory() {
        let expectedContentSizeCategory: UIContentSizeCategory = .medium
        let monitor = ContentSizeCategoryMonitor { _ in }
        simulateContentSizeDidChange(to: expectedContentSizeCategory, badUserInfo: false)

        XCTAssertEqual(monitor.preferredContentSizeCategory, expectedContentSizeCategory)
    }

    func test_contentSizeDidChange_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedContentSize: UIContentSizeCategory = .medium
        var expectedEvent: ContentSizeCategoryMonitor.Event?
        let monitor = ContentSizeCategoryMonitor(queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateContentSizeDidChange(to: expectedContentSize,
                                     badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(contentSize) = event {
            XCTAssertNotEqual(contentSize, expectedContentSize)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_contentSizeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedContentSize: UIContentSizeCategory = .medium
        var expectedEvent: ContentSizeCategoryMonitor.Event?
        let monitor = ContentSizeCategoryMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateContentSizeDidChange(to: expectedContentSize, badUserInfo: false)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent, case let .didChange(contentSize) = event {
            XCTAssertEqual(contentSize, expectedContentSize)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateContentSizeDidChange(to contentSize: UIContentSizeCategory, badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any ]?
        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIContentSizeCategoryNewValueKey: NSString(string: contentSize.rawValue)]
        }

        notificationCenter.post(name: .UIContentSizeCategoryDidChange,
                                object: application,
                                userInfo: userInfo)
    }
}
