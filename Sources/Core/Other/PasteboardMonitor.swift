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
    /// its state.
    ///
    public class PasteboardMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes to the contents of the pasteboard.
        ///
        public enum Event {
            ///
            ///  Contents of the pasteboard object have changed.
            ///
            case changed(Info)

            ///
            ///  Contents of the pasteboard object have been removed.
            ///
            case removed(UIPasteboard)
        }

        ///
        /// Encapsulates information associated with a pasteboard monitor
        /// event.
        ///
        public struct Info {
            ///
            ///
            ///
            public let pasteboard: UIPasteboard

            ///
            /// The added representation types stored as an array
            /// in the notification’s userInfo dictionary
            ///
            public let typesAdded: [String]

            ///
            /// The removed representation types stored as an array
            /// in the notification’s userInfo dictionary
            ///
            public let typesRemoved: [String]

            fileprivate init?(_ notification: Notification) {
                guard
                    let pasteboard = notification.object as? UIPasteboard
                    else { return nil }

                let userInfo = notification.userInfo

                self.pasteboard = pasteboard
                self.typesAdded = userInfo?[UIPasteboardChangedTypesAddedKey] as? [String] ?? []
                self.typesRemoved = userInfo?[UIPasteboardChangedTypesRemovedKey] as? [String] ?? []
            }
        }

        ///
        /// Specifies which events to monitor.
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `didChange` events.
            ///
            public static let changed = Options(rawValue: 1 << 0)

            ///
            /// Monitor `didRemove` events.
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
        ///   - options:    The options that specify which events to monitor. By default
        ///                 all events are monitored
        ///   - queue:      The operation queue on which the handler executes. By
        ///                 default, the main operation queue is used.
        ///   - handler:    The handler to call when the state of the document
        ///                 changes.
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
                            if let info = Info($0) {
                                self.handler(.changed(info))
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
