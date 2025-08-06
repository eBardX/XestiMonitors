// © 2018–2025 John Gary Pusey (see LICENSE.md).

import XCTest
@testable import XestiMonitors

internal class BundleResourceRequestMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didLoad() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: BundleResourceRequestMonitor.Event?
        let monitor = BundleResourceRequestMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateLoadDiskSpace()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent {
            XCTAssertEqual(event, .lowDiskSpace)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateLoadDiskSpace() {
        notificationCenter.post(name: .NSBundleResourceRequestLowDiskSpace,
                                object: nil)
    }
}
