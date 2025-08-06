// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS) || os(watchOS)

import Foundation

/// An `ExtensionHostMonitor` instance monitors an extension context for
/// changes to the runtime state of the extension’s host app.
public final class ExtensionHostMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the runtime state of the extension’s host app.
    public enum Event {
        /// The extension’s host app has moved from the inactive to the active
        /// state.
        case didBecomeActive(NSExtensionContext)

        /// The extension’s host app has begun running in the background.
        case didEnterBackground(NSExtensionContext)

        /// The extension’s host app is about to begin running in the
        /// foreground.
        case willEnterForeground(NSExtensionContext)

        /// The extension’s host app is about to move from the active to the
        /// inactive state.
        case willResignActive(NSExtensionContext)
    }

    /// Initializes a new `ExtensionHostMonitor`.
    /// - Parameters:
    ///   - context:    The extension context to monitor.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the runtime state of the
    ///                 extension’s host app changes.
    public init(context: NSExtensionContext,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.context = context
        self.handler = handler

        super.init(queue: queue)
    }

    /// The extension context being monitored.
    public let context: NSExtensionContext

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSExtensionHostDidBecomeActive,
                object: context) { [unowned self] in
            if let context = $0.object as? NSExtensionContext {
                self.handler(.didBecomeActive(context))
            }
        }

        observe(.NSExtensionHostDidEnterBackground,
                object: context) { [unowned self] in
            if let context = $0.object as? NSExtensionContext {
                self.handler(.didEnterBackground(context))
            }
        }

        observe(.NSExtensionHostWillEnterForeground,
                object: context) { [unowned self] in
            if let context = $0.object as? NSExtensionContext {
                self.handler(.willEnterForeground(context))
            }
        }

        observe(.NSExtensionHostWillResignActive,
                object: context) { [unowned self] in
            if let context = $0.object as? NSExtensionContext {
                self.handler(.willResignActive(context))
            }
        }
    }
}

#endif
