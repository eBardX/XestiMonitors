//
//  ExtensionHostMonitor.swift
//  XestiMonitors
//
//  Created by Rose Maina on 2018-05-16.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS) || os(watchOS)

import Foundation

///
/// An `ExtensionHostMonitor` instance monitors an extension context for
/// changes to the runtime state of the extension’s host app.
///
public class ExtensionHostMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the runtime state of the extension’s host app.
    ///
    public enum Event {
        ///
        /// The extension’s host app has moved from the inactive to the active
        /// state.
        ///
        case didBecomeActive(NSExtensionContext)

        ///
        /// The extension’s host app has begun running in the background.
        ///
        case didEnterBackground(NSExtensionContext)

        ///
        /// The extension’s host app is about to begin running in the
        /// foreground.
        ///
        case willEnterForeground(NSExtensionContext)

        ///
        /// The extension’s host app is about to move from the active to the
        /// inactive state.
        ///
        case willResignActive(NSExtensionContext)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didBecomeActive` events.
        ///
        public static let didBecomeActive = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didEnterBackground` events.
        ///
        public static let didEnterBackground = Options(rawValue: 1 << 1)

        ///
        /// Monitor `willEnterForeground` events.
        ///
        public static let willEnterForeground = Options(rawValue: 1 << 2)

        ///
        /// Monitor `willResignActive` events.
        ///
        public static let willResignActive = Options(rawValue: 1 << 3)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didBecomeActive,
                                          .didEnterBackground,
                                          .willEnterForeground,
                                          .willResignActive]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `ExtensionHostMonitor`.
    ///
    /// - Parameters:
    ///   - context:    The extension context to monitor.
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the runtime state of the
    ///                 extension’s host app changes.
    ///
    public init(context: NSExtensionContext,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.context = context
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

    ///
    /// The extension context being monitored.
    ///
    public let context: NSExtensionContext

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeActive) {
            observe(.NSExtensionHostDidBecomeActive,
                    object: context) { [unowned self] in
                        if let context = $0.object as? NSExtensionContext {
                            self.handler(.didBecomeActive(context))
                        }
            }
        }

        if options.contains(.didEnterBackground) {
            observe(.NSExtensionHostDidEnterBackground,
                    object: context) { [unowned self] in
                        if let context = $0.object as? NSExtensionContext {
                            self.handler(.didEnterBackground(context))
                        }
            }
        }

        if options.contains(.willEnterForeground) {
            observe(.NSExtensionHostWillEnterForeground,
                    object: context) { [unowned self] in
                        if let context = $0.object as? NSExtensionContext {
                            self.handler(.willEnterForeground(context))
                        }
            }
        }

        if options.contains(.willResignActive) {
            observe(.NSExtensionHostWillResignActive,
                    object: context) { [unowned self] in
                        if let context = $0.object as? NSExtensionContext {
                            self.handler(.willResignActive(context))
                        }
            }
        }
    }
}

#endif
