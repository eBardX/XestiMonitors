//
//  AccessibilityStatusInjection.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-12-29.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

    import UIKit

    internal protocol AccessibilityStatusProtocol: class {
        func darkerSystemColorsEnabled() -> Bool

        #if os(iOS)
        @available(iOS 10.0, *)
        func hearingDevicePairedEar() -> UIAccessibilityHearingDeviceEar
        #endif

        @available(iOS 10.0, tvOS 10.0, *)
        func isAssistiveTouchRunning() -> Bool

        func isBoldTextEnabled() -> Bool

        func isClosedCaptioningEnabled() -> Bool

        func isGrayscaleEnabled() -> Bool

        func isGuidedAccessEnabled() -> Bool

        func isInvertColorsEnabled() -> Bool

        func isMonoAudioEnabled() -> Bool

        func isReduceMotionEnabled() -> Bool

        func isReduceTransparencyEnabled() -> Bool

        func isShakeToUndoEnabled() -> Bool

        func isSpeakScreenEnabled() -> Bool

        func isSpeakSelectionEnabled() -> Bool

        func isSwitchControlRunning() -> Bool

        func isVoiceOverRunning() -> Bool
    }

    extension AccessibilityStatus: AccessibilityStatusProtocol {}

    internal protocol AccessibilityStatusInjected {}

    internal struct AccessibilityStatusInjector {
        static var accessibilityStatus: AccessibilityStatusProtocol = AccessibilityStatus()
    }

    internal extension AccessibilityStatusInjected {
        var accessibilityStatus: AccessibilityStatusProtocol { return AccessibilityStatusInjector.accessibilityStatus }
    }

#endif
