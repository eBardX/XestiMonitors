//
//  KeyboardMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

    import Foundation
    import UIKit

    ///
    /// A `KeyboardMonitor` instance monitors the keyboard for changes to its
    /// visibility or to its frame.
    ///
    public class KeyboardMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the visibility of the keyboard and to the frame
        /// of the keyboard.
        ///
        public enum Event {
            ///
            /// The frame of the keyboard has changed.
            ///
            case didChangeFrame(Info)

            ///
            /// The keyboard has been dismissed.
            ///
            case didHide(Info)

            ///
            /// The keyboard has been displayed.
            ///
            case didShow(Info)

            ///
            /// The frame of the keyboard is about to change.
            ///
            case willChangeFrame(Info)

            ///
            /// The keyboard is about to be dismissed.
            ///
            case willHide(Info)

            ///
            /// The keyboard is about to be displayed.
            ///
            case willShow(Info)
        }

        ///
        /// Encapsulates information associated with a keyboard monitor event.
        ///
        public struct Info {
            ///
            /// Defines how the keyboard will be animated onto or off the screen.
            ///
            public let animationCurve: UIViewAnimationCurve

            ///
            /// The duration of the animation onto or off the screen in seconds.
            ///
            public let animationDuration: TimeInterval

            ///
            /// The start frame of the keyboard in screen coordinates. These
            /// coordinates do not take into account any rotation factors applied
            /// to the window’s contents as a result of interface orientation
            /// changes. Thus, you may need to convert the rectangle to window
            /// coordinates or to view coordinates before using it.
            ///
            public let frameBegin: CGRect

            ///
            /// The end frame of the keyboard in screen coordinates. These
            /// coordinates do not take into account any rotation factors applied
            /// to the window’s contents as a result of interface orientation
            /// changes. Thus, you may need to convert the rectangle to window
            /// coordinates or to view coordinates (before using it.
            ///
            public let frameEnd: CGRect

            ///
            /// Whether the keyboard belongs to the current app. With multitasking
            /// on iPad, all visible apps are notified when the keyboard appears
            /// and disappears. `true` for the app that caused the keyboard to
            /// appear and `false` for any other apps.
            ///
            public let isLocal: Bool

            internal init (_ notification: Notification) {
                let userInfo = notification.userInfo

                if let rawValue = (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
                    let value = UIViewAnimationCurve(rawValue: rawValue) {
                    self.animationCurve = value
                } else {
                    self.animationCurve = .easeInOut
                }

                if let value = (userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                    self.animationDuration = value
                } else {
                    self.animationDuration = 0.0
                }

                if let value = (userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                    self.frameBegin = value
                } else {
                    self.frameBegin = .zero
                }

                if let value = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    self.frameEnd = value
                } else {
                    self.frameEnd = .zero
                }

                if let value = (userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
                    self.isLocal = value
                } else {
                    self.isLocal = true
                }
            }
        }

        ///
        /// Specifies which events to monitor.
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `didChangeFrame` events.
            ///
            public static let didChangeFrame = Options(rawValue: 1 << 0)

            ///
            /// Monitor `didHide` events.
            ///
            public static let didHide = Options(rawValue: 1 << 1)

            ///
            /// Monitor `didShow` events.
            ///
            public static let didShow = Options(rawValue: 1 << 2)

            ///
            /// Monitor `willChangeFrame` events.
            ///
            public static let willChangeFrame = Options(rawValue: 1 << 3)

            ///
            /// Monitor `willHide` events.
            ///
            public static let willHide = Options(rawValue: 1 << 4)

            ///
            /// Monitor `willShow` events.
            ///
            public static let willShow = Options(rawValue: 1 << 5)

            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.didChangeFrame,
                                              .didHide,
                                              .didShow,
                                              .willChangeFrame,
                                              .willHide,
                                              .willShow]

            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }

            /// :nodoc:
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `KeyboardMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - options:    The options that specify which events to monitor. By
        ///                 default, all events are monitored.
        ///   - handler:    The handler to call when the visibility of the keyboard
        ///                 or the frame of the keyboard changes or is about to
        ///                 change.
        ///
        public init(queue: OperationQueue = .main,
                    options: Options = .all,
                    handler: @escaping (Event) -> Void) {
            self.handler = handler
            self.options = options

            super.init(queue: queue)
        }

        private let handler: (Event) -> Void
        private let options: Options

        public override func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.didChangeFrame) {
                observe(.UIKeyboardDidChangeFrame) { [unowned self] in
                    self.handler(.didChangeFrame(Info($0)))
                }
            }

            if options.contains(.didHide) {
                observe(.UIKeyboardDidHide) { [unowned self] in
                    self.handler(.didHide(Info($0)))
                }
            }

            if options.contains(.didShow) {
                observe(.UIKeyboardDidShow) { [unowned self] in
                    self.handler(.didShow(Info($0)))
                }
            }

            if options.contains(.willChangeFrame) {
                observe(.UIKeyboardWillChangeFrame) { [unowned self] in
                    self.handler(.willChangeFrame(Info($0)))
                }
            }

            if options.contains(.willHide) {
                observe(.UIKeyboardWillHide) { [unowned self] in
                    self.handler(.willHide(Info($0)))
                }
            }

            if options.contains(.willShow) {
                observe(.UIKeyboardWillShow) { [unowned self] in
                    self.handler(.willShow(Info($0)))
                }
            }
        }
    }

#endif
