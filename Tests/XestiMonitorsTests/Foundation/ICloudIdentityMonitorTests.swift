// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation
import XCTest
@testable import XestiMonitors
import XestiTools

internal class ICloudIdentityMonitorTests: XCTestCase {
    let fileManager = MockFileManager()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        FileManagerInjector.inject = { self.fileManager }

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChange_nil() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: ICloudIdentityMonitor.Event?
        let monitor = ICloudIdentityMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange(to: nil)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didChange(token) = event {
            XCTAssertNil(token)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didChange_nonNil() {
        let expectation = self.expectation(description: "Handler called")
        let expectedIdentity = ICloudIdentity("bogus" as ICloudIdentity.Token)
        var expectedEvent: ICloudIdentityMonitor.Event?
        let monitor = ICloudIdentityMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange(to: expectedIdentity)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didChange(actualIdentity) = event {
            XCTAssertEqual(actualIdentity, expectedIdentity)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateDidChange(to identity: ICloudIdentity?) {
        fileManager.ubiquityIdentityToken = identity?.token

        notificationCenter.post(name: .NSUbiquityIdentityDidChange,
                                object: nil)
    }
}
