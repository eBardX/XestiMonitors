//
//  AccessibilityInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import UIKit

internal protocol AccessibilityProtocol: class {
    static func darkerSystemColorsEnabled() -> Bool

    @available(iOS 10.0, *)
    static func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar

    @available(iOS 10.0, *)
    static func isAssistiveTouchRunning() -> Bool

    static func isBoldTextEnabled() -> Bool

    static func isClosedCaptioningEnabled() -> Bool

    static func isGrayscaleEnabled() -> Bool

    static func isGuidedAccessEnabled() -> Bool

    static func isInvertColorsEnabled() -> Bool

    static func isMonoAudioEnabled() -> Bool

    static func isReduceMotionEnabled() -> Bool

    static func isReduceTransparencyEnabled() -> Bool

    static func isShakeToUndoEnabled() -> Bool

    static func isSpeakScreenEnabled() -> Bool

    static func isSpeakSelectionEnabled() -> Bool

    static func isSwitchControlRunning() -> Bool

    static func isVoiceOverRunning() -> Bool
}

internal extension AccessibilityProtocol {
    static func darkerSystemColorsEnabled() -> Bool {
        return UIAccessibilityDarkerSystemColorsEnabled()
    }

    @available(iOS 10.0, *)
    static func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar {
        return UIAccessibilityHearingDevicePairedEar()
    }

    @available(iOS 10.0, *)
    static func isAssistiveTouchRunning() -> Bool {
        return UIAccessibilityIsAssistiveTouchRunning()
    }

    static func isBoldTextEnabled() -> Bool {
        return UIAccessibilityIsBoldTextEnabled()
    }

    static func isClosedCaptioningEnabled() -> Bool {
        return UIAccessibilityIsClosedCaptioningEnabled()
    }

    static func isGrayscaleEnabled() -> Bool {
        return UIAccessibilityIsGrayscaleEnabled()
    }

    static func isGuidedAccessEnabled() -> Bool {
        return UIAccessibilityIsGuidedAccessEnabled()
    }

    static func isInvertColorsEnabled() -> Bool {
        return UIAccessibilityIsInvertColorsEnabled()
    }

    static func isMonoAudioEnabled() -> Bool {
        return UIAccessibilityIsMonoAudioEnabled()
    }

    static func isReduceMotionEnabled() -> Bool {
        return UIAccessibilityIsReduceMotionEnabled()
    }

    static func isReduceTransparencyEnabled() -> Bool {
        return UIAccessibilityIsReduceTransparencyEnabled()
    }

    static func isShakeToUndoEnabled() -> Bool {
        return UIAccessibilityIsShakeToUndoEnabled()
    }

    static func isSpeakScreenEnabled() -> Bool {
        return UIAccessibilityIsSpeakScreenEnabled()
    }

    static func isSpeakSelectionEnabled() -> Bool {
        return UIAccessibilityIsSpeakSelectionEnabled()
    }

    static func isSwitchControlRunning() -> Bool {
        return UIAccessibilityIsSwitchControlRunning()
    }

    static func isVoiceOverRunning() -> Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }
}

private class DefaultAccessibility: AccessibilityProtocol {
}

internal protocol AccessibilityInjected {}

internal struct AccessibilityInjector {
    static var accessibility: AccessibilityProtocol = DefaultAccessibility()
}

internal extension AccessibilityInjected {
    var accessibility: AccessibilityProtocol { return AccessibilityInjector.accessibility }
}
