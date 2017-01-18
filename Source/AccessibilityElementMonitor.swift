//
//  AccessibilityElementMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-01-17.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An `AccessibilityElementMonitor` object monitors the system for changes to
/// element focus by an assistive technology.
///
public class AccessibilityElementMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates information associated with an element focus change by an
    /// assistive technology.
    ///
    public struct Info {

        ///
        /// The identifier of the assistive technology.
        ///
        public let assistiveTechnology: String?

        ///
        /// The element that is now focused by the assistive technology.
        ///
        public let focusedElement: Any?

        ///
        /// The element that was previously focused by the assistive
        /// technology.
        ///
        public let unfocusedElement: Any?

        internal init (_ notification: Notification) {

            let userInfo = notification.userInfo

            if #available(iOS 9.0, *) {
                self.assistiveTechnology = userInfo?[UIAccessibilityAssistiveTechnologyKey] as? String
            } else {
                self.assistiveTechnology = nil
            }

            if #available(iOS 9.0, *) {
                self.focusedElement = userInfo?[UIAccessibilityFocusedElementKey]
            } else {
                self.focusedElement = nil
            }

            if #available(iOS 9.0, *) {
                self.unfocusedElement = userInfo?[UIAccessibilityUnfocusedElementKey]
            } else {
                self.unfocusedElement = nil
            }

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `AccessibilityElementMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when an assistive technology
    ///                 changes element focus.
    ///
    public init(handler: @escaping (Info) -> Void) {

        self.handler = handler

    }

    // Private Instance Properties

    private let handler: (Info) -> Void

    // Private Instance Methods

    @objc private func accessibilityElementFocused(_ notification: Notification) {

        handler(Info(notification))

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        if #available(iOS 9.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(accessibilityElementFocused(_:)),
                                           name: .UIAccessibilityElementFocused,
                                           object: nil)
        }

        return true

    }

}
