//
//  WindowMonitor.swift
//  XestiMonitors
//
//  Created by Martin Mungai on 2018-03-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `WindowMonitor` instance monitors a window for changes to its
/// visibility or its key status.
///
public class WindowMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the visibility and key status of the
    /// window.
    ///
    public enum Event {
        ///
        /// The window has become hidden.
        ///
        case didBecomeHidden(UIWindow)

        ///
        /// The window has become the key window.
        ///
        case didBecomeKey(UIWindow)

        ///
        /// The window has become visible.
        ///
        case didBecomeVisible(UIWindow)

        ///
        /// The window has resigned its status as key window.
        ///
        case didResignKey(UIWindow)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didBecomeHidden` events
        ///
        public static let didBecomeHidden = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didBecomeKey` events
        ///
        public static let didBecomeKey = Options(rawValue: 1 << 1)

        ///
        /// Monitor `didBecomeVisible` events
        ///
        public static let didBecomeVisible = Options(rawValue: 1 << 2)

        ///
        /// Monitor `didResignKey` events
        ///
        public static let didResignKey = Options(rawValue: 1 << 3)

        ///
        /// Monitor all events
        ///
        public static let all: Options = [.didBecomeHidden,
                                          .didBecomeKey,
                                          .didBecomeVisible,
                                          .didResignKey]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `WindowMonitor`.
    ///
    /// - Parameters:
    ///   - window:     The window to monitor.
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the visibility or the key
    ///                 status of the window changes.
    ///
    public init(window: UIWindow,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.window = window

        super.init(queue: queue)
    }

    ///
    /// The window being monitored.
    ///
    public let window: UIWindow

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeHidden) {
            observe(.UIWindowDidBecomeHidden,
                    object: window) { [unowned self] in
                        if let window = $0.object as? UIWindow {
                            self.handler(.didBecomeHidden(window))
                        }
            }
        }

        if options.contains(.didBecomeKey) {
            observe(.UIWindowDidBecomeKey,
                    object: window) { [unowned self] in
                        if let window = $0.object as? UIWindow {
                            self.handler(.didBecomeKey(window))
                        }
            }
        }

        if options.contains(.didBecomeVisible) {
            observe(.UIWindowDidBecomeVisible,
                    object: window) { [unowned self] in
                        if let window = $0.object as? UIWindow {
                            self.handler(.didBecomeVisible(window))
                        }
            }
        }

        if options.contains(.didResignKey) {
            observe(.UIWindowDidResignKey,
                    object: window) { [unowned self] in
                        if let window = $0.object as? UIWindow {
                            self.handler(.didResignKey(window))
                        }
            }
        }
    }
}

#endif
