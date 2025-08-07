// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS)

import  UIKit

/// A `PasteboardMonitor` instance monitors a pasteboard for changes to its
/// contents or for its removal from the app.
public final class PasteboardMonitor: BaseNotificationMonitor {
    /// Encapsulates information associated with a pasteboard monitor
    /// `changed` event.
    public struct Changes {
        /// The representation types of items that have been added to the
        /// pasteboard.
        public let typesAdded: [String]

        /// The representation types of items that have been removed from
        /// the pasteboard.
        public let typesRemoved: [String]

        fileprivate init(_ userInfo: [AnyHashable: Any]?) {
            self.typesAdded = userInfo?[UIPasteboard.changedTypesAddedUserInfoKey] as? [String] ?? []
            self.typesRemoved = userInfo?[UIPasteboard.changedTypesRemovedUserInfoKey] as? [String] ?? []
        }
    }

    /// Encapsulates changes to the pasteboard and its contents.
    public enum Event {
        /// The contents of the pasteboard have changed.
        case changed(UIPasteboard, Changes)

        /// The pasteboard has been removed from the app.
        case removed(UIPasteboard)
    }

    /// Initializes a new `PasteboardMonitor`.
    /// - Parameters:
    ///   - pasteboard: The pasteboard to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the pasteboard is removed
    ///                 from the app, or its contents change.
    public init(pasteboard: UIPasteboard,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.pasteboard = pasteboard

        super.init(queue: queue)
    }

    /// The pasteboard being monitored.
    public let pasteboard: UIPasteboard

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIPasteboard.changedNotification,
                object: pasteboard) { [unowned self] in
            if let pasteboard = $0.object as? UIPasteboard {
                self.handler(.changed(pasteboard, Changes($0.userInfo)))
            }
        }

        observe(UIPasteboard.removedNotification,
                object: pasteboard) { [unowned self] in
            if let pasteboard = $0.object as? UIPasteboard {
                self.handler(.removed(pasteboard))
            }
        }
    }
}

#endif
