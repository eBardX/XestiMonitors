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

    // Public Nested Types

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
    ///   - queue:      The operation queue on which notification blocks
    ///                 execute. By default, the main operation queue is used.
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly before
    ///                 protected files are locked down and become inaccessible.
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

        observe(.UIApplicationProtectedDataDidBecomeAvailable) { [unowned self] _ in
            self.handler(.didBecomeAvailable)
        }

        observe(.UIApplicationProtectedDataWillBecomeUnavailable) { [unowned self] _ in
            self.handler(.willBecomeUnavailable)
        }

        return true

    }

}
