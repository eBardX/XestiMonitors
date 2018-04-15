//
//  ViewControllerShowDetailTargetMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-16.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class ViewControllerShowDetailTargetMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let viewController = UIViewController()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_stateDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ViewControllerShowDetailTargetMonitor.Event?
        let monitor = ViewControllerShowDetailTargetMonitor(queue: .main) { event in
            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(vc) = event {
            XCTAssertEqual(vc, viewController)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: .UIViewControllerShowDetailTargetDidChange,
                                object: viewController)
    }
}
