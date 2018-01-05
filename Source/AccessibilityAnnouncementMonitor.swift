//
//  AccessibilityAnnouncementMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2017-01-16.
//
//  © 2017 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An `AccessibilityAnnouncementMonitor` instance monitors the system for
/// accessibility announcements that VoiceOver has finished outputting.
///
public class AccessibilityAnnouncementMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates accessibility announcements that VoiceOver has finished
    /// outputting.
    ///
    public enum Event {
        ///
        /// VoiceOver has finished outputting an accessibility announcement.
        ///
        case didFinish(Info)
    }

    ///
    /// Encapsulates information associated with an accessibility announcement
    /// that VoiceOver has finished outputting.
    ///
    public struct Info {

        ///
        /// The text used for the announcement.
        ///
        public let stringValue: String

        ///
        /// Indicates whether VoiceOver successfully outputted the
        /// announcement.
        ///
        public let wasSuccessful: Bool

        internal init (_ notification: Notification) {

            let userInfo = notification.userInfo

            if let value = userInfo?[UIAccessibilityAnnouncementKeyStringValue] as? String {
                self.stringValue = value
            } else {
                self.stringValue = " "
            }

            if let value = (userInfo?[UIAccessibilityAnnouncementKeyWasSuccessful] as? NSNumber)?.boolValue {
                self.wasSuccessful = value
            } else {
                self.wasSuccessful = false
            }

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `AccessibilityAnnouncementMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when VoiceOver finishes outputting
    ///                 an announcement.
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

        observe(.UIAccessibilityAnnouncementDidFinish) { [unowned self] in
            self.handler(.didFinish(Info($0)))
        }

    }

}
