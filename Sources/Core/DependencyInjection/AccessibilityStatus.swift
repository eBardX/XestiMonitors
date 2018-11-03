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

    internal var darkerSystemColorsEnabled: Bool {
        return UIAccessibility.isDarkerSystemColorsEnabled
    }

    #if os(iOS)
    @available(iOS 10.0, *)
    internal var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar {
        return UIAccessibility.hearingDevicePairedEar
    }
    #endif

    @available(iOS 10.0, tvOS 10.0, *)
    internal var isAssistiveTouchRunning: Bool {
        return UIAccessibility.isAssistiveTouchRunning
    }

    internal var isBoldTextEnabled: Bool {
        return UIAccessibility.isBoldTextEnabled
    }

    internal var isClosedCaptioningEnabled: Bool {
        return UIAccessibility.isClosedCaptioningEnabled
    }

    internal var isGrayscaleEnabled: Bool {
        return UIAccessibility.isGrayscaleEnabled
    }

    internal var isGuidedAccessEnabled: Bool {
        return UIAccessibility.isGuidedAccessEnabled
    }

    internal var isInvertColorsEnabled: Bool {
        return UIAccessibility.isInvertColorsEnabled
    }

    internal var isMonoAudioEnabled: Bool {
        return UIAccessibility.isMonoAudioEnabled
    }

    internal var isReduceMotionEnabled: Bool {
        return UIAccessibility.isReduceMotionEnabled
    }

    internal var isReduceTransparencyEnabled: Bool {
        return UIAccessibility.isReduceTransparencyEnabled
    }

    internal var isShakeToUndoEnabled: Bool {
        return UIAccessibility.isShakeToUndoEnabled
    }

    internal var isSpeakScreenEnabled: Bool {
        return UIAccessibility.isSpeakScreenEnabled
    }

    internal var isSpeakSelectionEnabled: Bool {
        return UIAccessibility.isSpeakSelectionEnabled
    }

    internal var isSwitchControlRunning: Bool {
        return UIAccessibility.isSwitchControlRunning
    }

    internal var isVoiceOverRunning: Bool {
        return UIAccessibility.isVoiceOverRunning
    }
}

#endif
