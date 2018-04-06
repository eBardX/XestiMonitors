//
//  ScreenConnectionMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-04.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

    import UIKit

    ///
    /// A `ScreenConnectionMonitor` instance monitors a device for when a new
    /// screen is connected or disconnected
    ///
    public class ScreenConnectionMonitor: BaseNotificationMonitor {
        ///
        /// Encapsulates changes when a user connects or disconnects
        /// a screen
        ///
        public enum Event {
            ///
            /// A new screen is connected to the device.
            ///
            case didConnect(UIScreen)
            ///
            /// The screen is disconnected from the device.
            ///
            case didDisconnect(UIScreen)
        }

        ///
        /// Specifies which events to monitor.
        ///
        public struct Options: OptionSet {
            ///
            /// Monitor `didConnect` events.
            ///
            public static let didConnect = Options(rawValue: 1 << 0)
            ///
            /// Monitor `didDisconnect` events.
            ///
            public static let didDisconnect = Options(rawValue: 1 << 1)
            ///
            /// Monitor all events.
            ///
            public static let all: Options = [.didConnect,
                                              .didDisconnect]
            /// :nodoc:
            public init(rawValue: UInt) {
                self.rawValue = rawValue
            }

            /// :nodoc:
            public let rawValue: UInt
        }

        ///
        /// Initializes a new `ScreenConnectionMonitor`.
        ///
        /// - Parameters:
        ///   - screen:     The screen to monitor.
        ///   - options:    The options that specify which events to monitor.
        ///   - queue:      The operation queue on which the handler executes.
        ///                 By default, the main operation queue is used.
        ///   - handler:    The handler to call when the user connects or
        ///                 disconnects a screen.
        ///
        public init(screen: UIScreen,
                    options: Options = .all,
                    queue: OperationQueue = .main,
                    handler: @escaping (Event) -> Void) {
            self.screen = screen
            self.handler = handler
            self.options = options

            super.init(queue: queue)
        }

        ///
        /// The screen being monitored.
        ///
        public let screen: UIScreen

        private let handler: (Event) -> Void

        private let options: Options

        public override func addNotificationObservers() {
            super.addNotificationObservers()

            if options.contains(.didConnect) {
                observe(.UIScreenDidConnect) { [unowned self] in
                    if let screen = $0.object as? UIScreen {
                         self.handler(.didConnect(screen))
                    }
                }
            }

            if options.contains(.didDisconnect) {
                observe(.UIScreenDidDisconnect) { [unowned self] in
                    if let screen = $0.object as? UIScreen {
                        self.handler(.didDisconnect(screen))
                    }
                }
            }
        }
    }

#endif
