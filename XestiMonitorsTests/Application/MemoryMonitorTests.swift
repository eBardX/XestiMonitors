//
//  MemoryMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class MemoryMonitorTests: XCTestCase {

    let application = UIApplication.shared  // MockApplication()
    let notificationCenter = MockNotificationCenter()

    func testMonitor_didReceiveWarning() {

        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: MemoryMonitor.Event?
        let monitor = MemoryMonitor(notificationCenter: notificationCenter,
                                    queue: .main) { event in
                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidReceiveMemoryWarning()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .didReceiveWarning)
        } else {
            XCTFail("Unexpected event")
        }

    }

    private func simulateDidReceiveMemoryWarning() {

        notificationCenter.post(name: .UIApplicationDidReceiveMemoryWarning,
                                object: application)

    }

}
