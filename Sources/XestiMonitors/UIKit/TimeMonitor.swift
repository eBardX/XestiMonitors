// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `TimeMonitor` instance monitors the app for significant changes in
/// time.
public final class TimeMonitor: BaseNotificationMonitor {
    /// Encapsulates significant changes in time.
    public enum Event {
        /// There has been a significant change in time.
        case significantChange
    }

    /// Initializes a new `TimeMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when there is a significant
    ///                 change in time.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.app = AppInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    private let app: any AppProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIApplication.significantTimeChangeNotification,
                object: app) { [unowned self] _ in
            self.handler(.significantChange)
        }
    }
}

#endif
