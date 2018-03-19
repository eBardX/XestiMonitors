//
//  PasteboardMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-03-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS)

    import  UIKit

    ///
    /// A `PasteboardMonitor` instance monitors a pasteboard for changes to
    /// its contents or for its removal from the app.
    ///
    public class PasteboardMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates information associated with a pasteboard monitor
        /// `changed` event.
        ///
        public struct Changes {
            ///
            /// The representation types of items that have been added to the
            /// pasteboard.
            ///
            public let typesAdded: [String]

            ///
            /// The representation types of items that have been removed from
            /// the pasteboard.
            ///
            public let typesRemoved: [String]

            fileprivate init(_ userInfo: [AnyHashable: Any]?) {
                self.typesAdded = userInfo?[UIPasteboardChangedTypesAddedKey] as? [String] ?? []
                self.typesRemoved = userInfo?[UIPasteboardChangedTypesRemovedKey] as? [String] ?? []
            }
        }

        ///
        /// Encapsulates changes to the pasteboard and its contents.
        ///
        public enum Event {
            ///
            /// The contents of the pasteboard have changed.
            ///
            case changed(UIPasteboard, Changes)

            ///
            /// The pasteboard has been removed from the app.
            ///
            case removed(UIPasteboard)
        }

        ///
        /// Specifies which events to monitor.
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `changed` events.
            ///
            public static let changed = Options(rawValue: 1 << 0)

            ///
            /// Monitor `removed` events.
            ///
            public static let removed = Options(rawValue: 1 << 1)

            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.changed,
                                              .removed]

            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }

            /// :nodoc:
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `PasteboardMonitor`.
        ///
        /// - Parameters:
        ///   - pasteboard: The pasteboard to monitor.
        ///   - options:    The options that specify which events to monitor.
        ///                 By default all events are monitored
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - handler:    The handler to call when the pasteboard is removed
        ///                 from the app, or its contents change.
        ///
        public init(pasteboard: UIPasteboard,
                    options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping(Event) -> Void) {
            self.handler = handler
            self.options = options
            self.pasteboard = pasteboard

            super.init(queue: queue)
        }

        ///
        /// The pasteboard being monitored.
        ///
        public let pasteboard: UIPasteboard

        private let handler: (Event) -> Void
        private let options: Options

        override public func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.changed) {
                observe(.UIPasteboardChanged,
                        object: pasteboard) { [unowned self] in
                            if let pasteboard = $0.object as? UIPasteboard {
                                self.handler(.changed(pasteboard, Changes($0.userInfo)))
                            }
                }
            }

            if options.contains(.removed) {
                observe(.UIPasteboardRemoved,
                        object: pasteboard) { [unowned self] in
                            if let pasteboard = $0.object as? UIPasteboard {
                                self.handler(.removed(pasteboard))
                            }
                }
            }
        }
    }

#endif
