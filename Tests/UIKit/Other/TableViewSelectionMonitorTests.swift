//
//  TableViewSelectionMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Rose Maina on 2018-04-20.
//
// © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class TableViewSelectionMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let tableView = UITableView()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Hander called")
        var expectedEvent: TableViewSectionMonitor.Event?
        let monitor = TableViewSectionMonitor(tableView: self.tableView,
                                              queue: .main) { event in
                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChange(test) = event {
            XCTAssertEqual(test, tableView)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateDidChange() {
        notificationCenter.post(name: .UITableViewSelectionDidChange,
                                object: tableView)
    }
}
