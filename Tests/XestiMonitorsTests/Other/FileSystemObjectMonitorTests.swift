//// © 2018–2025 John Gary Pusey (see LICENSE.md)
//
// import XCTest
// @testable import XestiMonitors
//
// internal class FileSystemObjectMonitorTests: XCTestCase {
//    let fileSystem = MockFileSystem()
//    let fileURL = URL(fileURLWithPath: "foo.bar").absoluteURL
//
//    let makeFileSystemObject: MakeFileSystemObject = {
//        DispatchSource.makeFileSystemObjectSource(fileDescriptor: $0,
//                                                  eventMask: $1,
//                                                  queue: $2) as! DispatchSource // swiftlint:disable:this force_cast
//    }
//
//    var fileSystemObject = MockFileSystemObject(fileDescriptor: -1,
//                                                eventMask: [],
//                                                queue: nil)
//
//    override func setUp() {
//        super.setUp()
//
//        DependencyResolver.register(makeFileSystemObject)
//
//        DependencyResolver.register(fileSystem as any FileSystemProtocol)
//    }
//
//    func testMonitor_accessWasRevoked() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateAccessWasRevoked()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .accessWasRevoked(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_dataDidChange() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateDataDidChange()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .dataDidChange(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_linkCountDidChange() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateLinkCountDidChange()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .linkCountDidChange(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_metadataDidChange() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateMetadataDidChange()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .metadataDidChange(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_sizeDidChange() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateSizeDidChange()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .sizeDidChange(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_wasDeleted() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateWasDeleted()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .wasDeleted(test) = event {
//            XCTAssertEqual(test, fileURL)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_wasRenamed() {
//        let expectation = self.expectation(description: "Handler called")
//        let expectedFileURL = URL(fileURLWithPath: "foo.baz").absoluteURL
//        var expectedEvent: FileSystemObjectMonitor.Event?
//        let monitor = FileSystemObjectMonitor(fileURL: fileURL) { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateWasRenamed(to: expectedFileURL)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .wasRenamed(oldURL, newURL) = event {
//            XCTAssertEqual(oldURL.path, fileURL.path)
//            XCTAssertEqual(newURL.path, expectedFileURL.path)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    private func _simulateAccessWasRevoked() {
//        fileSystemObject.updateData(for: .revoke)
//    }
//
//    private func _simulateDataDidChange() {
//        fileSystemObject.updateData(for: .write)
//    }
//
//    private func _simulateLinkCountDidChange() {
//        fileSystemObject.updateData(for: .link)
//    }
//
//    private func _simulateMetadataDidChange() {
//        fileSystemObject.updateData(for: .attrib)
//    }
//
//    private func _simulateSizeDidChange() {
//        fileSystemObject.updateData(for: .extend)
//    }
//
//    private func _simulateWasDeleted() {
//        fileSystemObject.updateData(for: .delete)
//    }
//
//    private func _simulateWasRenamed(to newURL: URL) {
//        fileSystem.rename(to: newURL.path)
//        fileSystemObject.updateData(for: .rename)
//    }
// }
