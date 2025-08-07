// © 2018–2025 John Gary Pusey (see LICENSE.md).

import UIKit
import XCTest
@testable import XestiMonitors

internal class ContentSizeCategoryMonitorTests: XCTestCase {
    let app = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        AppInjector.inject = { self.app }

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_contentSizeDidChange_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = ContentSizeCategoryMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)

            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateContentSizeCategoryDidChange(to: .extraExtraExtraLarge,
                                              badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_contentSizeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedContentSizeCategory: UIContentSizeCategory = .extraLarge
        var expectedEvent: ContentSizeCategoryMonitor.Event?
        let monitor = ContentSizeCategoryMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateContentSizeCategoryDidChange(to: expectedContentSizeCategory)
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

        _simulateContentSizeCategoryDidChange(to: expectedContentSizeCategory)

        XCTAssertEqual(monitor.preferred, expectedContentSizeCategory)
    }

    // MARK: Private Instance Methods

    private func _simulateContentSizeCategoryDidChange(to category: UIContentSizeCategory,
                                                       badUserInfo: Bool = false) {
        app.preferredContentSizeCategory = category

        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [UIContentSizeCategory.newValueUserInfoKey: category.rawValue]
        }

        notificationCenter.post(name: UIContentSizeCategory.didChangeNotification,
                                object: app,
                                userInfo: userInfo)
    }
}
