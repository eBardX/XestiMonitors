//
//  KeyboardMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `KeyboardMonitor` object monitors the keyboard for changes to its
/// visibility or to its frame.
///
public class KeyboardMonitor: BaseNotificationMonitor {

    // Public Nested Types

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

            if #available(iOS 9.0, *) {
                if let value = (userInfo?[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue {
                    self.isLocal = value
                } else {
                    self.isLocal = true
                }
            } else {
                self.isLocal = true
            }

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `KeyboardMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when the visibility of the keyboard
    ///                 or the frame of the keyboard changes or is about to
    ///                 change.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.handler = handler

        super.init(queue: queue)

    }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIKeyboardDidChangeFrame) { [unowned self] in
            self.handler(.didChangeFrame(Info($0)))
        }

        observe(.UIKeyboardDidHide) { [unowned self] in
            self.handler(.didHide(Info($0)))
        }

        observe(.UIKeyboardDidShow) { [unowned self] in
            self.handler(.didShow(Info($0)))
        }

        observe(.UIKeyboardWillChangeFrame) { [unowned self] in
            self.handler(.willChangeFrame(Info($0)))
        }

        observe(.UIKeyboardWillHide) { [unowned self] in
            self.handler(.willHide(Info($0)))
        }

        observe(.UIKeyboardWillShow) { [unowned self] in
            self.handler(.willShow(Info($0)))
        }

        return true

    }

}