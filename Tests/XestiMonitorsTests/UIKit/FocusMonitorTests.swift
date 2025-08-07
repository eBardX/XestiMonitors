//// © 2018–2025 John Gary Pusey (see LICENSE.md)
//
// import UIKit
// import XCTest
// @testable import XestiMonitors
//
// internal class FocusMonitorTests: XCTestCase {
//    let notificationCenter = MockNotificationCenter()
//
//// #if os(tvOS)
//    let context = UIFocusUpdateContext()
//// #else
////    let context = UIFocusUpdateContext.make()
//// #endif
//
//    let coordinator = UIFocusAnimationCoordinator()
//
//    override func setUp() {
//        super.setUp()
//
//        DependencyResolver.register(notificationCenter as any NotificationCenterProtocol)
//    }
//
//    func testMonitor_didUpdate() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FocusMonitor.Event?
//        let monitor = FocusMonitor { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateDidUpdate()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .didUpdate(info) = event {
//            XCTAssertEqual(info.context, context)
//            XCTAssertEqual(info.coordinator, coordinator)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    func testMonitor_didUpdate_badUserInfo() {
//        let expectation = self.expectation(description: "Handler called")
//
//        expectation.isInverted = true
//
//        let monitor = FocusMonitor { _ in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateDidUpdate(badUserInfo: true)
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//    }
//
//    func testMonitor_movementDidFail() {
//        let expectation = self.expectation(description: "Handler called")
//        var expectedEvent: FocusMonitor.Event?
//        let monitor = FocusMonitor { event in
//            XCTAssertEqual(OperationQueue.current, .main)
//
//            expectedEvent = event
//            expectation.fulfill()
//        }
//
//        monitor.startMonitoring()
//        simulateMovementDidFail()
//        waitForExpectations(timeout: 1)
//        monitor.stopMonitoring()
//
//        if let event = expectedEvent,
//           case let .movementDidFail(info) = event {
//            XCTAssertEqual(info.context, context)
//        } else {
//            XCTFail("Unexpected event")
//        }
//    }
//
//    private func _simulateDidUpdate(badUserInfo: Bool = false) {
//        let userInfo: [AnyHashable: Any]?
//
//        if badUserInfo {
//            userInfo = nil
//        } else {
//            userInfo = [UIFocusSystem.animationCoordinatorUserInfoKey: coordinator,
//                        UIFocusSystem.focusUpdateContextUserInfoKey: context]
//        }
//
//        notificationCenter.post(name: UIFocusSystem.didUpdateNotification,
//                                object: nil,
//                                userInfo: userInfo)
//    }
//
//    private func _simulateMovementDidFail() {
//        let userInfo = [UIFocusSystem.focusUpdateContextUserInfoKey: context]
//
//        notificationCenter.post(name: UIFocusSystem.movementDidFailNotification,
//                                object: nil,
//                                userInfo: userInfo)
//    }
// }
