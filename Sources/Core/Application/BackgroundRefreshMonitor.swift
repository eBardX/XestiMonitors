//
//  BackgroundRefreshMonitor.swift
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
    /// A `BackgroundRefreshMonitor` instance monitors the app for changes to its
    /// status for downloading content in the background.
    ///
    public class BackgroundRefreshMonitor: BaseNotificationMonitor {
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

        ///
        /// Initializes a new `BackgroundRefreshMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the app’s status for
        ///                 downloading content in the background changes.
        ///
        public init(queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.application = ApplicationInjector.inject()
            self.handler = handler

            super.init(queue: queue)
        }

        ///
        /// Whether the app can be launched into the background to handle
        /// background behaviors.
        ///
        public var status: UIBackgroundRefreshStatus {
            return application.backgroundRefreshStatus
        }

        private let application: ApplicationProtocol
        private let handler: (Event) -> Void

        override public func addNotificationObservers() {
            super.addNotificationObservers()

            observe(.UIApplicationBackgroundRefreshStatusDidChange) { [unowned self] _ in
                self.handler(.statusDidChange(self.status))
            }
        }
    }

#endif
