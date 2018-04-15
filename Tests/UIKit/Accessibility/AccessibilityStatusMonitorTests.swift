//
//  AccessibilityStatusMonitorTests.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2017-12-27.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit
import XCTest
@testable import XestiMonitors

// swiftlint:disable file_length type_body_length

internal class AccessibilityStatusMonitorTests: XCTestCase {
    let accessibilityStatus = MockAccessibilityStatus()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        AccessibilityStatusInjector.inject = { return self.accessibilityStatus }

        accessibilityStatus.mockDarkerSystemColorsEnabled = false

        if #available(iOS 10.0, *) {
            accessibilityStatus.mockHearingDevicePairedEar = []
        }

        if #available(iOS 10.0, *) {
            accessibilityStatus.mockIsAssistiveTouchRunning = false
        }

        accessibilityStatus.mockIsBoldTextEnabled = false
        accessibilityStatus.mockIsClosedCaptioningEnabled = false
        accessibilityStatus.mockIsGrayscaleEnabled = false
        accessibilityStatus.mockIsGuidedAccessEnabled = false
        accessibilityStatus.mockIsInvertColorsEnabled = false
        accessibilityStatus.mockIsMonoAudioEnabled = false
        accessibilityStatus.mockIsReduceMotionEnabled = false
        accessibilityStatus.mockIsReduceTransparencyEnabled = false
        accessibilityStatus.mockIsShakeToUndoEnabled = false
        accessibilityStatus.mockIsSpeakScreenEnabled = false
        accessibilityStatus.mockIsSpeakSelectionEnabled = false
        accessibilityStatus.mockIsSwitchControlRunning = false
        accessibilityStatus.mockIsVoiceOverRunning = false

        NotificationCenterInjector.inject = { return self.notificationCenter }
    }

    #if os(iOS)
    func testHearingDevicePairedEar() {
        if #available(iOS 10.0, *) {
            let expectedValue: UIAccessibilityHearingDeviceEar = .left
            let monitor = AccessibilityStatusMonitor(options: .hearingDevicePairedEarDidChange,
                                                     queue: .main) { _ in }

            simulateHearingDevicePairedEarDidChange(to: expectedValue)

            XCTAssertEqual(monitor.hearingDevicePairedEar, expectedValue)
        }
    }
    #endif

    func testIsAssistiveTouchEnabled() {
        if #available(iOS 10.0, tvOS 10.0, *) {
            let expectedValue: Bool = true
            let monitor = AccessibilityStatusMonitor(options: .assistiveTouchStatusDidChange,
                                                     queue: .main) { _ in }

            simulateAssistiveTouchStatusDidChange(to: expectedValue)

            XCTAssertEqual(monitor.isAssistiveTouchEnabled, expectedValue)
        }
    }

    func testIsBoldTextEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .boldTextStatusDidChange,
                                                 queue: .main) { _ in }

        simulateBoldTextStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isBoldTextEnabled, expectedValue)
    }

    func testIsClosedCaptioningEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .closedCaptioningStatusDidChange,
                                                 queue: .main) { _ in }

        simulateClosedCaptioningStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isClosedCaptioningEnabled, expectedValue)
    }

    func testIsDarkenColorsEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .darkenColorsStatusDidChange,
                                                 queue: .main) { _ in }

        simulateDarkenColorsStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isDarkenColorsEnabled, expectedValue)
    }

    func testIsGrayscaleEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .grayscaleStatusDidChange,
                                                 queue: .main) { _ in }

        simulateGrayscaleStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isGrayscaleEnabled, expectedValue)
    }

    func testIsGuidedAccessEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .guidedAccessStatusDidChange,
                                                 queue: .main) { _ in }

        simulateGuidedAccessStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isGuidedAccessEnabled, expectedValue)
    }

    func testIsInvertColorsEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .invertColorsStatusDidChange,
                                                 queue: .main) { _ in }

        simulateInvertColorsStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isInvertColorsEnabled, expectedValue)
    }

    func testIsMonoAudioEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .monoAudioStatusDidChange,
                                                 queue: .main) { _ in }

        simulateMonoAudioStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isMonoAudioEnabled, expectedValue)
    }

    func testIsReduceMotionEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .reduceMotionStatusDidChange,
                                                 queue: .main) { _ in }

        simulateReduceMotionStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isReduceMotionEnabled, expectedValue)
    }

    func testIsReduceTransparencyEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .reduceTransparencyStatusDidChange,
                                                 queue: .main) { _ in }

        simulateReduceTransparencyStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isReduceTransparencyEnabled, expectedValue)
    }

    func testIsShakeToUndoEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .shakeToUndoStatusDidChange,
                                                 queue: .main) { _ in }

        simulateShakeToUndoStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isShakeToUndoEnabled, expectedValue)
    }

    func testIsSpeakScreenEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .speakScreenStatusDidChange,
                                                 queue: .main) { _ in }

        simulateSpeakScreenStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSpeakScreenEnabled, expectedValue)
    }

    func testIsSpeakSelectionEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .speakSelectionStatusDidChange,
                                                 queue: .main) { _ in }

        simulateSpeakSelectionStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSpeakSelectionEnabled, expectedValue)
    }

    func testIsSwitchControlEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .switchControlStatusDidChange,
                                                 queue: .main) { _ in }

        simulateSwitchControlStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSwitchControlEnabled, expectedValue)
    }

    func testIsVoiceOverEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor(options: .voiceOverStatusDidChange,
                                                 queue: .main) { _ in }

        simulateVoiceOverStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isVoiceOverEnabled, expectedValue)
    }

    func testMonitor_assistiveTouchStatusDidChange() {
        if #available(iOS 10.0, tvOS 11.0, *) {
            let expectation = self.expectation(description: "Handler called")
            let expectedValue: Bool = true
            var expectedEvent: AccessibilityStatusMonitor.Event?
            let monitor = AccessibilityStatusMonitor(options: .assistiveTouchStatusDidChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
            }

            monitor.startMonitoring()
            simulateAssistiveTouchStatusDidChange(to: expectedValue)
            waitForExpectations(timeout: 1)
            monitor.stopMonitoring()

            if let event = expectedEvent,
                case let .assistiveTouchStatusDidChange(value) = event {
                XCTAssertEqual(value, expectedValue)
            } else {
                XCTFail("Unexpected event")
            }
        }
    }

    func testMonitor_boldTextStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .boldTextStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateBoldTextStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .boldTextStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_closedCaptioningStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .closedCaptioningStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateClosedCaptioningStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .closedCaptioningStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_darkenColorsStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .darkenColorsStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateDarkenColorsStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .darkenColorsStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_grayscaleStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .grayscaleStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateGrayscaleStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .grayscaleStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_guidedAccessStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .guidedAccessStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateGuidedAccessStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .guidedAccessStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    #if os(iOS)
    func testMonitor_hearingDevicePairedEarDidChange() {
        if #available(iOS 10.0, *) {
            let expectation = self.expectation(description: "Handler called")
            let expectedValue: UIAccessibilityHearingDeviceEar = .right
            var expectedEvent: AccessibilityStatusMonitor.Event?
            let monitor = AccessibilityStatusMonitor(options: .hearingDevicePairedEarDidChange,
                                                     queue: .main) { event in
                                                        expectedEvent = event
                                                        expectation.fulfill()
            }

            monitor.startMonitoring()
            simulateHearingDevicePairedEarDidChange(to: expectedValue)
            waitForExpectations(timeout: 1)
            monitor.stopMonitoring()

            if let event = expectedEvent,
                case let .hearingDevicePairedEarDidChange(value) = event {
                XCTAssertEqual(value, expectedValue)
            } else {
                XCTFail("Unexpected event")
            }
        }
    }
    #endif

    func testMonitor_invertColorsStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .invertColorsStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateInvertColorsStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .invertColorsStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_monoAudioStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .monoAudioStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateMonoAudioStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .monoAudioStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_reduceMotionStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .reduceMotionStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateReduceMotionStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .reduceMotionStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_reduceTransparencyStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .reduceTransparencyStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateReduceTransparencyStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .reduceTransparencyStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_shakeToUndoStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .shakeToUndoStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateShakeToUndoStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .shakeToUndoStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_speakScreenStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .speakScreenStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSpeakScreenStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .speakScreenStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_speakSelectionStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .speakSelectionStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSpeakSelectionStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .speakSelectionStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_switchControlStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .switchControlStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateSwitchControlStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .switchControlStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_voiceOverStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor(options: .voiceOverStatusDidChange,
                                                 queue: .main) { event in
                                                    expectedEvent = event
                                                    expectation.fulfill()
        }

        monitor.startMonitoring()
        simulateVoiceOverStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
            case let .voiceOverStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    private func simulateAssistiveTouchStatusDidChange(to value: Bool) {
        if #available(iOS 10.0, tvOS 10.0, *) {
            accessibilityStatus.mockIsAssistiveTouchRunning = value

            notificationCenter.post(name: .UIAccessibilityAssistiveTouchStatusDidChange,
                                    object: nil)
        }
    }

    private func simulateBoldTextStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsBoldTextEnabled = value

        notificationCenter.post(name: .UIAccessibilityBoldTextStatusDidChange,
                                object: nil)
    }

    private func simulateClosedCaptioningStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsClosedCaptioningEnabled = value

        notificationCenter.post(name: .UIAccessibilityClosedCaptioningStatusDidChange,
                                object: nil)
    }

    private func simulateDarkenColorsStatusDidChange(to value: Bool) {
        accessibilityStatus.mockDarkerSystemColorsEnabled = value

        notificationCenter.post(name: .UIAccessibilityDarkerSystemColorsStatusDidChange,
                                object: nil)
    }

    private func simulateGrayscaleStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsGrayscaleEnabled = value

        notificationCenter.post(name: .UIAccessibilityGrayscaleStatusDidChange,
                                object: nil)
    }

    private func simulateGuidedAccessStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsGuidedAccessEnabled = value

        notificationCenter.post(name: .UIAccessibilityGuidedAccessStatusDidChange,
                                object: nil)
    }

    #if os(iOS)
    @available(iOS 10.0, *)
    private func simulateHearingDevicePairedEarDidChange(to value: UIAccessibilityHearingDeviceEar) {
        accessibilityStatus.mockHearingDevicePairedEar = value

        notificationCenter.post(name: .UIAccessibilityHearingDevicePairedEarDidChange,
                                object: nil)
    }
    #endif

    private func simulateInvertColorsStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsInvertColorsEnabled = value

        notificationCenter.post(name: .UIAccessibilityInvertColorsStatusDidChange,
                                object: nil)
    }

    private func simulateMonoAudioStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsMonoAudioEnabled = value

        notificationCenter.post(name: .UIAccessibilityMonoAudioStatusDidChange,
                                object: nil)
    }

    private func simulateReduceMotionStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsReduceMotionEnabled = value

        notificationCenter.post(name: .UIAccessibilityReduceMotionStatusDidChange,
                                object: nil)
    }

    private func simulateReduceTransparencyStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsReduceTransparencyEnabled = value

        notificationCenter.post(name: .UIAccessibilityReduceTransparencyStatusDidChange,
                                object: nil)
    }

    private func simulateShakeToUndoStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsShakeToUndoEnabled = value

        notificationCenter.post(name: .UIAccessibilityShakeToUndoDidChange,
                                object: nil)
    }

    private func simulateSpeakScreenStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSpeakScreenEnabled = value

        notificationCenter.post(name: .UIAccessibilitySpeakScreenStatusDidChange,
                                object: nil)
    }

    private func simulateSpeakSelectionStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSpeakSelectionEnabled = value

        notificationCenter.post(name: .UIAccessibilitySpeakSelectionStatusDidChange,
                                object: nil)
    }

    private func simulateSwitchControlStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSwitchControlRunning = value

        notificationCenter.post(name: .UIAccessibilitySwitchControlStatusDidChange,
                                object: nil)
    }

    private func simulateVoiceOverStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsVoiceOverRunning = value

        if #available(iOS 11.0, tvOS 11.0, *) {
            notificationCenter.post(name: .UIAccessibilityVoiceOverStatusDidChange,
                                    object: nil)
        } else {
            notificationCenter.post(name: Notification.Name(UIAccessibilityVoiceOverStatusChanged),
                                    object: nil)
        }
    }
}

// swiftlint:enable file_length type_body_length
