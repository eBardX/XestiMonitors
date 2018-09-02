//
//  FileSystemObjectMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-02-21.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import XCTest
@testable import XestiMonitors

internal class FileSystemObjectMonitorTests: XCTestCase {
    let fileSystem = MockFileSystem()
    let fileURL = URL(fileURLWithPath: "foo.bar").absoluteURL

    var fileSystemObject = MockFileSystemObject(fileDescriptor: -1,
                                                eventMask: [],
                                                queue: nil)

    override func setUp() {
        super.setUp()

        FileSystemObjectInjector.inject = {
            self.fileSystemObject = MockFileSystemObject(fileDescriptor: $0,
                                                         eventMask: $1,
                                                         queue: $2)

            return self.fileSystemObject
        }

        FileSystemInjector.inject = { return self.fileSystem }
    }

    func testMonitor_accessWasRevoked() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .accessWasRevoked,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateAccessWasRevoked()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .accessWasRevoked(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_dataDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .dataDidChange,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDataDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .dataDidChange(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_linkCountDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .linkCountDidChange,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateLinkCountDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .linkCountDidChange(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_metadataDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .metadataDidChange,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateMetadataDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .metadataDidChange(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_sizeDidChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .sizeDidChange,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSizeDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .sizeDidChange(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_wasDeleted() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .wasDeleted,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWasDeleted()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .wasDeleted(test) = event {
            XCTAssertEqual(test, fileURL)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_wasRenamed() {
        let expectation = self.expectation(description: "Handler called")
        let expectedFileURL = URL(fileURLWithPath: "foo.baz").absoluteURL
        var expectedEvent: FileSystemObjectMonitor.Event?
        let monitor = FileSystemObjectMonitor(fileURL: fileURL,
                                              options: .wasRenamed,
                                              queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWasRenamed(to: expectedFileURL)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .wasRenamed(oldURL, newURL) = event {
            XCTAssertEqual(oldURL.path, fileURL.path)
            XCTAssertEqual(newURL.path, expectedFileURL.path)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateAccessWasRevoked() {
        fileSystemObject.updateData(for: .revoke)
    }

    private func simulateDataDidChange() {
        fileSystemObject.updateData(for: .write)
    }

    private func simulateLinkCountDidChange() {
        fileSystemObject.updateData(for: .link)
    }

    private func simulateMetadataDidChange() {
        fileSystemObject.updateData(for: .attrib)
    }

    private func simulateSizeDidChange() {
        fileSystemObject.updateData(for: .extend)
    }

    private func simulateWasDeleted() {
        fileSystemObject.updateData(for: .delete)
    }

    private func simulateWasRenamed(to newURL: URL) {
        fileSystem.rename(to: newURL.path)
        fileSystemObject.updateData(for: .rename)
    }
}
