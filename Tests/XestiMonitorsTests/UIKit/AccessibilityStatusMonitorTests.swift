// © 2017–2025 John Gary Pusey (see LICENSE.md)

import UIKit
import XCTest
@testable import XestiMonitors

// swiftlint:disable file_length type_body_length

internal class AccessibilityStatusMonitorTests: XCTestCase {
    let accessibilityStatus = MockAccessibilityStatus()
    let notificationCenter = MockNotificationCenter()

    override func setUp() {
        super.setUp()

        AccessibilityStatusInjector.inject = { self.accessibilityStatus }

        accessibilityStatus.mockDarkerSystemColorsEnabled = false
        accessibilityStatus.mockHearingDevicePairedEar = []
        accessibilityStatus.mockIsAssistiveTouchRunning = false
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

        NotificationCenterInjector.inject = { self.notificationCenter }
    }

#if os(iOS)
    func testHearingDevicePairedEar() {
        let expectedValue: UIAccessibility.HearingDeviceEar = .left
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateHearingDevicePairedEarDidChange(to: expectedValue)

        XCTAssertEqual(monitor.hearingDevicePairedEar, expectedValue)
    }
#endif

    func testIsAssistiveTouchEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateAssistiveTouchStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isAssistiveTouchEnabled, expectedValue)
    }

    func testIsBoldTextEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateBoldTextStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isBoldTextEnabled, expectedValue)
    }

    func testIsClosedCaptioningEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateClosedCaptioningStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isClosedCaptioningEnabled, expectedValue)
    }

    func testIsDarkenColorsEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateDarkenColorsStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isDarkenColorsEnabled, expectedValue)
    }

    func testIsGrayscaleEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateGrayscaleStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isGrayscaleEnabled, expectedValue)
    }

    func testIsGuidedAccessEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateGuidedAccessStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isGuidedAccessEnabled, expectedValue)
    }

    func testIsInvertColorsEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateInvertColorsStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isInvertColorsEnabled, expectedValue)
    }

    func testIsMonoAudioEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateMonoAudioStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isMonoAudioEnabled, expectedValue)
    }

    func testIsReduceMotionEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateReduceMotionStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isReduceMotionEnabled, expectedValue)
    }

    func testIsReduceTransparencyEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateReduceTransparencyStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isReduceTransparencyEnabled, expectedValue)
    }

    func testIsShakeToUndoEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateShakeToUndoStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isShakeToUndoEnabled, expectedValue)
    }

    func testIsSpeakScreenEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateSpeakScreenStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSpeakScreenEnabled, expectedValue)
    }

    func testIsSpeakSelectionEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateSpeakSelectionStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSpeakSelectionEnabled, expectedValue)
    }

    func testIsSwitchControlEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateSwitchControlStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isSwitchControlEnabled, expectedValue)
    }

    func testIsVoiceOverEnabled() {
        let expectedValue: Bool = true
        let monitor = AccessibilityStatusMonitor { _ in
            XCTAssertEqual(OperationQueue.current, .main)
        }

        _simulateVoiceOverStatusDidChange(to: expectedValue)

        XCTAssertEqual(monitor.isVoiceOverEnabled, expectedValue)
    }

    func testMonitor_assistiveTouchStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateAssistiveTouchStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .assistiveTouchStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    func testMonitor_boldTextStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateBoldTextStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateClosedCaptioningStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateDarkenColorsStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateGrayscaleStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateGuidedAccessStatusDidChange(to: expectedValue)
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
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: UIAccessibility.HearingDeviceEar = .right
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateHearingDevicePairedEarDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .hearingDevicePairedEarDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }
#endif

    func testMonitor_invertColorsStatusDidChange() {
        let expectation = self.expectation(description: "Handler called")
        let expectedValue: Bool = true
        var expectedEvent: AccessibilityStatusMonitor.Event?
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateInvertColorsStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateMonoAudioStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateReduceMotionStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateReduceTransparencyStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateShakeToUndoStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSpeakScreenStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSpeakSelectionStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateSwitchControlStatusDidChange(to: expectedValue)
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
        let monitor = AccessibilityStatusMonitor { event in
            XCTAssertEqual(OperationQueue.current, .main)

            expectedEvent = event
            expectation.fulfill()
        }

        monitor.startMonitoring()
        _simulateVoiceOverStatusDidChange(to: expectedValue)
        waitForExpectations(timeout: 1)
        monitor.stopMonitoring()

        if let event = expectedEvent,
           case let .voiceOverStatusDidChange(value) = event {
            XCTAssertEqual(value, expectedValue)
        } else {
            XCTFail("Unexpected event")
        }
    }

    // MARK: Private Instance Methods

    private func _simulateAssistiveTouchStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsAssistiveTouchRunning = value

        notificationCenter.post(name: UIAccessibility.assistiveTouchStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateBoldTextStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsBoldTextEnabled = value

        notificationCenter.post(name: UIAccessibility.boldTextStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateClosedCaptioningStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsClosedCaptioningEnabled = value

        notificationCenter.post(name: UIAccessibility.closedCaptioningStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateDarkenColorsStatusDidChange(to value: Bool) {
        accessibilityStatus.mockDarkerSystemColorsEnabled = value

        notificationCenter.post(name: UIAccessibility.darkerSystemColorsStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateGrayscaleStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsGrayscaleEnabled = value

        notificationCenter.post(name: UIAccessibility.grayscaleStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateGuidedAccessStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsGuidedAccessEnabled = value

        notificationCenter.post(name: UIAccessibility.guidedAccessStatusDidChangeNotification,
                                object: nil)
    }

#if os(iOS)
    private func _simulateHearingDevicePairedEarDidChange(to value: UIAccessibility.HearingDeviceEar) {
        accessibilityStatus.mockHearingDevicePairedEar = value

        notificationCenter.post(name: UIAccessibility.hearingDevicePairedEarDidChangeNotification,
                                object: nil)
    }
#endif

    private func _simulateInvertColorsStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsInvertColorsEnabled = value

        notificationCenter.post(name: UIAccessibility.invertColorsStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateMonoAudioStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsMonoAudioEnabled = value

        notificationCenter.post(name: UIAccessibility.monoAudioStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateReduceMotionStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsReduceMotionEnabled = value

        notificationCenter.post(name: UIAccessibility.reduceMotionStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateReduceTransparencyStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsReduceTransparencyEnabled = value

        notificationCenter.post(name: UIAccessibility.reduceTransparencyStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateShakeToUndoStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsShakeToUndoEnabled = value

        notificationCenter.post(name: UIAccessibility.shakeToUndoDidChangeNotification,
                                object: nil)
    }

    private func _simulateSpeakScreenStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSpeakScreenEnabled = value

        notificationCenter.post(name: UIAccessibility.speakScreenStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateSpeakSelectionStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSpeakSelectionEnabled = value

        notificationCenter.post(name: UIAccessibility.speakSelectionStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateSwitchControlStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsSwitchControlRunning = value

        notificationCenter.post(name: UIAccessibility.switchControlStatusDidChangeNotification,
                                object: nil)
    }

    private func _simulateVoiceOverStatusDidChange(to value: Bool) {
        accessibilityStatus.mockIsVoiceOverRunning = value

        notificationCenter.post(name: UIAccessibility.voiceOverStatusDidChangeNotification,
                                object: nil)
    }
}

// swiftlint:enable file_length type_body_length
