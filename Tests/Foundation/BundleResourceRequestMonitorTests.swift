//
//  BundleResourceRequestMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import XCTest
@testable import XestiMonitors

internal class BundleResourceRequestMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didLoad() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: BundleResourceRequestMonitor.Event?
        let monitor = BundleResourceRequestMonitor(queue: .main) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateLoadDiskSpace()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .lowDiskSpace)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateLoadDiskSpace() {
        notificationCenter.post(name: .NSBundleResourceRequestLowDiskSpace,
                                object: nil)
    }
}
