// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `ProtectedDataMonitor` instance monitors the app for changes to the
/// accessibility of protected files.
public final class ProtectedDataMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the accessibility of protected files.
    public enum Event {
        /// Protected files have become available for your code to access.
        case didBecomeAvailable

        /// Protected files are about to be locked down and become
        /// inaccessible.
        case willBecomeUnavailable
    }

    /// Initializes a new `ProtectedDataMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly
    ///                 before protected files are locked down and become
    ///                 inaccessible.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.app = AppInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    /// A Boolean value indicating whether content is accessible for
    /// protected files.
    public var isContentAccessible: Bool {
        app.isProtectedDataAvailable
    }

    private let app: any AppProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIApplication.protectedDataDidBecomeAvailableNotification,
                object: app) { [unowned self] _ in
            self.handler(.didBecomeAvailable)
        }

        observe(UIApplication.protectedDataWillBecomeUnavailableNotification,
                object: app) { [unowned self] _ in
            self.handler(.willBecomeUnavailable)
        }
    }
}

#endif
