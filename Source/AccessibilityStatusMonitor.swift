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
/// An `AccessibilityStatusMonitor` object monitors ...
///
public class AccessibilityStatusMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates changes to ...
    ///
    public enum Event {

        ///
        ///
        ///
        case assistiveTouchStatusDidChange(Bool)

        ///
        ///
        ///
        case boldTextStatusDidChange(Bool)

        ///
        ///
        ///
        case closedCaptioningStatusDidChange(Bool)

        ///
        ///
        ///
        case darkenSystemColorsStatusDidChange(Bool)

        ///
        ///
        ///
        case grayscaleStatusDidChange(Bool)

        ///
        ///
        ///
        case guidedAccessStatusDidChange(Bool)

        ///
        ///
        ///
        @available(iOS 10.0, *)
        case hearingDevicePairedEarDidChange(UIAccessibilityHearingDeviceEar)

        ///
        ///
        ///
        case invertColorsStatusDidChange(Bool)

        ///
        ///
        ///
        case monoAudioStatusDidChange(Bool)

        ///
        ///
        ///
        case reduceMotionStatusDidChange(Bool)

        ///
        ///
        ///
        case reduceTransparencyStatusDidChange(Bool)

        ///
        ///
        ///
        case shakeToUndoDidChange(Bool)

        ///
        ///
        ///
        case speakScreenStatusDidChange(Bool)

        ///
        ///
        ///
        case speakSelectionStatusDidChange(Bool)

        ///
        ///
        ///
        case switchControlStatusDidChange(Bool)

        ///
        ///
        ///
        case voiceOverStatusDidChange(Bool)

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
    ///
    ///
    @available(iOS 10.0, *)
    public var hearingDevicePairedEar: UIAccessibilityHearingDeviceEar { return UIAccessibilityHearingDevicePairedEar() }

    ///
    ///
    ///
    @available(iOS 10.0, *)
    public var isAssistiveTouchRunning: Bool { return UIAccessibilityIsAssistiveTouchRunning() }

    ///
    ///
    ///
    public var isBoldTextEnabled: Bool { return UIAccessibilityIsBoldTextEnabled() }

    ///
    ///
    ///
    public var isClosedCaptioningEnabled: Bool { return UIAccessibilityIsClosedCaptioningEnabled() }

    ///
    ///
    ///
    public var isDarkenSystemColorsEnabled: Bool { return UIAccessibilityDarkerSystemColorsEnabled() }

    ///
    ///
    ///
    public var isGrayscaleEnabled: Bool { return UIAccessibilityIsGrayscaleEnabled() }

    ///
    ///
    ///
    public var isGuidedAccessEnabled: Bool { return UIAccessibilityIsGuidedAccessEnabled() }

    ///
    ///
    ///
    public var isInvertColorsEnabled: Bool { return UIAccessibilityIsInvertColorsEnabled() }

    ///
    ///
    ///
    public var isMonoAudioEnabled: Bool { return UIAccessibilityIsMonoAudioEnabled() }

    ///
    ///
    ///
    public var isReduceMotionEnabled: Bool { return UIAccessibilityIsReduceMotionEnabled() }

    ///
    ///
    ///
    public var isReduceTransparencyEnabled: Bool { return UIAccessibilityIsReduceTransparencyEnabled() }

    ///
    ///
    ///
    @available(iOS 9.0, *)
    public var isShakeToUndoEnabled: Bool { return UIAccessibilityIsShakeToUndoEnabled() }

    ///
    ///
    ///
    public var isSpeakScreenEnabled: Bool { return UIAccessibilityIsSpeakScreenEnabled() }

    ///
    ///
    ///
    public var isSpeakSelectionEnabled: Bool { return UIAccessibilityIsSpeakSelectionEnabled() }

    ///
    ///
    ///
    public var isSwitchControlRunning: Bool { return UIAccessibilityIsSwitchControlRunning() }

    ///
    ///
    ///
    public var isVoiceOverRunning: Bool { return UIAccessibilityIsVoiceOverRunning() }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Private Instance Methods

    @available(iOS 10.0, *)
    @objc private func accessibilityAssistiveTouchStatusDidChange(_ notification: NSNotification) {

        handler(.assistiveTouchStatusDidChange(isAssistiveTouchRunning))

    }

    @objc private func accessibilityBoldTextStatusDidChange(_ notification: NSNotification) {

        handler(.boldTextStatusDidChange(isBoldTextEnabled))

    }

    @objc private func accessibilityClosedCaptioningStatusDidChange(_ notification: NSNotification) {

        handler(.closedCaptioningStatusDidChange(isClosedCaptioningEnabled))

    }

    @objc private func accessibilityDarkerSystemColorsStatusDidChange(_ notification: NSNotification) {

        handler(.darkenSystemColorsStatusDidChange(isDarkenSystemColorsEnabled))

    }

    @objc private func accessibilityGrayscaleStatusDidChange(_ notification: NSNotification) {

        handler(.grayscaleStatusDidChange(isGrayscaleEnabled))

    }

    @objc private func accessibilityGuidedAccessStatusDidChange(_ notification: NSNotification) {

        handler(.guidedAccessStatusDidChange(isGuidedAccessEnabled))

    }

    @available(iOS 10.0, *)
    @objc private func accessibilityHearingDevicePairedEarDidChange(_ notification: NSNotification) {

        handler(.hearingDevicePairedEarDidChange(hearingDevicePairedEar))

    }

    @objc private func accessibilityInvertColorsStatusDidChange(_ notification: NSNotification) {

        handler(.invertColorsStatusDidChange(isInvertColorsEnabled))

    }

    @objc private func accessibilityMonoAudioStatusDidChange(_ notification: NSNotification) {

        handler(.monoAudioStatusDidChange(isMonoAudioEnabled))

    }

    @objc private func accessibilityReduceMotionStatusDidChange(_ notification: NSNotification) {

        handler(.reduceMotionStatusDidChange(isReduceMotionEnabled))

    }

    @objc private func accessibilityReduceTransparencyStatusDidChange(_ notification: NSNotification) {

        handler(.reduceTransparencyStatusDidChange(isReduceTransparencyEnabled))

    }

    @available(iOS 9.0, *)
    @objc private func accessibilityShakeToUndoDidChange(_ notification: NSNotification) {

        handler(.shakeToUndoDidChange(isShakeToUndoEnabled))

    }

    @objc private func accessibilitySpeakScreenStatusDidChange(_ notification: NSNotification) {

        handler(.speakScreenStatusDidChange(isSpeakScreenEnabled))

    }

    @objc private func accessibilitySpeakSelectionStatusDidChange(_ notification: NSNotification) {

        handler(.speakSelectionStatusDidChange(isSpeakSelectionEnabled))

    }

    @objc private func accessibilitySwitchControlStatusDidChange(_ notification: NSNotification) {

        handler(.switchControlStatusDidChange(isSwitchControlRunning))

    }

    @objc private func accessibilityVoiceOverStatusChanged(_ notification: NSNotification) {

        handler(.voiceOverStatusDidChange(isVoiceOverRunning))

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

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
                                       name: NSNotification.Name(UIAccessibilityVoiceOverStatusChanged),
                                       object: nil)

        return true

    }

}
