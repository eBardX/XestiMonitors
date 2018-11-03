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

    var darkerSystemColorsEnabled: Bool {
        return mockDarkerSystemColorsEnabled
    }

    // swiftlint:disable force_cast

    #if os(iOS)
    @available(iOS 10.0, *)
    var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar {
        return mockHearingDevicePairedEar as! UIAccessibility.HearingDeviceEar
    }
    #endif

    // swiftlint:enable force_cast

    @available(iOS 10.0, tvOS 10.0, *)
    var isAssistiveTouchRunning: Bool {
        return mockIsAssistiveTouchRunning
    }

    var isBoldTextEnabled: Bool {
        return mockIsBoldTextEnabled
    }

    var isClosedCaptioningEnabled: Bool {
        return mockIsClosedCaptioningEnabled
    }

    var isGrayscaleEnabled: Bool {
        return mockIsGrayscaleEnabled
    }

    var isGuidedAccessEnabled: Bool {
        return mockIsGuidedAccessEnabled
    }

    var isInvertColorsEnabled: Bool {
        return mockIsInvertColorsEnabled
    }

    var isMonoAudioEnabled: Bool {
        return mockIsMonoAudioEnabled
    }

    var isReduceMotionEnabled: Bool {
        return mockIsReduceMotionEnabled
    }

    var isReduceTransparencyEnabled: Bool {
        return mockIsReduceTransparencyEnabled
    }

    var isShakeToUndoEnabled: Bool {
        return mockIsShakeToUndoEnabled
    }

    var isSpeakScreenEnabled: Bool {
        return mockIsSpeakScreenEnabled
    }

    var isSpeakSelectionEnabled: Bool {
        return mockIsSpeakSelectionEnabled
    }

    var isSwitchControlRunning: Bool {
        return mockIsSwitchControlRunning
    }

    var isVoiceOverRunning: Bool {
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
