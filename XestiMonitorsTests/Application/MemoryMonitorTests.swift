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

    let notificationCenter = MockNotificationCenter()

    func testBasic() {

        let expect = expectation(description: "Handler called on main thread")
        var outEvent: MemoryMonitor.Event?
        let monitor = MemoryMonitor(notificationCenter: notificationCenter,
                                    queue: .main) { event in
                                        outEvent = event
                                        expect.fulfill()
        }

        XCTAssertTrue(monitor.startMonitoring())

        defer { monitor.stopMonitoring() }

        simulateDidReceiveMemoryWarning()

        wait(for: [expect],
             timeout: 1.0)

        XCTAssertEqual(outEvent, .some(.didReceiveWarning))

    }

    private func simulateDidReceiveMemoryWarning() {

        notificationCenter.post(name: .UIApplicationDidReceiveMemoryWarning,
                                object: nil)

    }

}
