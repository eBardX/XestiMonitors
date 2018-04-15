//
//  BaseMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-04-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class BaseMonitorTests: XCTestCase {
    func testMonitor_isMonitoring_false1() {
        let monitor = BaseMonitor()

        XCTAssertFalse(monitor.isMonitoring)
    }

    func testMonitor_isMonitoring_false2() {
        let monitor = BaseMonitor()

        monitor.startMonitoring()
        monitor.stopMonitoring()

        XCTAssertFalse(monitor.isMonitoring)
    }

    func testMonitor_isMonitoring_true() {
        let monitor = BaseMonitor()

        monitor.startMonitoring()

        XCTAssertTrue(monitor.isMonitoring)
    }
}
