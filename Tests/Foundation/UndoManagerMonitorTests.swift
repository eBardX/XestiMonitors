//
//  UndoManagerMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by Rose Maina on 2018-04-30.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

internal class UndoManagerMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let undoManager = UndoManager()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    func testMonitor_checkpoint() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .checkpoint,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateCheckpoint()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .checkpoint(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didCloseUndoGroup() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: undoManager,
                                         options: .didCloseUndoGroup,
                                         queue: .main) { event  in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidCloseUndoGroup()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didCloseUndoGroup(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didOpenUndoGroup() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .didOpenUndoGroup,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidOpenUndoGroup()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didOpenUndoGroup(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didRedoChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .didRedoChange,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidRedoChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didRedoChange(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_didUndoChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .didUndoChange,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidUndoChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didUndoChange(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willCloseUndoGroup() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .willCloseUndoGroup,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillCloseUndoGroup()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willCloseUndoGroup(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willRedoChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .willRedoChange,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillRedoChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willRedoChange(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    func testMonitor_willUndoChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager,
                                         options: .willUndoChange,
                                         queue: .main) { event in
                                            expectedEvent = event
                                            expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillUndoChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willUndoChange(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    private func simulateCheckpoint() {
        notificationCenter.post(name: .NSUndoManagerCheckpoint,
                                object: undoManager)
    }

    private func simulateDidCloseUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerDidCloseUndoGroup,
                                object: undoManager)
    }

    private func simulateDidOpenUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerDidOpenUndoGroup,
                                object: undoManager)
    }

    private func simulateDidRedoChange() {
        notificationCenter.post(name: .NSUndoManagerDidRedoChange,
                                object: undoManager)
    }

    private func simulateDidUndoChange() {
        notificationCenter.post(name: .NSUndoManagerDidUndoChange,
                                object: undoManager)
    }

    private func simulateWillCloseUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerWillCloseUndoGroup,
                                object: undoManager)
    }

    private func simulateWillRedoChange() {
        notificationCenter.post(name: .NSUndoManagerWillRedoChange,
                                object: undoManager)
    }

    private func simulateWillUndoChange() {
        notificationCenter.post(name: .NSUndoManagerWillUndoChange,
                                object: undoManager)
    }
}
