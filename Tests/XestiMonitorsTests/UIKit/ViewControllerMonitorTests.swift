// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class ViewControllerMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let viewController = UIViewController()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_showDetailTargetDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ViewControllerMonitor.Event?
        let monitor = ViewControllerMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateShowDetailTargetDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .showDetailTargetDidChange(test) = event {
            XCTAssertEqual(test, viewController)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateShowDetailTargetDidChange() {
        notificationCenter.post(name: UIViewController.showDetailTargetDidChangeNotification,
                                object: viewController)
    }
}
