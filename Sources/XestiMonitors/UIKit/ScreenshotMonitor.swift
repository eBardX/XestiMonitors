// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `ScreenshotMonitor` instance monitors the app for screenshots.
public final class ScreenshotMonitor: BaseNotificationMonitor {
    /// Encapsulates screenshots taken when the user presses the Home and
    /// Lock buttons.
    public enum Event {
        /// The user has taken a screenshot.
        case userDidTake
    }

    /// Initializes a new `ScreenshotMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the user presses the Home
    ///                 and Lock buttons to take a screenshot.
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

        observe(UIApplication.userDidTakeScreenshotNotification,
                object: app) { [unowned self] _ in
            self.handler(.userDidTake)
        }
    }
}

#endif
