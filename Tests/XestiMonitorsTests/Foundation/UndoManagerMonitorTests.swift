// © 2018–2025 John Gary Pusey (see LICENSE.md)

import XCTest
@testable import XestiMonitors

internal class UndoManagerMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let undoManager = UndoManager()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_checkpoint() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UndoManagerMonitor.Event?
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateCheckpoint()
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
        let monitor = UndoManagerMonitor(undoManager: undoManager) { event  in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidCloseUndoGroup()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidOpenUndoGroup()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidRedoChange()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidUndoChange()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillCloseUndoGroup()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillRedoChange()
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
        let monitor = UndoManagerMonitor(undoManager: self.undoManager) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateWillUndoChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .willUndoChange(test) = event {
            XCTAssertEqual(test, undoManager)
        } else {
            XCTFail("Unexpected Event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateCheckpoint() {
        notificationCenter.post(name: .NSUndoManagerCheckpoint,
                                object: undoManager)
    }

    private func _simulateDidCloseUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerDidCloseUndoGroup,
                                object: undoManager)
    }

    private func _simulateDidOpenUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerDidOpenUndoGroup,
                                object: undoManager)
    }

    private func _simulateDidRedoChange() {
        notificationCenter.post(name: .NSUndoManagerDidRedoChange,
                                object: undoManager)
    }

    private func _simulateDidUndoChange() {
        notificationCenter.post(name: .NSUndoManagerDidUndoChange,
                                object: undoManager)
    }

    private func _simulateWillCloseUndoGroup() {
        notificationCenter.post(name: .NSUndoManagerWillCloseUndoGroup,
                                object: undoManager)
    }

    private func _simulateWillRedoChange() {
        notificationCenter.post(name: .NSUndoManagerWillRedoChange,
                                object: undoManager)
    }

    private func _simulateWillUndoChange() {
        notificationCenter.post(name: .NSUndoManagerWillUndoChange,
                                object: undoManager)
    }
}
