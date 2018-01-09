//
//  AccessibilityStatus.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import UIKit

internal class AccessibilityStatus {

    // MARK: Public Instance Methods

    public func darkerSystemColorsEnabled() -> Bool {
        return UIAccessibilityDarkerSystemColorsEnabled()
    }

    @available(iOS 10.0, *)
    public func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar {
        return UIAccessibilityHearingDevicePairedEar()
    }

    @available(iOS 10.0, *)
    public func isAssistiveTouchRunning() -> Bool {
        return UIAccessibilityIsAssistiveTouchRunning()
    }

    public func isBoldTextEnabled() -> Bool {
        return UIAccessibilityIsBoldTextEnabled()
    }

    public func isClosedCaptioningEnabled() -> Bool {
        return UIAccessibilityIsClosedCaptioningEnabled()
    }

    public func isGrayscaleEnabled() -> Bool {
        return UIAccessibilityIsGrayscaleEnabled()
    }

    public func isGuidedAccessEnabled() -> Bool {
        return UIAccessibilityIsGuidedAccessEnabled()
    }

    public func isInvertColorsEnabled() -> Bool {
        return UIAccessibilityIsInvertColorsEnabled()
    }

    public func isMonoAudioEnabled() -> Bool {
        return UIAccessibilityIsMonoAudioEnabled()
    }

    public func isReduceMotionEnabled() -> Bool {
        return UIAccessibilityIsReduceMotionEnabled()
    }

    public func isReduceTransparencyEnabled() -> Bool {
        return UIAccessibilityIsReduceTransparencyEnabled()
    }

    public func isShakeToUndoEnabled() -> Bool {
        return UIAccessibilityIsShakeToUndoEnabled()
    }

    public func isSpeakScreenEnabled() -> Bool {
        return UIAccessibilityIsSpeakScreenEnabled()
    }

    public func isSpeakSelectionEnabled() -> Bool {
        return UIAccessibilityIsSpeakSelectionEnabled()
    }

    public func isSwitchControlRunning() -> Bool {
        return UIAccessibilityIsSwitchControlRunning()
    }

    public func isVoiceOverRunning() -> Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }
}
