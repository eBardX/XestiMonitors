//
//  KeyboardMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

// swiftlint:disable type_body_length

internal class KeyboardMonitorTests: XCTestCase {
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

    func testMonitor_didChangeFrame() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeIn
        let expectedAnimationDuration: TimeInterval = 0.15
        let expectedFrameBegin = CGRect(x: 11, y: 21, width: 31, height: 41)
        let expectedFrameEnd = CGRect(x: 51, y: 61, width: 71, height: 81)
        let expectedIsLocal = true
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .didChangeFrame,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChangeFrame(animationCurve: expectedAnimationCurve,
                               animationDuration: expectedAnimationDuration,
                               frameBegin: expectedFrameBegin,
                               frameEnd: expectedFrameEnd,
                               isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChangeFrame(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didChangeFrame_badUserInfo() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeIn
        let expectedAnimationDuration: TimeInterval = 0.15
        let expectedFrameBegin = CGRect(x: 11, y: 21, width: 31, height: 41)
        let expectedFrameEnd = CGRect(x: 51, y: 61, width: 71, height: 81)
        let expectedIsLocal = false
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .didChangeFrame,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidChangeFrame(animationCurve: expectedAnimationCurve,
                               animationDuration: expectedAnimationDuration,
                               frameBegin: expectedFrameBegin,
                               frameEnd: expectedFrameEnd,
                               isLocal: expectedIsLocal,
                               badUserInfo: true)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didChangeFrame(info) = event {
            XCTAssertNotEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertNotEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertNotEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertNotEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertNotEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didHide() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeOut
        let expectedAnimationDuration: TimeInterval = 0.25
        let expectedFrameBegin = CGRect(x: 12, y: 22, width: 32, height: 42)
        let expectedFrameEnd = CGRect(x: 52, y: 62, width: 72, height: 82)
        let expectedIsLocal = false
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .didHide,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidHide(animationCurve: expectedAnimationCurve,
                        animationDuration: expectedAnimationDuration,
                        frameBegin: expectedFrameBegin,
                        frameEnd: expectedFrameEnd,
                        isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didHide(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_didShow() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeInOut
        let expectedAnimationDuration: TimeInterval = 0.35
        let expectedFrameBegin = CGRect(x: 13, y: 23, width: 33, height: 43)
        let expectedFrameEnd = CGRect(x: 53, y: 63, width: 73, height: 83)
        let expectedIsLocal = true
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .didShow,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDidShow(animationCurve: expectedAnimationCurve,
                        animationDuration: expectedAnimationDuration,
                        frameBegin: expectedFrameBegin,
                        frameEnd: expectedFrameEnd,
                        isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .didShow(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willChangeFrame() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeIn
        let expectedAnimationDuration: TimeInterval = 0.45
        let expectedFrameBegin = CGRect(x: 14, y: 24, width: 34, height: 44)
        let expectedFrameEnd = CGRect(x: 54, y: 64, width: 74, height: 84)
        let expectedIsLocal = false
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .willChangeFrame,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillChangeFrame(animationCurve: expectedAnimationCurve,
                                animationDuration: expectedAnimationDuration,
                                frameBegin: expectedFrameBegin,
                                frameEnd: expectedFrameEnd,
                                isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willChangeFrame(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willHide() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeOut
        let expectedAnimationDuration: TimeInterval = 0.55
        let expectedFrameBegin = CGRect(x: 15, y: 25, width: 35, height: 45)
        let expectedFrameEnd = CGRect(x: 55, y: 65, width: 75, height: 85)
        let expectedIsLocal = true
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .willHide,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillHide(animationCurve: expectedAnimationCurve,
                         animationDuration: expectedAnimationDuration,
                         frameBegin: expectedFrameBegin,
                         frameEnd: expectedFrameEnd,
                         isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willHide(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_willShow() {
        let expectation = self.expectation(description: "Handler called")
        let expectedAnimationCurve: UIViewAnimationCurve = .easeInOut
        let expectedAnimationDuration: TimeInterval = 0.65
        let expectedFrameBegin = CGRect(x: 16, y: 26, width: 36, height: 46)
        let expectedFrameEnd = CGRect(x: 56, y: 66, width: 76, height: 86)
        let expectedIsLocal = false
        var expectedEvent: KeyboardMonitor.Event?
        let monitor = KeyboardMonitor(options: .willShow,
                                      queue: .main) { event in
                                        XCTAssertEqual(OperationQueue.current, .main)

                                        expectedEvent = event
                                        expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateWillShow(animationCurve: expectedAnimationCurve,
                         animationDuration: expectedAnimationDuration,
                         frameBegin: expectedFrameBegin,
                         frameEnd: expectedFrameEnd,
                         isLocal: expectedIsLocal)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .willShow(info) = event {
            XCTAssertEqual(info.animationCurve, expectedAnimationCurve)
            XCTAssertEqual(info.animationDuration, expectedAnimationDuration)
            XCTAssertEqual(info.frameBegin, expectedFrameBegin)
            XCTAssertEqual(info.frameEnd, expectedFrameEnd)
            XCTAssertEqual(info.isLocal, expectedIsLocal)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func makeUserInfo(animationCurve: UIViewAnimationCurve,
                              animationDuration: TimeInterval,
                              frameBegin: CGRect,
                              frameEnd: CGRect,
                              isLocal: Bool) -> [AnyHashable: Any] {
        return [UIKeyboardAnimationCurveUserInfoKey: NSNumber(value: animationCurve.rawValue),
                UIKeyboardAnimationDurationUserInfoKey: NSNumber(value: animationDuration),
                UIKeyboardFrameBeginUserInfoKey: NSValue(cgRect: frameBegin),
                UIKeyboardFrameEndUserInfoKey: NSValue(cgRect: frameEnd),
                UIKeyboardIsLocalUserInfoKey: NSNumber(value: isLocal)]
    }

    private func simulateDidChangeFrame(animationCurve: UIViewAnimationCurve,
                                        animationDuration: TimeInterval,
                                        frameBegin: CGRect,
                                        frameEnd: CGRect,
                                        isLocal: Bool,
                                        badUserInfo: Bool = false) {
        let userInfo: [AnyHashable: Any]?

        if badUserInfo {
            userInfo = nil
        } else {
            userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)
        }

        notificationCenter.post(name: .UIKeyboardDidChangeFrame,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateDidHide(animationCurve: UIViewAnimationCurve,
                                 animationDuration: TimeInterval,
                                 frameBegin: CGRect,
                                 frameEnd: CGRect,
                                 isLocal: Bool) {
        let userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)

        notificationCenter.post(name: .UIKeyboardDidHide,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateDidShow(animationCurve: UIViewAnimationCurve,
                                 animationDuration: TimeInterval,
                                 frameBegin: CGRect,
                                 frameEnd: CGRect,
                                 isLocal: Bool) {
        let userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)

        notificationCenter.post(name: .UIKeyboardDidShow,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateWillChangeFrame(animationCurve: UIViewAnimationCurve,
                                         animationDuration: TimeInterval,
                                         frameBegin: CGRect,
                                         frameEnd: CGRect,
                                         isLocal: Bool) {
        let userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)

        notificationCenter.post(name: .UIKeyboardWillChangeFrame,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateWillHide(animationCurve: UIViewAnimationCurve,
                                  animationDuration: TimeInterval,
                                  frameBegin: CGRect,
                                  frameEnd: CGRect,
                                  isLocal: Bool) {
        let userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)

        notificationCenter.post(name: .UIKeyboardWillHide,
                                object: nil,
                                userInfo: userInfo)
    }

    private func simulateWillShow(animationCurve: UIViewAnimationCurve,
                                  animationDuration: TimeInterval,
                                  frameBegin: CGRect,
                                  frameEnd: CGRect,
                                  isLocal: Bool) {
        let userInfo = makeUserInfo(animationCurve: animationCurve,
                                    animationDuration: animationDuration,
                                    frameBegin: frameBegin,
                                    frameEnd: frameEnd,
                                    isLocal: isLocal)

        notificationCenter.post(name: .UIKeyboardWillShow,
                                object: nil,
                                userInfo: userInfo)
    }
}

// swiftlint:enable type_body_length
