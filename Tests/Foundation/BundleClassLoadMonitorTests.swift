//
//  BundleClassLoadMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-05-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md).
//

import XCTest
@testable import XestiMonitors

internal class BundleClassLoadMonitorTests: XCTestCase {
    let bundle = Bundle.main
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_contentSizeDidChange_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")

        expectation.isInverted = true

        let monitor = BundleClassLoadMonitor(bundle: bundle,
                                             queue: .main) { _ in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidLoad(with: [],
                        badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()
    }

    func testMonitor_didLoad() {
        let expectation = self.expectation(description: "Handler called")
        let expectedLoadedClasses: [String] = ["Fubar", "Plover"]
        var expectedEvent: BundleClassLoadMonitor.Event?
        let monitor = BundleClassLoadMonitor(bundle: bundle,
                                             queue: .main) { event in
                                                XCTAssertEqual(OperationQueue.current, .main)

                                                expectedEvent = event
                                                expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidLoad(with: expectedLoadedClasses)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didLoad(test, loadedClasses) = event {
            XCTAssertEqual(test, bundle)
            XCTAssertEqual(loadedClasses, expectedLoadedClasses)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateDidLoad(with loadedClasses: [String],
                                 badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = [NSLoadedClasses: loadedClasses]
        }

        notificationCenter.post(name: Bundle.didLoadNotification,
                                object: bundle,
                                userInfo: userInfo)
    }
}
