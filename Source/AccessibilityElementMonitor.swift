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
/// An `AccessibilityElementMonitor` instance monitors the system for changes
/// to element focus by an assistive technology.
///
public class AccessibilityElementMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to element focus by an assistive technology.
    ///
    public enum Event {
        ///
        /// An assistive technology has changed element focus.
        ///
        case didFocus(Info)
    }

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

            self.assistiveTechnology = userInfo?[UIAccessibilityAssistiveTechnologyKey] as? String
            self.focusedElement = userInfo?[UIAccessibilityFocusedElementKey]
            self.unfocusedElement = userInfo?[UIAccessibilityUnfocusedElementKey]

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `AccessibilityElementMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when an assistive technology
    ///                 changes element focus.
    ///
    public init(notificationCenter: NotificationCenter = NSNotificationCenter.`default`,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.handler = handler

        super.init(notificationCenter: notificationCenter,
                   queue: queue)

    }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() {

        super.addNotificationObservers()

        observe(.UIAccessibilityElementFocused) { [unowned self] in
            self.handler(.didFocus(Info($0)))
        }

    }

}
