//
//  MockAccessibilityStatus.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
@testable import XestiMonitors

internal class MockAccessibilityStatus: AccessibilityStatusProtocol {
    init() {
        self.mockDarkerSystemColorsEnabled = false
        self.mockHearingDevicePairedEar = []
        self.mockIsAssistiveTouchRunning = false
        self.mockIsBoldTextEnabled = false
        self.mockIsClosedCaptioningEnabled = false
        self.mockIsGrayscaleEnabled = false
        self.mockIsGuidedAccessEnabled = false
        self.mockIsInvertColorsEnabled = false
        self.mockIsMonoAudioEnabled = false
        self.mockIsReduceMotionEnabled = false
        self.mockIsReduceTransparencyEnabled = false
        self.mockIsShakeToUndoEnabled = false
        self.mockIsSpeakScreenEnabled = false
        self.mockIsSpeakSelectionEnabled = false
        self.mockIsSwitchControlRunning = false
        self.mockIsVoiceOverRunning = false
    }

    func darkerSystemColorsEnabled() -> Bool {
        return mockDarkerSystemColorsEnabled
    }

    // swiftlint:disable force_cast

    #if os(iOS)
    @available(iOS 10.0, *)
    func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar {
        return mockHearingDevicePairedEar as! UIAccessibilityHearingDeviceEar
    }
    #endif

    // swiftlint:enable force_cast

    @available(iOS 10.0, tvOS 10.0, *)
    func isAssistiveTouchRunning() -> Bool {
        return mockIsAssistiveTouchRunning
    }

    func isBoldTextEnabled() -> Bool {
        return mockIsBoldTextEnabled
    }

    func isClosedCaptioningEnabled() -> Bool {
        return mockIsClosedCaptioningEnabled
    }

    func isGrayscaleEnabled() -> Bool {
        return mockIsGrayscaleEnabled
    }

    func isGuidedAccessEnabled() -> Bool {
        return mockIsGuidedAccessEnabled
    }

    func isInvertColorsEnabled() -> Bool {
        return mockIsInvertColorsEnabled
    }

    func isMonoAudioEnabled() -> Bool {
        return mockIsMonoAudioEnabled
    }

    func isReduceMotionEnabled() -> Bool {
        return mockIsReduceMotionEnabled
    }

    func isReduceTransparencyEnabled() -> Bool {
        return mockIsReduceTransparencyEnabled
    }

    func isShakeToUndoEnabled() -> Bool {
        return mockIsShakeToUndoEnabled
    }

    func isSpeakScreenEnabled() -> Bool {
        return mockIsSpeakScreenEnabled
    }

    func isSpeakSelectionEnabled() -> Bool {
        return mockIsSpeakSelectionEnabled
    }

    func isSwitchControlRunning() -> Bool {
        return mockIsSwitchControlRunning
    }

    func isVoiceOverRunning() -> Bool {
        return mockIsVoiceOverRunning
    }

    // MARK: -

    var mockDarkerSystemColorsEnabled: Bool
    var mockHearingDevicePairedEar: Any
    var mockIsAssistiveTouchRunning: Bool
    var mockIsBoldTextEnabled: Bool
    var mockIsClosedCaptioningEnabled: Bool
    var mockIsGrayscaleEnabled: Bool
    var mockIsGuidedAccessEnabled: Bool
    var mockIsInvertColorsEnabled: Bool
    var mockIsMonoAudioEnabled: Bool
    var mockIsReduceMotionEnabled: Bool
    var mockIsReduceTransparencyEnabled: Bool
    var mockIsShakeToUndoEnabled: Bool
    var mockIsSpeakScreenEnabled: Bool
    var mockIsSpeakSelectionEnabled: Bool
    var mockIsSwitchControlRunning: Bool
    var mockIsVoiceOverRunning: Bool
}
