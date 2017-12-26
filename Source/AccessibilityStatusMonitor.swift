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
/// An `AccessibilityStatusMonitor` instance monitors the system for changes to
/// the status of various accessibility settings.
///
public class AccessibilityStatusMonitor: BaseNotificationMonitor {

    // Public Nested Types

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
        ///
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
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the status of a system
    ///                 accessibility setting changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.handler = handler

        super.init(queue: queue)

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

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard
            super.addNotificationObservers()
            else { return false }

        if #available(iOS 10.0, *) {
            observe(.UIAccessibilityAssistiveTouchStatusDidChange) { [unowned self] _ in
                self.handler(.assistiveTouchStatusDidChange(self.isAssistiveTouchEnabled))
            }
        }

        observe(.UIAccessibilityBoldTextStatusDidChange) { [unowned self] _ in
            self.handler(.boldTextStatusDidChange(self.isBoldTextEnabled))
        }

        observe(.UIAccessibilityClosedCaptioningStatusDidChange) { [unowned self] _ in
            self.handler(.closedCaptioningStatusDidChange(self.isClosedCaptioningEnabled))
        }

        observe(.UIAccessibilityDarkerSystemColorsStatusDidChange) { [unowned self] _ in
            self.handler(.darkenColorsStatusDidChange(self.isDarkenColorsEnabled))
        }

        observe(.UIAccessibilityGrayscaleStatusDidChange) { [unowned self] _ in
            self.handler(.grayscaleStatusDidChange(self.isGrayscaleEnabled))
        }

        observe(.UIAccessibilityGuidedAccessStatusDidChange) { [unowned self] _ in
            self.handler(.guidedAccessStatusDidChange(self.isGuidedAccessEnabled))
        }

        if #available(iOS 10.0, *) {
            observe(.UIAccessibilityHearingDevicePairedEarDidChange) { [unowned self] _ in
                self.handler(.hearingDevicePairedEarDidChange(self.hearingDevicePairedEar))
            }
        }

        observe(.UIAccessibilityInvertColorsStatusDidChange) { [unowned self] _ in
            self.handler(.invertColorsStatusDidChange(self.isInvertColorsEnabled))
        }

        observe(.UIAccessibilityMonoAudioStatusDidChange) { [unowned self] _ in
            self.handler(.monoAudioStatusDidChange(self.isMonoAudioEnabled))
        }

        observe(.UIAccessibilityReduceMotionStatusDidChange) { [unowned self] _ in
            self.handler(.reduceMotionStatusDidChange(self.isReduceMotionEnabled))
        }

        observe(.UIAccessibilityReduceTransparencyStatusDidChange) { [unowned self] _ in
            self.handler(.reduceTransparencyStatusDidChange(self.isReduceTransparencyEnabled))
        }

        if #available(iOS 9.0, *) {
            observe(.UIAccessibilityShakeToUndoDidChange) { [unowned self] _ in
                self.handler(.shakeToUndoStatusDidChange(self.isShakeToUndoEnabled))
            }
        }

        observe(.UIAccessibilitySpeakScreenStatusDidChange) { [unowned self] _ in
            self.handler(.speakScreenStatusDidChange(self.isSpeakScreenEnabled))
        }

        observe(.UIAccessibilitySpeakSelectionStatusDidChange) { [unowned self] _ in
            self.handler(.speakSelectionStatusDidChange(self.isSpeakSelectionEnabled))
        }

        observe(.UIAccessibilitySwitchControlStatusDidChange) { [unowned self] _ in
            self.handler(.switchControlStatusDidChange(self.isSwitchControlEnabled))
        }

        observe(Notification.Name(UIAccessibilityVoiceOverStatusChanged)) { [unowned self] _ in
            self.handler(.voiceOverStatusDidChange(self.isVoiceOverEnabled))
        }

        return true

    }

}
