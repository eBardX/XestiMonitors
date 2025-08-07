// © 2018–2025 John Gary Pusey (see LICENSE.md)

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

    var darkerSystemColorsEnabled: Bool {
        mockDarkerSystemColorsEnabled
    }

    // swiftlint:disable force_cast

#if os(iOS)
    var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar {
        mockHearingDevicePairedEar as! UIAccessibility.HearingDeviceEar
    }
#endif

    // swiftlint:enable force_cast

    var isAssistiveTouchRunning: Bool {
        mockIsAssistiveTouchRunning
    }

    var isBoldTextEnabled: Bool {
        mockIsBoldTextEnabled
    }

    var isClosedCaptioningEnabled: Bool {
        mockIsClosedCaptioningEnabled
    }

    var isGrayscaleEnabled: Bool {
        mockIsGrayscaleEnabled
    }

    var isGuidedAccessEnabled: Bool {
        mockIsGuidedAccessEnabled
    }

    var isInvertColorsEnabled: Bool {
        mockIsInvertColorsEnabled
    }

    var isMonoAudioEnabled: Bool {
        mockIsMonoAudioEnabled
    }

    var isReduceMotionEnabled: Bool {
        mockIsReduceMotionEnabled
    }

    var isReduceTransparencyEnabled: Bool {
        mockIsReduceTransparencyEnabled
    }

    var isShakeToUndoEnabled: Bool {
        mockIsShakeToUndoEnabled
    }

    var isSpeakScreenEnabled: Bool {
        mockIsSpeakScreenEnabled
    }

    var isSpeakSelectionEnabled: Bool {
        mockIsSpeakSelectionEnabled
    }

    var isSwitchControlRunning: Bool {
        mockIsSwitchControlRunning
    }

    var isVoiceOverRunning: Bool {
        mockIsVoiceOverRunning
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
