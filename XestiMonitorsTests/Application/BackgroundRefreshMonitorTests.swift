//
//  BackgroundRefreshMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class BackgroundRefreshMonitorTests: XCTestCase {

    let application = MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {

        super.setUp()

        application.backgroundRefreshStatus = .restricted

    }

    func testMonitor_statusDidChange() {

        let expectation = self.expectation(description: "Handler called")
        let expectedStatus: UIBackgroundRefreshStatus = .available
        var expectedEvent: BackgroundRefreshMonitor.Event?
        let monitor = BackgroundRefreshMonitor(notificationCenter: notificationCenter,
                                               queue: .main,
                                               application: application) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateStatusDidChange(to: expectedStatus)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .statusDidChange(status) = event {
            XCTAssertEqual(status, expectedStatus)
        } else {
            XCTFail("Unexpected event")
        }

    }

    func testStatus() {

        let expectedStatus: UIBackgroundRefreshStatus = .denied
        let monitor = BackgroundRefreshMonitor(notificationCenter: notificationCenter,
                                               queue: .main,
                                               application: application) { _ in }

        simulateStatusDidChange(to: expectedStatus)

        XCTAssertEqual(monitor.status, expectedStatus)

    }

    private func simulateStatusDidChange(to status: UIBackgroundRefreshStatus) {

        application.backgroundRefreshStatus = status

        notificationCenter.post(name: .UIApplicationBackgroundRefreshStatusDidChange,
                                object: application)

    }

}
