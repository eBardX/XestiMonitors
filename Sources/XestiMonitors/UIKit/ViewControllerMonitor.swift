// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

/// A `ViewControllerMonitor` instance monitors a split view controller for changes.
public final class ViewControllerMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to a view controller.
    public enum Event {
        /// A split view controller has been expanded or collapsed. The
        /// associated value is the view controller that caused the change.
        case showDetailTargetDidChange(UIViewController)
    }

    /// Initializes a new `ViewControllerMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when a split view controller is
    ///                 expanded or collapsed.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIViewController.showDetailTargetDidChangeNotification) { [unowned self] in
            if let vc = $0.object as? UIViewController {
                self.handler(.showDetailTargetDidChange(vc))
            }
        }
    }
}

#endif
