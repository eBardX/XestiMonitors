// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

internal class AccessibilityStatus {

    // MARK: Public Instance Methods

    internal var darkerSystemColorsEnabled: Bool {
        UIAccessibility.isDarkerSystemColorsEnabled
    }

#if os(iOS)
    internal var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar {
        UIAccessibility.hearingDevicePairedEar
    }
#endif

    internal var isAssistiveTouchRunning: Bool {
        UIAccessibility.isAssistiveTouchRunning
    }

    internal var isBoldTextEnabled: Bool {
        UIAccessibility.isBoldTextEnabled
    }

    internal var isClosedCaptioningEnabled: Bool {
        UIAccessibility.isClosedCaptioningEnabled
    }

    internal var isGrayscaleEnabled: Bool {
        UIAccessibility.isGrayscaleEnabled
    }

    internal var isGuidedAccessEnabled: Bool {
        UIAccessibility.isGuidedAccessEnabled
    }

    internal var isInvertColorsEnabled: Bool {
        UIAccessibility.isInvertColorsEnabled
    }

    internal var isMonoAudioEnabled: Bool {
        UIAccessibility.isMonoAudioEnabled
    }

    internal var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    internal var isReduceTransparencyEnabled: Bool {
        UIAccessibility.isReduceTransparencyEnabled
    }

    internal var isShakeToUndoEnabled: Bool {
        UIAccessibility.isShakeToUndoEnabled
    }

    internal var isSpeakScreenEnabled: Bool {
        UIAccessibility.isSpeakScreenEnabled
    }

    internal var isSpeakSelectionEnabled: Bool {
        UIAccessibility.isSpeakSelectionEnabled
    }

    internal var isSwitchControlRunning: Bool {
        UIAccessibility.isSwitchControlRunning
    }

    internal var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }
}

#endif
