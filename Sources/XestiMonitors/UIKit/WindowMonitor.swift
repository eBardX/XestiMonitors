// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// A `WindowMonitor` instance monitors a window for changes to its
/// visibility or its key status.
public final class WindowMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the visibility and key status of the
    /// window.
    public enum Event {
        /// The window has become hidden.
        case didBecomeHidden(UIWindow)

        /// The window has become the key window.
        case didBecomeKey(UIWindow)

        /// The window has become visible.
        case didBecomeVisible(UIWindow)

        /// The window has resigned its status as key window.
        case didResignKey(UIWindow)
    }

    /// Initializes a new `WindowMonitor`.
    /// - Parameters:
    ///   - window:     The window to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the visibility or the key
    ///                 status of the window changes.
    public init(window: UIWindow,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.window = window

        super.init(queue: queue)
    }

    /// The window being monitored.
    public let window: UIWindow

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIWindow.didBecomeHiddenNotification,
                object: window) { [unowned self] in
            if let window = $0.object as? UIWindow {
                self.handler(.didBecomeHidden(window))
            }
        }

        observe(UIWindow.didBecomeKeyNotification,
                object: window) { [unowned self] in
            if let window = $0.object as? UIWindow {
                self.handler(.didBecomeKey(window))
            }
        }

        observe(UIWindow.didBecomeVisibleNotification,
                object: window) { [unowned self] in
            if let window = $0.object as? UIWindow {
                self.handler(.didBecomeVisible(window))
            }
        }

        observe(UIWindow.didResignKeyNotification,
                object: window) { [unowned self] in
            if let window = $0.object as? UIWindow {
                self.handler(.didResignKey(window))
            }
        }
    }
}

#endif
