//
//  AccessibilityStatusMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-01-13.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

    import Foundation
    import UIKit

    ///
    /// An `AccessibilityStatusMonitor` instance monitors the system for
    /// changes to the status of various accessibility settings.
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

            #if os(iOS)
            ///
            /// The system’s hearing device pairing options have changed.
            ///
            @available(iOS 10.0, *)
            case hearingDevicePairedEarDidChange(UIAccessibilityHearingDeviceEar)
            #endif

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
        /// Specifies which events to monitor.
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `assistiveTouchStatusDidChange` events.
            ///
            public static let assistiveTouchStatusDidChange = Options(rawValue: 1 << 0)

            ///
            /// Monitor `boldTextStatusDidChange` events.
            ///
            public static let boldTextStatusDidChange = Options(rawValue: 1 << 1)

            ///
            /// Monitor `closedCaptioningStatusDidChange` events.
            ///
            public static let closedCaptioningStatusDidChange = Options(rawValue: 1 << 2)

            ///
            /// Monitor `darkenColorsStatusDidChange` events.
            ///
            public static let darkenColorsStatusDidChange = Options(rawValue: 1 << 3)

            ///
            /// Monitor `grayscaleStatusDidChange` events.
            ///
            public static let grayscaleStatusDidChange = Options(rawValue: 1 << 4)

            ///
            /// Monitor `guidedAccessStatusDidChange` events.
            ///
            public static let guidedAccessStatusDidChange = Options(rawValue: 1 << 5)

            #if os(iOS)
            ///
            /// Monitor `hearingDevicePairedEarDidChange` events.
            ///
            public static let hearingDevicePairedEarDidChange = Options(rawValue: 1 << 6)
            #endif

            ///
            /// Monitor `invertColorsStatusDidChange` events.
            ///
            public static let invertColorsStatusDidChange = Options(rawValue: 1 << 7)

            ///
            /// Monitor `monoAudioStatusDidChange` events.
            ///
            public static let monoAudioStatusDidChange = Options(rawValue: 1 << 8)

            ///
            /// Monitor `reduceMotionStatusDidChange` events.
            ///
            public static let reduceMotionStatusDidChange = Options(rawValue: 1 << 9)

            ///
            /// Monitor `reduceTransparencyStatusDidChange` events.
            ///
            public static let reduceTransparencyStatusDidChange = Options(rawValue: 1 << 10)

            ///
            /// Monitor `shakeToUndoStatusDidChange` events.
            ///
            public static let shakeToUndoStatusDidChange = Options(rawValue: 1 << 11)

            ///
            /// Monitor `speakScreenStatusDidChange` events.
            ///
            public static let speakScreenStatusDidChange = Options(rawValue: 1 << 12)

            ///
            /// Monitor `speakSelectionStatusDidChange` events.
            ///
            public static let speakSelectionStatusDidChange = Options(rawValue: 1 << 13)

            ///
            /// Monitor `switchControlStatusDidChange` events.
            ///
            public static let switchControlStatusDidChange = Options(rawValue: 1 << 14)

            ///
            /// Monitor `voiceOverStatusDidChange` events.
            ///
            public static let voiceOverStatusDidChange = Options(rawValue: 1 << 15)

            #if os(iOS)
            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.assistiveTouchStatusDidChange,
                                              .boldTextStatusDidChange,
                                              .closedCaptioningStatusDidChange,
                                              .darkenColorsStatusDidChange,
                                              .grayscaleStatusDidChange,
                                              .guidedAccessStatusDidChange,
                                              .hearingDevicePairedEarDidChange,
                                              .invertColorsStatusDidChange,
                                              .monoAudioStatusDidChange,
                                              .reduceMotionStatusDidChange,
                                              .reduceTransparencyStatusDidChange,
                                              .shakeToUndoStatusDidChange,
                                              .speakScreenStatusDidChange,
                                              .speakSelectionStatusDidChange,
                                              .switchControlStatusDidChange,
                                              .voiceOverStatusDidChange]
            #else
            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.assistiveTouchStatusDidChange,
                                              .boldTextStatusDidChange,
                                              .closedCaptioningStatusDidChange,
                                              .darkenColorsStatusDidChange,
                                              .grayscaleStatusDidChange,
                                              .guidedAccessStatusDidChange,
                                              .invertColorsStatusDidChange,
                                              .monoAudioStatusDidChange,
                                              .reduceMotionStatusDidChange,
                                              .reduceTransparencyStatusDidChange,
                                              .shakeToUndoStatusDidChange,
                                              .speakScreenStatusDidChange,
                                              .speakSelectionStatusDidChange,
                                              .switchControlStatusDidChange,
                                              .voiceOverStatusDidChange]
            #endif

            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }

            /// :nodoc:
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `AccessibilityStatusMonitor`.
        ///
        /// - Parameters:
        ///   - options:    The options that specify which events to monitor.
        ///                 By default, all events are monitored.
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - handler:    The handler to call when the status of a system
        ///                 accessibility setting changes.
        ///
        public init(options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.accessibilityStatus = AccessibilityStatusInjector.inject()
            self.handler = handler
            self.options = options

            super.init(queue: queue)
        }

        #if os(iOS)

        ///
        /// The current hearing device pairing options.
        ///
        @available(iOS 10.0, *)
        public var hearingDevicePairedEar: UIAccessibilityHearingDeviceEar {
            return accessibilityStatus.hearingDevicePairedEar()
        }

        #endif

        ///
        /// A Boolean value indicating whether the user has enabled
        /// AssistiveTouch in Settings.
        ///
        @available(iOS 10.0, tvOS 10.0, *)
        public var isAssistiveTouchEnabled: Bool {
            return accessibilityStatus.isAssistiveTouchRunning()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Bold Text
        /// in Settings.
        ///
        public var isBoldTextEnabled: Bool {
            return accessibilityStatus.isBoldTextEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Closed
        /// Captioning in Settings.
        ///
        public var isClosedCaptioningEnabled: Bool {
            return accessibilityStatus.isClosedCaptioningEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Darken
        /// Colors in Settings.
        ///
        public var isDarkenColorsEnabled: Bool {
            return accessibilityStatus.darkerSystemColorsEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Grayscale
        /// in Settings.
        ///
        public var isGrayscaleEnabled: Bool {
            return accessibilityStatus.isGrayscaleEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Guided
        /// Access in Settings.
        ///
        public var isGuidedAccessEnabled: Bool {
            return accessibilityStatus.isGuidedAccessEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Invert
        /// Colors in Settings.
        ///
        public var isInvertColorsEnabled: Bool {
            return accessibilityStatus.isInvertColorsEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Mono Audio
        /// in Settings.
        ///
        public var isMonoAudioEnabled: Bool {
            return accessibilityStatus.isMonoAudioEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Reduce
        /// Motion in Settings.
        ///
        public var isReduceMotionEnabled: Bool {
            return accessibilityStatus.isReduceMotionEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Reduce
        /// Transparency in Settings.
        ///
        public var isReduceTransparencyEnabled: Bool {
            return accessibilityStatus.isReduceTransparencyEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Shake to
        /// Undo in Settings.
        ///
        public var isShakeToUndoEnabled: Bool {
            return accessibilityStatus.isShakeToUndoEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Speak
        /// Screen in Settings.
        ///
        public var isSpeakScreenEnabled: Bool {
            return accessibilityStatus.isSpeakScreenEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Speak
        /// Selection in Settings.
        ///
        public var isSpeakSelectionEnabled: Bool {
            return accessibilityStatus.isSpeakSelectionEnabled()
        }

        ///
        /// A Boolean value indicating whether the user has enabled Switch
        /// Control in Settings.
        ///
        public var isSwitchControlEnabled: Bool {
            return accessibilityStatus.isSwitchControlRunning()
        }

        ///
        /// A Boolean value indicating whether the user has enabled VoiceOver
        /// in Settings.
        ///
        public var isVoiceOverEnabled: Bool {
            return accessibilityStatus.isVoiceOverRunning()
        }

        private let accessibilityStatus: AccessibilityStatusProtocol
        private let handler: (Event) -> Void
        private let options: Options

        // swiftlint:disable cyclomatic_complexity
        override public func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.assistiveTouchStatusDidChange),
                #available(iOS 10.0, tvOS 10.0, *) {
                observe(.UIAccessibilityAssistiveTouchStatusDidChange) { [unowned self] _ in
                    self.handler(.assistiveTouchStatusDidChange(self.isAssistiveTouchEnabled))
                }
            }

            if options.contains(.boldTextStatusDidChange) {
                observe(.UIAccessibilityBoldTextStatusDidChange) { [unowned self] _ in
                    self.handler(.boldTextStatusDidChange(self.isBoldTextEnabled))
                }
            }

            if options.contains(.closedCaptioningStatusDidChange) {
                observe(.UIAccessibilityClosedCaptioningStatusDidChange) { [unowned self] _ in
                    self.handler(.closedCaptioningStatusDidChange(self.isClosedCaptioningEnabled))
                }
            }

            if options.contains(.darkenColorsStatusDidChange) {
                observe(.UIAccessibilityDarkerSystemColorsStatusDidChange) { [unowned self] _ in
                    self.handler(.darkenColorsStatusDidChange(self.isDarkenColorsEnabled))
                }
            }

            if options.contains(.grayscaleStatusDidChange) {
                observe(.UIAccessibilityGrayscaleStatusDidChange) { [unowned self] _ in
                    self.handler(.grayscaleStatusDidChange(self.isGrayscaleEnabled))
                }
            }

            if options.contains(.guidedAccessStatusDidChange) {
                observe(.UIAccessibilityGuidedAccessStatusDidChange) { [unowned self] _ in
                    self.handler(.guidedAccessStatusDidChange(self.isGuidedAccessEnabled))
                }
            }

            #if os(iOS)
                if options.contains(.hearingDevicePairedEarDidChange),
                    #available(iOS 10.0, *) {
                    observe(.UIAccessibilityHearingDevicePairedEarDidChange) { [unowned self] _ in
                        self.handler(.hearingDevicePairedEarDidChange(self.hearingDevicePairedEar))
                    }
                }
            #endif

            if options.contains(.invertColorsStatusDidChange) {
                observe(.UIAccessibilityInvertColorsStatusDidChange) { [unowned self] _ in
                    self.handler(.invertColorsStatusDidChange(self.isInvertColorsEnabled))
                }
            }

            if options.contains(.monoAudioStatusDidChange) {
                observe(.UIAccessibilityMonoAudioStatusDidChange) { [unowned self] _ in
                    self.handler(.monoAudioStatusDidChange(self.isMonoAudioEnabled))
                }
            }

            if options.contains(.reduceMotionStatusDidChange) {
                observe(.UIAccessibilityReduceMotionStatusDidChange) { [unowned self] _ in
                    self.handler(.reduceMotionStatusDidChange(self.isReduceMotionEnabled))
                }
            }

            if options.contains(.reduceTransparencyStatusDidChange) {
                observe(.UIAccessibilityReduceTransparencyStatusDidChange) { [unowned self] _ in
                    self.handler(.reduceTransparencyStatusDidChange(self.isReduceTransparencyEnabled))
                }
            }

            if options.contains(.shakeToUndoStatusDidChange) {
                observe(.UIAccessibilityShakeToUndoDidChange) { [unowned self] _ in
                    self.handler(.shakeToUndoStatusDidChange(self.isShakeToUndoEnabled))
                }
            }

            if options.contains(.speakScreenStatusDidChange) {
                observe(.UIAccessibilitySpeakScreenStatusDidChange) { [unowned self] _ in
                    self.handler(.speakScreenStatusDidChange(self.isSpeakScreenEnabled))
                }
            }

            if options.contains(.speakSelectionStatusDidChange) {
                observe(.UIAccessibilitySpeakSelectionStatusDidChange) { [unowned self] _ in
                    self.handler(.speakSelectionStatusDidChange(self.isSpeakSelectionEnabled))
                }
            }

            if options.contains(.switchControlStatusDidChange) {
                observe(.UIAccessibilitySwitchControlStatusDidChange) { [unowned self] _ in
                    self.handler(.switchControlStatusDidChange(self.isSwitchControlEnabled))
                }
            }

            if options.contains(.voiceOverStatusDidChange) {
                let voiceOverStatusDidChange: Notification.Name

                if #available(iOS 11.0, tvOS 11.0, *) {
                    voiceOverStatusDidChange = .UIAccessibilityVoiceOverStatusDidChange
                } else {
                    voiceOverStatusDidChange = Notification.Name(UIAccessibilityVoiceOverStatusChanged)
                }

                observe(voiceOverStatusDidChange) { [unowned self] _ in
                    self.handler(.voiceOverStatusDidChange(self.isVoiceOverEnabled))
                }
            }
        }

        // MARK: Deprecated

        ///
        /// Initializes a new `AccessibilityStatusMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - options:    The options that specify which events to monitor.
        ///                 By default, all events are monitored.
        ///   - handler:    The handler to call when the status of a system
        ///                 accessibility setting changes.
        ///
        /// - Warning:  Deprecated. Use `init(options:queue:handler)` instead.
        ///
        @available(*, deprecated, message: "Use `init(options:queue:handler)` instead.")
        public init(queue: OperationQueue = .main,
                    options: Options = .all,
                    handler: @escaping (Event) -> Void) {
            self.accessibilityStatus = AccessibilityStatusInjector.inject()
            self.handler = handler
            self.options = options

            super.init(queue: queue)
        }
    }

#endif
