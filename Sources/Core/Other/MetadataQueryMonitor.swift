//
//  MetadataQueryMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-02-23.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `MetadataQueryMonitor` instance monitors a metadata query for changes to
/// its results.
///
public class MetadataQueryMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the results of the metadata query.
    ///
    public enum Event {
        ///
        /// The metadata query has finished its initial result-gathering phase.
        ///
        case didFinishGathering(Info)

        ///
        /// The metadata query has started its initial result-gathering phase.
        ///
        case didStartGathering(Info)

        ///
        /// The metadata query’s results have changed during its live-update
        /// phase.
        ///
        case didUpdate(Info)

        ///
        /// The metadata query is collecting results during its initial
        /// result-gathering phase.
        ///
        case gatheringProgress(Info)
    }

    ///
    /// Encapsulates information associated with a metadata query monitor
    /// event.
    ///
    public struct Info {
        ///
        /// An array of items added to the query result. By default, this array
        /// contains `NSMetadataItem` objects, representing the query’s
        /// results; however, the query’s delegate can substitute these objects
        /// with instances of a different class.
        ///
        public let addedItems: [Any]

        ///
        /// An array of items that have changed in the query result. By
        /// default, this array contains `NSMetadataItem` objects, representing
        /// the query’s results; however, the query’s delegate can substitute
        /// these objects with instances of a different class.
        ///
        public let changedItems: [Any]

        ///
        /// The metadata query that generated these results.
        ///
        public let query: NSMetadataQuery

        ///
        /// An array of items removed from the query result. By default, this
        /// array contains `NSMetadataItem` objects, representing the query’s
        /// results; however, the query’s delegate can substitute these objects
        /// with instances of a different class.
        ///
        public let removedItems: [Any]

        fileprivate init?(_ notification: Notification) {
            guard
                let query = notification.object as? NSMetadataQuery
                else { return nil }

            let userInfo = notification.userInfo

            self.addedItems = userInfo?[NSMetadataQueryUpdateAddedItemsKey] as? [Any] ?? []
            self.changedItems = userInfo?[NSMetadataQueryUpdateChangedItemsKey] as? [Any] ?? []
            self.query = query
            self.removedItems = userInfo?[NSMetadataQueryUpdateRemovedItemsKey] as? [Any] ?? []
        }
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didFinishGathering` events.
        ///
        public static let didFinishGathering = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didStartGathering` events.
        ///
        public static let didStartGathering = Options(rawValue: 1 << 1)

        ///
        /// Monitor `didUpdate` events.
        ///
        public static let didUpdate = Options(rawValue: 1 << 2)

        ///
        /// Monitor `gatheringProgress` events.
        ///
        public static let gatheringProgress = Options(rawValue: 1 << 3)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didFinishGathering,
                                          .didStartGathering,
                                          .didUpdate,
                                          .gatheringProgress]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `MetadataQueryMonitor`.
    ///
    /// - Parameters:
    ///   - query:      The metadata query to monitor.
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the results of the metadata
    ///                 query change.
    ///
    public init(query: NSMetadataQuery,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.query = query

        super.init(queue: queue)
    }

    ///
    /// The metadata query being monitored.
    ///
    public let query: NSMetadataQuery

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didFinishGathering) {
            observe(.NSMetadataQueryDidFinishGathering,
                    object: query) { [unowned self] in
                        if let info = Info($0) {
                            self.handler(.didFinishGathering(info))
                        }
            }
        }

        if options.contains(.didStartGathering) {
            observe(.NSMetadataQueryDidStartGathering,
                    object: query) { [unowned self] in
                        if let info = Info($0) {
                            self.handler(.didStartGathering(info))
                        }
            }
        }

        if options.contains(.didUpdate) {
            observe(.NSMetadataQueryDidUpdate,
                    object: query) { [unowned self] in
                        if let info = Info($0) {
                            self.handler(.didUpdate(info))
                        }
            }
        }

        if options.contains(.gatheringProgress) {
            observe(.NSMetadataQueryGatheringProgress,
                    object: query) { [unowned self] in
                        if let info = Info($0) {
                            self.handler(.gatheringProgress(info))
                        }
            }
        }
    }
}
