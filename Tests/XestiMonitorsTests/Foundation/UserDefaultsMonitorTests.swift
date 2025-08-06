// © 2018–2025 John Gary Pusey (see LICENSE.md)

import XCTest
@testable import XestiMonitors

internal class UserDefaultsMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()
    let userDefaults = UserDefaults()

    override func setUp() {
        super.setUp()

        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
    }

    func testMonitor_didChange() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UserDefaultsMonitor.Event?
        let monitor = UserDefaultsMonitor(userDefaults: userDefaults) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDidChange()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .didChange(test) = event {
            XCTAssertEqual(test, userDefaults)
        } else {
            XCTFail("Unexpected event")
        }
    }

#if os(iOS) || os(tvOS) || os(watchOS)
    func testMonitor_sizeLimitExceeded() {
        let expectation = self.expectation(description: "Handler called")
        var expectedEvent: UserDefaultsMonitor.Event?
        let monitor = UserDefaultsMonitor(userDefaults: userDefaults) { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSizeLimitExceeded()
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .sizeLimitExceeded(test) = event {
            XCTAssertEqual(test, userDefaults)
        } else {
            XCTFail("Unexpected event")
        }
    }
#endif

    // MARK: Private Instance Methods

    private func _simulateDidChange() {
        notificationCenter.post(name: UserDefaults.didChangeNotification,
                                object: userDefaults)
    }

#if os(iOS) || os(tvOS) || os(watchOS)
    private func _simulateSizeLimitExceeded() {
        notificationCenter.post(name: UserDefaults.sizeLimitExceededNotification,
                                object: userDefaults)
    }
#endif
}
