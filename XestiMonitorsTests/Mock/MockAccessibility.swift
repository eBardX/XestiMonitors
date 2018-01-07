//
//  MockAccessibility.swift
//  XestiMonitorsTests
//
//  Created by J. G. Pusey on 2018-01-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit
@testable import XestiMonitors

internal class MockAccessibility: AccessibilityProtocol {
    static func darkerSystemColorsEnabled() -> Bool {
        return mockDarkerSystemColorsEnabled
    }

    @available(iOS 10.0, *)
    static func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar {
        return mockHearingDevicePairedEar
    }

    @available(iOS 10.0, *)
    static func isAssistiveTouchRunning() -> Bool {
        return mockIsAssistiveTouchRunning
    }

    static func isBoldTextEnabled() -> Bool {
        return mockIsBoldTextEnabled
    }

    static func isClosedCaptioningEnabled() -> Bool {
        return mockIsClosedCaptioningEnabled
    }

    static func isGrayscaleEnabled() -> Bool {
        return mockIsGrayscaleEnabled
    }

    static func isGuidedAccessEnabled() -> Bool {
        return mockIsGuidedAccessEnabled
    }

    static func isInvertColorsEnabled() -> Bool {
        return mockIsInvertColorsEnabled
    }

    static func isMonoAudioEnabled() -> Bool {
        return mockIsMonoAudioEnabled
    }

    static func isReduceMotionEnabled() -> Bool {
        return mockIsReduceMotionEnabled
    }

    static func isReduceTransparencyEnabled() -> Bool {
        return mockIsReduceTransparencyEnabled
    }

    static func isShakeToUndoEnabled() -> Bool {
        return mockIsShakeToUndoEnabled
    }

    static func isSpeakScreenEnabled() -> Bool {
        return mockIsSpeakScreenEnabled
    }

    static func isSpeakSelectionEnabled() -> Bool {
        return mockIsSpeakSelectionEnabled
    }

    static func isSwitchControlRunning() -> Bool {
        return mockIsSwitchControlRunning
    }

    static func isVoiceOverRunning() -> Bool {
        return mockIsVoiceOverRunning
    }

    // MARK: -

    static var mockDarkerSystemColorsEnabled: Bool = false
    @available(iOS 10.0, *)
    static var mockHearingDevicePairedEar: UIAccessibilityHearingDeviceEar = []
    @available(iOS 10.0, *)
    static var mockIsAssistiveTouchRunning: Bool = false
    static var mockIsBoldTextEnabled: Bool = false
    static var mockIsClosedCaptioningEnabled: Bool = false
    static var mockIsGrayscaleEnabled: Bool = false
    static var mockIsGuidedAccessEnabled: Bool = false
    static var mockIsInvertColorsEnabled: Bool = false
    static var mockIsMonoAudioEnabled: Bool = false
    static var mockIsReduceMotionEnabled: Bool = false
    static var mockIsReduceTransparencyEnabled: Bool = false
    static var mockIsShakeToUndoEnabled: Bool = false
    static var mockIsSpeakScreenEnabled: Bool = false
    static var mockIsSpeakSelectionEnabled: Bool = false
    static var mockIsSwitchControlRunning: Bool = false
    static var mockIsVoiceOverRunning: Bool = false
}
