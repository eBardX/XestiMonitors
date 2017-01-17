//
//  ProtectedDataMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `ProtectedDataMonitor` object monitors the app for changes to the
/// accessibility of protected files.
///
public class ProtectedDataMonitor: BaseNotificationMonitor {

    ///
    /// Encapsulates changes to the accessibility of protected files.
    ///
    public enum Event {

        ///
        /// Protected files have become available for your code to access.
        ///
        case didBecomeAvailable

        ///
        /// Protected files are about to be locked down and become
        /// inaccessible.
        ///
        case willBecomeUnavailable
    }

    // Public Initializers

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly before
    ///                 protected files are locked down and become inaccessible.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.handler = handler

    }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Private Instance Methods

    @objc private func applicationProtectedDataDidBecomeAvailable(_ notification: Notification) {

        handler(.didBecomeAvailable)

    }

    @objc private func applicationProtectedDataWillBecomeUnavailable(_ notification: Notification) {

        handler(.willBecomeUnavailable)

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationProtectedDataDidBecomeAvailable(_:)),
                                       name: .UIApplicationProtectedDataDidBecomeAvailable,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationProtectedDataWillBecomeUnavailable(_:)),
                                       name: .UIApplicationProtectedDataWillBecomeUnavailable,
                                       object: nil)

        return true

    }

}
