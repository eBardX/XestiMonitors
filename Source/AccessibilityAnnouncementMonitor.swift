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
/// An `AccessibilityAnnouncementMonitor` object monitors the system for
/// accessibility announcements that VoiceOver has finished outputting.
///
public class AccessibilityAnnouncementMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates information associated with an accessibility announcement
    /// that VoiceOver has finished outputting.
    ///
    public struct Info {

        ///
        /// Indicates whether VoiceOver successfully outputted the
        /// announcement.
        ///
        public let didSucceed: Bool

        ///
        /// The text used for the announcement.
        ///
        public let text: String

        internal init (_ notification: Notification) {

            let userInfo = notification.userInfo

            if let value = (userInfo?[UIAccessibilityAnnouncementKeyWasSuccessful] as? NSNumber)?.boolValue {
                self.didSucceed = value
            } else {
                self.didSucceed = false
            }

            if let value = userInfo?[UIAccessibilityAnnouncementKeyStringValue] as? String {
                self.text = value
            } else {
                self.text = " "
            }

        }

    }

    // Public Initializers

    ///
    /// Initializes a new `AccessibilityAnnouncementMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when VoiceOver finishes outputting
    ///                 an announcement.
    ///
    public init(handler: @escaping (Info) -> Void) {

        self.handler = handler

    }

    // Private Instance Properties

    private let handler: (Info) -> Void

    // Private Instance Methods

    @objc private func accessibilityAnnouncementDidFinish(_ notification: Notification) {

        handler(Info(notification))

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        notificationCenter.addObserver(self,
                                       selector: #selector(accessibilityAnnouncementDidFinish(_:)),
                                       name: .UIAccessibilityAnnouncementDidFinish,
                                       object: nil)

        return true

    }

}
