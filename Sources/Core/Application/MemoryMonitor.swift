//
//  MemoryMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

    import Foundation
    import UIKit

    ///
    /// A `MemoryMonitor` instance monitors the app for memory warnings from the
    /// operating system.
    ///
    public class MemoryMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates warnings received by the app from the operating system
        /// about low memory availability.
        ///
        public enum Event {
            ///
            /// The app has received a memory warning.
            ///
            case didReceiveWarning
        }

        ///
        /// Initializes a new `MemoryMonitor`.
        ///
        /// - Parameters:
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the app receives a warning
        ///                 from the operating system about low memory availability.
        ///
        public init(queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.application = ApplicationInjector.inject()
            self.handler = handler

            super.init(queue: queue)
        }

        private let application: ApplicationProtocol
        private let handler: (Event) -> Void

        override public func addNotificationObservers() {
            super.addNotificationObservers()

            observe(.UIApplicationDidReceiveMemoryWarning,
                    object: application) { [unowned self] _ in
                self.handler(.didReceiveWarning)
            }
        }
    }

#endif
