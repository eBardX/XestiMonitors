// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// A `MetadataQueryMonitor` instance monitors a metadata query for changes to
/// its results.
public final class MetadataQueryMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the results of the metadata query.
    public enum Event {
        /// The metadata query has finished its initial result-gathering phase.
        case didFinishGathering(Info)

        /// The metadata query has started its initial result-gathering phase.
        case didStartGathering(Info)

        /// The metadata query’s results have changed during its live-update
        /// phase.
        case didUpdate(Info)

        /// The metadata query is collecting results during its initial
        /// result-gathering phase.
        case gatheringProgress(Info)
    }

    /// Encapsulates information associated with a metadata query monitor
    /// event.
    public struct Info {
        /// An array of items added to the query result. By default, this array
        /// contains `NSMetadataItem` objects, representing the query’s
        /// results; however, the query’s delegate can substitute these objects
        /// with instances of a different class.
        public let addedItems: [Any]

        /// An array of items that have changed in the query result. By
        /// default, this array contains `NSMetadataItem` objects, representing
        /// the query’s results; however, the query’s delegate can substitute
        /// these objects with instances of a different class.
        public let changedItems: [Any]

        /// The metadata query that generated these results.
        public let query: NSMetadataQuery

        /// An array of items removed from the query result. By default, this
        /// array contains `NSMetadataItem` objects, representing the query’s
        /// results; however, the query’s delegate can substitute these objects
        /// with instances of a different class.
        public let removedItems: [Any]

        fileprivate init?(_ notification: Notification) {
            guard let query = notification.object as? NSMetadataQuery
            else { return nil }

            let userInfo = notification.userInfo

            self.addedItems = userInfo?[NSMetadataQueryUpdateAddedItemsKey] as? [Any] ?? []
            self.changedItems = userInfo?[NSMetadataQueryUpdateChangedItemsKey] as? [Any] ?? []
            self.query = query
            self.removedItems = userInfo?[NSMetadataQueryUpdateRemovedItemsKey] as? [Any] ?? []
        }
    }

    /// Initializes a new `MetadataQueryMonitor`.
    /// - Parameters:
    ///   - query:      The metadata query to monitor.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the results of the metadata
    ///                 query change.
    public init(query: NSMetadataQuery,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.query = query

        super.init(queue: queue)
    }

    /// The metadata query being monitored.
    public let query: NSMetadataQuery

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSMetadataQueryDidFinishGathering,
                object: query) { [unowned self] in
            if let info = Info($0) {
                self.handler(.didFinishGathering(info))
            }
        }

        observe(.NSMetadataQueryDidStartGathering,
                object: query) { [unowned self] in
            if let info = Info($0) {
                self.handler(.didStartGathering(info))
            }
        }

        observe(.NSMetadataQueryDidUpdate,
                object: query) { [unowned self] in
            if let info = Info($0) {
                self.handler(.didUpdate(info))
            }
        }

        observe(.NSMetadataQueryGatheringProgress,
                object: query) { [unowned self] in
            if let info = Info($0) {
                self.handler(.gatheringProgress(info))
            }
        }
    }
}
