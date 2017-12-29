//
//  BackgroundRefreshMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `BackgroundRefreshMonitor` instance monitors the app for changes to its
/// status for downloading content in the background.
///
public class BackgroundRefreshMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the app’s status for downloading content in the
    /// background.
    ///
    public enum Event {
        ///
        /// The background refresh status has changed.
        ///
        case statusDidChange(UIBackgroundRefreshStatus)
    }

    // Public Initializers

    ///
    /// Initializes a new `BackgroundRefreshMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - application
    ///   - handler:    The handler to call when the app’s status for
    ///                 downloading content in the background changes.
    ///
    public init(notificationCenter: NotificationCenter = .`default`,
                queue: OperationQueue = .main,
                application: Application = UIApplication.shared,
                handler: @escaping (Event) -> Void) {

        self.application = application
        self.handler = handler

        super.init(notificationCenter: notificationCenter,
                   queue: queue)

    }

    // Public Instance Properties

    ///
    /// Whether the app can be launched into the background to handle
    /// background behaviors.
    ///
    public var status: UIBackgroundRefreshStatus { return application.backgroundRefreshStatus }

    // Private Instance Properties

    private let application: Application
    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard
            super.addNotificationObservers()
            else { return false }

        observe(.UIApplicationBackgroundRefreshStatusDidChange) { [unowned self] _ in
            self.handler(.statusDidChange(self.status))
        }

        return true

    }

}
