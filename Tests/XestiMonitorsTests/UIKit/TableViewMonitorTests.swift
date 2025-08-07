// © 2018–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

internal class TableViewMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let tableView = UITableView()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Hander called")
        var expectedEvent: TableViewMonitor.Event?
        let monitor = TableViewMonitor(tableView: tableView) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSelectionDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .selectionDidChange(test) = event {
            XCTAssertEqual(test, tableView)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateSelectionDidChange() {
        notificationCenter.post(name: UITableView.selectionDidChangeNotification,
                                object: tableView)
    }
}
