// © 2017–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// An `AccessibilityStatusMonitor` instance monitors the system for
/// changes to the status of various accessibility settings.
public final class AccessibilityStatusMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the status of various system accessibility
    /// settings.
    public enum Event {
        /// The system’s AssistiveTouch setting has changed.
        case assistiveTouchStatusDidChange(Bool)

        /// The system’s Bold Text setting has changed.
        case boldTextStatusDidChange(Bool)

        /// The system’s Closed Captioning setting has changed.
        case closedCaptioningStatusDidChange(Bool)

        /// The system’s Darken Colors setting has changed.
        case darkenColorsStatusDidChange(Bool)

        /// The system’s Grayscale setting has changed.
        case grayscaleStatusDidChange(Bool)

        /// The system’s Guided Access setting has changed.
        case guidedAccessStatusDidChange(Bool)

#if os(iOS)
        /// The system’s hearing device pairing options have changed.
        case hearingDevicePairedEarDidChange(UIAccessibility.HearingDeviceEar)
#endif

        /// The system’s Invert Colors setting has changed.
        case invertColorsStatusDidChange(Bool)

        /// The system’s Mono Audio setting has changed.
        case monoAudioStatusDidChange(Bool)

        /// The system’s Reduce Motion setting has changed.
        case reduceMotionStatusDidChange(Bool)

        /// The system’s Reduce Transparency setting has changed.
        case reduceTransparencyStatusDidChange(Bool)

        /// The system’s Shake to Undo setting has changed.
        case shakeToUndoStatusDidChange(Bool)

        /// The system’s Speak Screen setting has changed.
        case speakScreenStatusDidChange(Bool)

        /// The system’s Speak Selection setting has changed.
        case speakSelectionStatusDidChange(Bool)

        /// The system’s Switch Control setting has changed.
        case switchControlStatusDidChange(Bool)

        /// The system’s VoiceOver setting has changed.
        case voiceOverStatusDidChange(Bool)
    }

    /// Initializes a new `AccessibilityStatusMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the status of a system
    ///                 accessibility setting changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

#if os(iOS)
    /// The current hearing device pairing options.
    public var hearingDevicePairedEar: UIAccessibility.HearingDeviceEar {
        accessibilityStatus.hearingDevicePairedEar
    }

#endif

    /// A Boolean value indicating whether the user has enabled
    /// AssistiveTouch in Settings.
    public var isAssistiveTouchEnabled: Bool {
        accessibilityStatus.isAssistiveTouchRunning
    }

    /// A Boolean value indicating whether the user has enabled Bold Text
    /// in Settings.
    public var isBoldTextEnabled: Bool {
        accessibilityStatus.isBoldTextEnabled
    }

    /// A Boolean value indicating whether the user has enabled Closed
    /// Captioning in Settings.
    public var isClosedCaptioningEnabled: Bool {
        accessibilityStatus.isClosedCaptioningEnabled
    }

    /// A Boolean value indicating whether the user has enabled Darken
    /// Colors in Settings.
    public var isDarkenColorsEnabled: Bool {
        accessibilityStatus.darkerSystemColorsEnabled
    }

    /// A Boolean value indicating whether the user has enabled Grayscale
    /// in Settings.
    public var isGrayscaleEnabled: Bool {
        accessibilityStatus.isGrayscaleEnabled
    }

    /// A Boolean value indicating whether the user has enabled Guided
    /// Access in Settings.
    public var isGuidedAccessEnabled: Bool {
        accessibilityStatus.isGuidedAccessEnabled
    }

    /// A Boolean value indicating whether the user has enabled Invert
    /// Colors in Settings.
    public var isInvertColorsEnabled: Bool {
        accessibilityStatus.isInvertColorsEnabled
    }

    /// A Boolean value indicating whether the user has enabled Mono Audio
    /// in Settings.
    public var isMonoAudioEnabled: Bool {
        accessibilityStatus.isMonoAudioEnabled
    }

    /// A Boolean value indicating whether the user has enabled Reduce
    /// Motion in Settings.
    public var isReduceMotionEnabled: Bool {
        accessibilityStatus.isReduceMotionEnabled
    }

    /// A Boolean value indicating whether the user has enabled Reduce
    /// Transparency in Settings.
    public var isReduceTransparencyEnabled: Bool {
        accessibilityStatus.isReduceTransparencyEnabled
    }

    /// A Boolean value indicating whether the user has enabled Shake to
    /// Undo in Settings.
    public var isShakeToUndoEnabled: Bool {
        accessibilityStatus.isShakeToUndoEnabled
    }

    /// A Boolean value indicating whether the user has enabled Speak
    /// Screen in Settings.
    public var isSpeakScreenEnabled: Bool {
        accessibilityStatus.isSpeakScreenEnabled
    }

    /// A Boolean value indicating whether the user has enabled Speak
    /// Selection in Settings.
    public var isSpeakSelectionEnabled: Bool {
        accessibilityStatus.isSpeakSelectionEnabled
    }

    /// A Boolean value indicating whether the user has enabled Switch
    /// Control in Settings.
    public var isSwitchControlEnabled: Bool {
        accessibilityStatus.isSwitchControlRunning
    }

    /// A Boolean value indicating whether the user has enabled VoiceOver
    /// in Settings.
    public var isVoiceOverEnabled: Bool {
        accessibilityStatus.isVoiceOverRunning
    }

    @Inject private var accessibilityStatus: any AccessibilityStatusProtocol

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIAccessibility.assistiveTouchStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.assistiveTouchStatusDidChange(self.isAssistiveTouchEnabled))
        }

        observe(UIAccessibility.boldTextStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.boldTextStatusDidChange(self.isBoldTextEnabled))
        }

        observe(UIAccessibility.closedCaptioningStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.closedCaptioningStatusDidChange(self.isClosedCaptioningEnabled))
        }

        observe(UIAccessibility.darkerSystemColorsStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.darkenColorsStatusDidChange(self.isDarkenColorsEnabled))
        }

        observe(UIAccessibility.grayscaleStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.grayscaleStatusDidChange(self.isGrayscaleEnabled))
        }

        observe(UIAccessibility.guidedAccessStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.guidedAccessStatusDidChange(self.isGuidedAccessEnabled))
        }

#if os(iOS)
        observe(UIAccessibility.hearingDevicePairedEarDidChangeNotification) { [unowned self] _ in
            self.handler(.hearingDevicePairedEarDidChange(self.hearingDevicePairedEar))
        }
#endif

        observe(UIAccessibility.invertColorsStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.invertColorsStatusDidChange(self.isInvertColorsEnabled))
        }

        observe(UIAccessibility.monoAudioStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.monoAudioStatusDidChange(self.isMonoAudioEnabled))
        }

        observe(UIAccessibility.reduceMotionStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.reduceMotionStatusDidChange(self.isReduceMotionEnabled))
        }

        observe(UIAccessibility.reduceTransparencyStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.reduceTransparencyStatusDidChange(self.isReduceTransparencyEnabled))
        }

        observe(UIAccessibility.shakeToUndoDidChangeNotification) { [unowned self] _ in
            self.handler(.shakeToUndoStatusDidChange(self.isShakeToUndoEnabled))
        }

        observe(UIAccessibility.speakScreenStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.speakScreenStatusDidChange(self.isSpeakScreenEnabled))
        }

        observe(UIAccessibility.speakSelectionStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.speakSelectionStatusDidChange(self.isSpeakSelectionEnabled))
        }

        observe(UIAccessibility.switchControlStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.switchControlStatusDidChange(self.isSwitchControlEnabled))
        }

        observe(UIAccessibility.voiceOverStatusDidChangeNotification) { [unowned self] _ in
            self.handler(.voiceOverStatusDidChange(self.isVoiceOverEnabled))
        }
    }
}

#endif
