// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors

internal class MetadataQueryMonitorTests: XCTestCase {
    let query = NSMetadataQuery()   // MockMetadataQuery()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didFinishGathering() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAddedItems: [Any] = [1]
        let expectedChangedItems: [Any] = [2, 3]
        let expectedRemovedItems: [Any] = [4]
        var expectedEvent: MetadataQueryMonitor.Event?
        let monitor = MetadataQueryMonitor(query: query) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidFinishGathering(addedItems: expectedAddedItems,
                                    changedItems: expectedChangedItems,
                                    removedItems: expectedRemovedItems)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didFinishGathering(info) = event {
            XCTAssertTrue(_compare(info.addedItems, expectedAddedItems))
            XCTAssertTrue(_compare(info.changedItems, expectedChangedItems))
            XCTAssertEqual(info.query, query)
            XCTAssertTrue(_compare(info.removedItems, expectedRemovedItems))
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didStartGathering() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAddedItems: [Any] = [1, 2]
        let expectedChangedItems: [Any] = []
        let expectedRemovedItems: [Any] = [3, 4]
        var expectedEvent: MetadataQueryMonitor.Event?
        let monitor = MetadataQueryMonitor(query: query) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidStartGathering(addedItems: expectedAddedItems,
                                   changedItems: expectedChangedItems,
                                   removedItems: expectedRemovedItems)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didStartGathering(info) = event {
            XCTAssertTrue(_compare(info.addedItems, expectedAddedItems))
            XCTAssertTrue(_compare(info.changedItems, expectedChangedItems))
            XCTAssertEqual(info.query, query)
            XCTAssertTrue(_compare(info.removedItems, expectedRemovedItems))
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didUpdate() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAddedItems: [Any] = []
        let expectedChangedItems: [Any] = [1, 2, 3]
        let expectedRemovedItems: [Any] = []
        var expectedEvent: MetadataQueryMonitor.Event?
        let monitor = MetadataQueryMonitor(query: query) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidUpdate(addedItems: expectedAddedItems,
                           changedItems: expectedChangedItems,
                           removedItems: expectedRemovedItems)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didUpdate(info) = event {
            XCTAssertTrue(_compare(info.addedItems, expectedAddedItems))
            XCTAssertTrue(_compare(info.changedItems, expectedChangedItems))
            XCTAssertEqual(info.query, query)
            XCTAssertTrue(_compare(info.removedItems, expectedRemovedItems))
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_gatheringProgress() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAddedItems: [Any] = []
        let expectedChangedItems: [Any] = []
        let expectedRemovedItems: [Any] = []
        var expectedEvent: MetadataQueryMonitor.Event?
        let monitor = MetadataQueryMonitor(query: query) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateGatheringProgress(addedItems: expectedAddedItems,
                                   changedItems: expectedChangedItems,
                                   removedItems: expectedRemovedItems)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .gatheringProgress(info) = event {
            XCTAssertTrue(_compare(info.addedItems, expectedAddedItems))
            XCTAssertTrue(_compare(info.changedItems, expectedChangedItems))
            XCTAssertEqual(info.query, query)
            XCTAssertTrue(_compare(info.removedItems, expectedRemovedItems))
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _compare(_ items1: [Any],
                          _ items2: [Any]) -> Bool {
        guard let items1 = items1 as? [Int],
              let items2 = items2 as? [Int]
        else { return false }

        return items1 == items2
    }

    private func _makeUserInfo(addedItems: [Any],
                               changedItems: [Any],
                               removedItems: [Any]) -> [AnyHashable: Any]? {
        if addedItems.isEmpty && changedItems.isEmpty && removedItems.isEmpty {
            return nil
        }

        var userInfo: [AnyHashable: Any] = [:]

        if !addedItems.isEmpty {
            userInfo[NSMetadataQueryUpdateAddedItemsKey] = addedItems
        }

        if !changedItems.isEmpty {
            userInfo[NSMetadataQueryUpdateChangedItemsKey] = changedItems
        }

        if !removedItems.isEmpty {
            userInfo[NSMetadataQueryUpdateRemovedItemsKey] = removedItems
        }

        return userInfo
    }

    private func _simulateDidFinishGathering(addedItems: [Any],
                                             changedItems: [Any],
                                             removedItems: [Any]) {
        let userInfo = _makeUserInfo(addedItems: addedItems,
                                     changedItems: changedItems,
                                     removedItems: removedItems)

        notificationCenter.post(name: .NSMetadataQueryDidFinishGathering,
                                object: query,
                                userInfo: userInfo)
    }

    private func _simulateDidStartGathering(addedItems: [Any],
                                            changedItems: [Any],
                                            removedItems: [Any]) {
        let userInfo = _makeUserInfo(addedItems: addedItems,
                                     changedItems: changedItems,
                                     removedItems: removedItems)

        notificationCenter.post(name: .NSMetadataQueryDidStartGathering,
                                object: query,
                                userInfo: userInfo)
    }

    private func _simulateDidUpdate(addedItems: [Any],
                                    changedItems: [Any],
                                    removedItems: [Any]) {
        let userInfo = _makeUserInfo(addedItems: addedItems,
                                     changedItems: changedItems,
                                     removedItems: removedItems)

        notificationCenter.post(name: .NSMetadataQueryDidUpdate,
                                object: query,
                                userInfo: userInfo)
    }

    private func _simulateGatheringProgress(addedItems: [Any],
                                            changedItems: [Any],
                                            removedItems: [Any]) {
        let userInfo = _makeUserInfo(addedItems: addedItems,
                                     changedItems: changedItems,
                                     removedItems: removedItems)

        notificationCenter.post(name: .NSMetadataQueryGatheringProgress,
                                object: query,
                                userInfo: userInfo)
    }
}
