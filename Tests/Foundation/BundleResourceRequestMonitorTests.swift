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
    let request = NSBundleResourceRequest(tags: ["bogus"])

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didLoad() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: BundleResourceRequestMonitor.Event?
        let monitor = BundleResourceRequestMonitor(request: request,
                                                   queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateLoadDiskSpace()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .lowDiskSpace(test) = event {
            XCTAssertEqual(test, request)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateLoadDiskSpace() {
        notificationCenter.post(name: .NSBundleResourceRequestLowDiskSpace,
                                object: request)
    }
}
