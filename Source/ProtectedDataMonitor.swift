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
/// A `ProtectedDataMonitor` instance monitors the app for changes to the
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

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly before
    ///                 protected files are locked down and become inaccessible.
    ///
    public init(notificationCenter: NotificationCenter = NSNotificationCenter.`default`,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(notificationCenter: notificationCenter,
                   queue: queue)
    }

    private let handler: (Event) -> Void

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIApplicationProtectedDataDidBecomeAvailable) { [unowned self] _ in
            self.handler(.didBecomeAvailable)
        }

        observe(.UIApplicationProtectedDataWillBecomeUnavailable) { [unowned self] _ in
            self.handler(.willBecomeUnavailable)
        }
    }
}
