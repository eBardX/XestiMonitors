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
        /// The system’s assistive touch setting has changed.
        ///
        case assistiveTouchStatusDidChange(Bool)

        ///
        /// The system’s bold text setting has changed.
        ///
        case boldTextStatusDidChange(Bool)

        ///
        /// The system’s closed captioning setting has changed.
        ///
        case closedCaptioningStatusDidChange(Bool)

        ///
        /// The system’s darken colors setting has changed.
        ///
        case darkenColorsStatusDidChange(Bool)

        ///
        /// The system’s grayscale setting has changed.
        ///
        case grayscaleStatusDidChange(Bool)

        ///
        /// A guided access session has started or stopped.
        ///
        case guidedAccessStatusDidChange(Bool)

        ///
        /// A paired hearing device has changed.
        ///
        case hearingDevicePairedEarDidChange(HearingDeviceEar)

        ///
        /// The system’s invert colors setting has changed.
        ///
        case invertColorsStatusDidChange(Bool)

        ///
        /// System audio has changed from stereo to mono.
        ///
        case monoAudioStatusDidChange(Bool)

        ///
        /// The system’s reduce motion setting has changed.
        ///
        case reduceMotionStatusDidChange(Bool)

        ///
        /// The system’s reduce transparency setting has changed.
        ///
        case reduceTransparencyStatusDidChange(Bool)

        ///
        /// The system’s shake to undo setting has changed.
        ///
        case shakeToUndoStatusDidChange(Bool)

        ///
        /// The system’s speak screen setting has changed.
        ///
        case speakScreenStatusDidChange(Bool)

        ///
        /// The system’s speak selection setting has changed.
        ///
        case speakSelectionStatusDidChange(Bool)

        ///
        /// The system’s switch sontrol setting has changed.
        ///s
        case switchControlStatusDidChange(Bool)

        ///
        /// VoiceOver has started or stopped.
        ///
        case voiceOverStatusDidChange(Bool)

    }

    ///
    ///
    ///
    public struct HearingDeviceEar: OptionSet {

        ///
        ///
        ///
        public static let both: HearingDeviceEar = [.left, .right]

        ///
        ///
        ///
        public static let left = HearingDeviceEar(rawValue: 1 << 1)

        ///
        ///
        ///
        public static let right = HearingDeviceEar(rawValue: 1 << 2)

        public let rawValue: UInt

        public init(rawValue: UInt) {

            self.rawValue = rawValue

        }

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
    ///   - handler:    The handler to call when ...
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.handler = handler

    }

    // Public Instance Properties

    ///
    /// The current pairing status of compatible hearing aids.
    ///
    public var hearingDevicePairedEar: HearingDeviceEar {

        if #available(iOS 10.0, *) {
            return HearingDeviceEar(UIAccessibilityHearingDevicePairedEar())
        } else {
            return []
        }

    }

    ///
    /// A Boolean value indicating whether AssistiveTouch is currently running.
    ///
    public var isAssistiveTouchRunning: Bool {

        if #available(iOS 10.0, *) {
            return UIAccessibilityIsAssistiveTouchRunning()
        } else {
            return false
        }

    }

    ///
    /// A Boolean value indicating whether the user has enabled bold text in
    /// Settings.
    ///
    public var isBoldTextEnabled: Bool { return UIAccessibilityIsBoldTextEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled closed
    /// captioning in Settings.
    ///
    public var isClosedCaptioningEnabled: Bool { return UIAccessibilityIsClosedCaptioningEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled darken colors
    /// in Settings.
    ///
    public var isDarkenColorsEnabled: Bool { return UIAccessibilityDarkerSystemColorsEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled grayscale in
    /// Settings.
    ///
    public var isGrayscaleEnabled: Bool { return UIAccessibilityIsGrayscaleEnabled() }

    ///
    /// A Boolean value indicating whether the app is running in guided access
    /// mode.
    ///
    public var isGuidedAccessEnabled: Bool { return UIAccessibilityIsGuidedAccessEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled invert colors
    /// in Settings.
    ///
    public var isInvertColorsEnabled: Bool { return UIAccessibilityIsInvertColorsEnabled() }

    ///
    /// A Boolean value indicating whether system audio is set to mono.
    ///
    public var isMonoAudioEnabled: Bool { return UIAccessibilityIsMonoAudioEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled reduce motion
    /// in Settings.
    ///
    public var isReduceMotionEnabled: Bool { return UIAccessibilityIsReduceMotionEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled reduce
    /// transparency in Settings.
    ///
    public var isReduceTransparencyEnabled: Bool { return UIAccessibilityIsReduceTransparencyEnabled() }

    ///
    /// A Boolean value indicating whether shake to undo is currently enabled.
    ///
    public var isShakeToUndoEnabled: Bool {

        if #available(iOS 9.0, *) {
            return UIAccessibilityIsShakeToUndoEnabled()
        } else {
            return false
        }

    }

    ///
    /// A Boolean value indicating whether the user has enabled speak screen in
    /// Settings.
    ///
    public var isSpeakScreenEnabled: Bool { return UIAccessibilityIsSpeakScreenEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled speak selection
    /// in Settings.
    ///
    public var isSpeakSelectionEnabled: Bool { return UIAccessibilityIsSpeakSelectionEnabled() }

    ///
    /// A Boolean value indicating whether the user has enabled Switch Control
    /// in Settings.
    ///
    public var isSwitchControlRunning: Bool { return UIAccessibilityIsSwitchControlRunning() }

    ///
    /// A Boolean value indicating whether VoiceOver is currently running.
    ///
    public var isVoiceOverRunning: Bool { return UIAccessibilityIsVoiceOverRunning() }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Private Instance Methods

    @available(iOS 10.0, *)
    @objc private func accessibilityAssistiveTouchStatusDidChange(_ notification: Notification) {

        handler(.assistiveTouchStatusDidChange(isAssistiveTouchRunning))

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

        handler(.switchControlStatusDidChange(isSwitchControlRunning))

    }

    @objc private func accessibilityVoiceOverStatusChanged(_ notification: Notification) {

        handler(.voiceOverStatusDidChange(isVoiceOverRunning))

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
