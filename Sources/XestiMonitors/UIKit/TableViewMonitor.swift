// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

/// A `TableViewMonitor` instance monitors a table view for changes.
public final class TableViewMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the table view.
    public enum Event {
        /// The selected row of the table view has changed.
        case selectionDidChange(UITableView)
    }

    /// Initializes a new `TableViewMonitor`.
    /// - Parameters:
    ///   - tableView:  The table view to monitor.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the selected row in the table
    ///                 view changes.
    public init(tableView: UITableView,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.tableView = tableView

        super.init(queue: queue)
    }

    /// The table view being monitored.
    public let tableView: UITableView

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UITableView.selectionDidChangeNotification,
                object: tableView) { [unowned self] in
            if let tableView = $0.object as? UITableView {
                self.handler(.selectionDidChange(tableView))
            }
        }
    }
}

#endif
