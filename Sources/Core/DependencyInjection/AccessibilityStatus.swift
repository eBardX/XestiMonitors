//
//  AccessibilityStatus.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-01-07.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import UIKit

internal class AccessibilityStatus {

    // MARK: Public Instance Methods

    internal func darkerSystemColorsEnabled() -> Bool {
        return UIAccessibilityDarkerSystemColorsEnabled()
    }

    #if os(iOS)
    @available(iOS 10.0, *)
    internal func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar {
        return UIAccessibilityHearingDevicePairedEar()
    }
    #endif

    @available(iOS 10.0, tvOS 10.0, *)
    internal func isAssistiveTouchRunning() -> Bool {
        return UIAccessibilityIsAssistiveTouchRunning()
    }

    internal func isBoldTextEnabled() -> Bool {
        return UIAccessibilityIsBoldTextEnabled()
    }

    internal func isClosedCaptioningEnabled() -> Bool {
        return UIAccessibilityIsClosedCaptioningEnabled()
    }

    internal func isGrayscaleEnabled() -> Bool {
        return UIAccessibilityIsGrayscaleEnabled()
    }

    internal func isGuidedAccessEnabled() -> Bool {
        return UIAccessibilityIsGuidedAccessEnabled()
    }

    internal func isInvertColorsEnabled() -> Bool {
        return UIAccessibilityIsInvertColorsEnabled()
    }

    internal func isMonoAudioEnabled() -> Bool {
        return UIAccessibilityIsMonoAudioEnabled()
    }

    internal func isReduceMotionEnabled() -> Bool {
        return UIAccessibilityIsReduceMotionEnabled()
    }

    internal func isReduceTransparencyEnabled() -> Bool {
        return UIAccessibilityIsReduceTransparencyEnabled()
    }

    internal func isShakeToUndoEnabled() -> Bool {
        return UIAccessibilityIsShakeToUndoEnabled()
    }

    internal func isSpeakScreenEnabled() -> Bool {
        return UIAccessibilityIsSpeakScreenEnabled()
    }

    internal func isSpeakSelectionEnabled() -> Bool {
        return UIAccessibilityIsSpeakSelectionEnabled()
    }

    internal func isSwitchControlRunning() -> Bool {
        return UIAccessibilityIsSwitchControlRunning()
    }

    internal func isVoiceOverRunning() -> Bool {
        return UIAccessibilityIsVoiceOverRunning()
    }
}

#endif
