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

    let application = UIApplication.shared  // MockApplication()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {

        //application.backgroundRefreshStatus = .available

    }

    func testMonitor_statusDidChange() {

        let expectation = self.expectation(description: "Handler called")
        let expectedStatus: UIBackgroundRefreshStatus = .denied
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

    private func simulateStatusDidChange(to status: UIBackgroundRefreshStatus) {

        //application.backgroundRefreshStatus = status

        notificationCenter.post(name: .UIApplicationBackgroundRefreshStatusDidChange,
                                object: application)

    }

}
