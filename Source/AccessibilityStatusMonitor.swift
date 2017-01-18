//
//  AccessibilityStatusMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-01-13.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An `AccessibilityStatusMonitor` object monitors the system for changes to
/// the status of various accessibility settings.
///
public class AccessibilityStatusMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates changes to the status of various system accessibility
    /// settings.
    ///
    public enum Event {

        ///
        /// The system’s AssistiveTouch setting has changed.
        ///
        case assistiveTouchStatusDidChange(Bool)

        ///
        /// The system’s Bold Text setting has changed.
        ///
        case boldTextStatusDidChange(Bool)

        ///
        /// The system’s Closed Captioning setting has changed.
        ///
        case closedCaptioningStatusDidChange(Bool)

        ///
        /// The system’s Darken Colors setting has changed.
        ///
        case darkenColorsStatusDidChange(Bool)

        ///
        /// The system’s Grayscale setting has changed.
        ///
        case grayscaleStatusDidChange(Bool)

        ///
        /// The system’s Guided Access setting has changed.
        ///
        case guidedAccessStatusDidChange(Bool)

        ///
        /// The system’s hearing device pairing options have changed.
        ///
        case hearingDevicePairedEarDidChange(HearingDeviceEar)

        ///
        /// The system’s Invert Colors setting has changed.
        ///
        case invertColorsStatusDidChange(Bool)

        ///
        /// The system’s Mono Audio setting has changed.
        ///
        case monoAudioStatusDidChange(Bool)

        ///
        /// The system’s Reduce Motion setting has changed.
        ///
        case reduceMotionStatusDidChange(Bool)

        ///
        /// The system’s Reduce Transparency setting has changed.
        ///
        case reduceTransparencyStatusDidChange(Bool)

        ///
        /// The system’s Shake to Undo setting has changed.
        ///
        case shakeToUndoStatusDidChange(Bool)

        ///
        /// The system’s Speak Screen setting has changed.
        ///
        case speakScreenStatusDidChange(Bool)

        ///
        /// The system’s Speak Selection setting has changed.
        ///
        case speakSelectionStatusDidChange(Bool)

        ///
        /// The system’s Switch Control setting has changed.
        ///s
        case switchControlStatusDidChange(Bool)

        ///
        /// The system’s VoiceOver setting has changed.
        ///
        case voiceOverStatusDidChange(Bool)

    }

    ///
    /// Defines hearing device pairing options.
    ///
    public struct HearingDeviceEar: OptionSet {

        // Public Initializers

        public init(rawValue: UInt) {

            self.rawValue = rawValue

        }

        ///
        /// Both left and right ears.
        ///
        public static let both: HearingDeviceEar = [.left, .right]

        ///
        /// The left ear.
        ///
        public static let left = HearingDeviceEar(rawValue: 1 << 1)

        ///
        /// The right ear.
        ///
        public static let right = HearingDeviceEar(rawValue: 1 << 2)

        // Public Instance Properties

        public let rawValue: UInt

        // Internal Initializers

        @available(iOS 10.0, *)
        internal init(_ value: UIAccessibilityHearingDeviceEar) {

            self.rawValue = value.rawValue

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `AccessibilityStatusMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the status of a system
    ///                 accessibility setting changes.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.handler = handler

    }

    // Public Instance Properties

    ///
    /// The current hearing device pairing options.
    ///
    public var hearingDevicePairedEar: HearingDeviceEar {

        if #available(iOS 10.0, *) {
            return HearingDeviceEar(UIAccessibilityHearingDevicePairedEar())
        } else {
            return []
        }

    }

    ///
    /// A Boolean value indicating whether the user has enabled AssistiveTouch
    /// in Settings.
    ///
    public var isAssistiveTouchEnabled: Bool {

        if #available(iOS 10.0, *) {
            return UIAccessibilityIsAssistiveTouchRunning()
        } else {
            return false
        }

    }

    ///
    /// A Boolean value indicating whether the user has enabled Bold Text in
    /// Settings.
    ///
    public var isBoldTextEnabled: Bool { return UIAccessibilityIsBoldTextEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Closed
    /// Captioning in Settings.
    ///
    public var isClosedCaptioningEnabled: Bool { return UIAccessibilityIsClosedCaptioningEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Darken Colors
    /// in Settings.
    ///
    public var isDarkenColorsEnabled: Bool { return UIAccessibilityDarkerSystemColorsEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Grayscale in
    /// Settings.
    ///
    public var isGrayscaleEnabled: Bool { return UIAccessibilityIsGrayscaleEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Guided Access
    /// in Settings.
    ///
    public var isGuidedAccessEnabled: Bool { return UIAccessibilityIsGuidedAccessEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Invert Colors
    /// in Settings.
    ///
    public var isInvertColorsEnabled: Bool { return UIAccessibilityIsInvertColorsEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Mono Audio in
    /// Settings.
    ///
    public var isMonoAudioEnabled: Bool { return UIAccessibilityIsMonoAudioEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Reduce Motion
    /// in Settings.
    ///
    public var isReduceMotionEnabled: Bool { return UIAccessibilityIsReduceMotionEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Reduce
    /// Transparency in Settings.
    ///
    public var isReduceTransparencyEnabled: Bool { return UIAccessibilityIsReduceTransparencyEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Shake to Undo
    /// in Settings.
    ///
    public var isShakeToUndoEnabled: Bool {

        if #available(iOS 9.0, *) {
            return UIAccessibilityIsShakeToUndoEnabled()
        } else {
            return false
        }

    }

    ///
    /// A Boolean value indicating whether the user has enabled Speak Screen in
    /// Settings.
    ///
    public var isSpeakScreenEnabled: Bool { return UIAccessibilityIsSpeakScreenEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Speak Selection
    /// in Settings.
    ///
    public var isSpeakSelectionEnabled: Bool { return UIAccessibilityIsSpeakSelectionEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Switch Control
    /// in Settings.
    ///
    public var isSwitchControlEnabled: Bool { return UIAccessibilityIsSwitchControlRunning() }

    ///
    /// A Boolean value indicating whether the user has enabled VoiceOver in
    /// Settings.
    ///
    public var isVoiceOverEnabled: Bool { return UIAccessibilityIsVoiceOverRunning() }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Private Instance Methods

    @available(iOS 10.0, *)
    @objc private func accessibilityAssistiveTouchStatusDidChange(_ notification: Notification) {

        handler(.assistiveTouchStatusDidChange(isAssistiveTouchEnabled))

    }

    @objc private func accessibilityBoldTextStatusDidChange(_ notification: Notification) {

        handler(.boldTextStatusDidChange(isBoldTextEnabled))

    }

    @objc private func accessibilityClosedCaptioningStatusDidChange(_ notification: Notification) {

        handler(.closedCaptioningStatusDidChange(isClosedCaptioningEnabled))

    }

    @objc private func accessibilityDarkerSystemColorsStatusDidChange(_ notification: Notification) {

        handler(.darkenColorsStatusDidChange(isDarkenColorsEnabled))

    }

    @objc private func accessibilityGrayscaleStatusDidChange(_ notification: Notification) {

        handler(.grayscaleStatusDidChange(isGrayscaleEnabled))

    }

    @objc private func accessibilityGuidedAccessStatusDidChange(_ notification: Notification) {

        handler(.guidedAccessStatusDidChange(isGuidedAccessEnabled))

    }

    @available(iOS 10.0, *)
    @objc private func accessibilityHearingDevicePairedEarDidChange(_ notification: Notification) {

        handler(.hearingDevicePairedEarDidChange(hearingDevicePairedEar))

    }

    @objc private func accessibilityInvertColorsStatusDidChange(_ notification: Notification) {

        handler(.invertColorsStatusDidChange(isInvertColorsEnabled))

    }

    @objc private func accessibilityMonoAudioStatusDidChange(_ notification: Notification) {

        handler(.monoAudioStatusDidChange(isMonoAudioEnabled))

    }

    @objc private func accessibilityReduceMotionStatusDidChange(_ notification: Notification) {

        handler(.reduceMotionStatusDidChange(isReduceMotionEnabled))

    }

    @objc private func accessibilityReduceTransparencyStatusDidChange(_ notification: Notification) {

        handler(.reduceTransparencyStatusDidChange(isReduceTransparencyEnabled))

    }

    @available(iOS 9.0, *)
    @objc private func accessibilityShakeToUndoDidChange(_ notification: Notification) {

        handler(.shakeToUndoStatusDidChange(isShakeToUndoEnabled))

    }

    @objc private func accessibilitySpeakScreenStatusDidChange(_ notification: Notification) {

        handler(.speakScreenStatusDidChange(isSpeakScreenEnabled))

    }

    @objc private func accessibilitySpeakSelectionStatusDidChange(_ notification: Notification) {

        handler(.speakSelectionStatusDidChange(isSpeakSelectionEnabled))

    }

    @objc private func accessibilitySwitchControlStatusDidChange(_ notification: Notification) {

        handler(.switchControlStatusDidChange(isSwitchControlEnabled))

    }

    @objc private func accessibilityVoiceOverStatusChanged(_ notification: Notification) {

        handler(.voiceOverStatusDidChange(isVoiceOverEnabled))

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        if #available(iOS 10.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(accessibilityAssistiveTouchStatusDidChange(_:)),
                                           name: .UIAccessibilityAssistiveTouchStatusDidChange,
                                           object: nil)
        }

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityBoldTextStatusDidChange(_:)),
                                       name: .UIAccessibilityBoldTextStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityClosedCaptioningStatusDidChange(_:)),
                                       name: .UIAccessibilityClosedCaptioningStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityDarkerSystemColorsStatusDidChange(_:)),
                                       name: .UIAccessibilityDarkerSystemColorsStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityGrayscaleStatusDidChange(_:)),
                                       name: .UIAccessibilityGrayscaleStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityGuidedAccessStatusDidChange(_:)),
                                       name: .UIAccessibilityGuidedAccessStatusDidChange,
                                       object: nil)

        if #available(iOS 10.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(accessibilityHearingDevicePairedEarDidChange(_:)),
                                           name: .UIAccessibilityHearingDevicePairedEarDidChange,
                                           object: nil)
        }

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityInvertColorsStatusDidChange(_:)),
                                       name: .UIAccessibilityInvertColorsStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityMonoAudioStatusDidChange(_:)),
                                       name: .UIAccessibilityMonoAudioStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityReduceMotionStatusDidChange(_:)),
                                       name: .UIAccessibilityReduceMotionStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityReduceTransparencyStatusDidChange(_:)),
                                       name: .UIAccessibilityReduceTransparencyStatusDidChange,
                                       object: nil)

        if #available(iOS 9.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(accessibilityShakeToUndoDidChange(_:)),
                                           name: .UIAccessibilityShakeToUndoDidChange,
                                           object: nil)
        }

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilitySpeakScreenStatusDidChange(_:)),
                                       name: .UIAccessibilitySpeakScreenStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilitySpeakSelectionStatusDidChange(_:)),
                                       name: .UIAccessibilitySpeakSelectionStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilitySwitchControlStatusDidChange(_:)),
                                       name: .UIAccessibilitySwitchControlStatusDidChange,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityVoiceOverStatusChanged(_:)),
                                       name: Notification.Name(UIAccessibilityVoiceOverStatusChanged),
                                       object: nil)

        return true

    }

}
