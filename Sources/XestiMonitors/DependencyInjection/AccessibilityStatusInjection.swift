// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

internal protocol AccessibilityStatusProtocol {
    var darkerSystemColorsEnabled: Bool { get }

#if os(iOS)
    var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar { get }
#endif

    var isAssistiveTouchRunning: Bool { get }

    var isBoldTextEnabled: Bool { get }

    var isClosedCaptioningEnabled: Bool { get }

    var isGrayscaleEnabled: Bool { get }

    var isGuidedAccessEnabled: Bool { get }

    var isInvertColorsEnabled: Bool { get }

    var isMonoAudioEnabled: Bool { get }

    var isReduceMotionEnabled: Bool { get }

    var isReduceTransparencyEnabled: Bool { get }

    var isShakeToUndoEnabled: Bool { get }

    var isSpeakScreenEnabled: Bool { get }

    var isSpeakSelectionEnabled: Bool { get }

    var isSwitchControlRunning: Bool { get }

    var isVoiceOverRunning: Bool { get }
}

extension AccessibilityStatus: AccessibilityStatusProtocol {}

// MARK: -

extension Dependencies {
    internal static let accessibilityStatusInjected = {
        DependencyResolver.register(AccessibilityStatus() as any AccessibilityStatusProtocol)
    }()
}

#endif
