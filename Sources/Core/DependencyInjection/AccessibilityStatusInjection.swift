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

internal protocol AccessibilityStatusProtocol: AnyObject {
    var darkerSystemColorsEnabled: Bool { get }

    #if os(iOS)
    @available(iOS 10.0, *)
    var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar { get }
    #endif

    @available(iOS 10.0, tvOS 10.0, *)
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

internal enum AccessibilityStatusInjector {
    internal static var inject: () -> AccessibilityStatusProtocol = { shared }

    private static let shared: AccessibilityStatusProtocol = AccessibilityStatus()
}

#endif
