//
//  ExtensionHostMonitor.swift
//  XestiMonitors
//
//  Created by Rose Maina on 2018-05-16.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// An `ExtensionHostMonitor` instance monitors the host app context
/// from which an app extension is invoked.
///
public class ExtensionHostMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the extension host.
    ///
    public enum Event {
        ///
        /// The extension host has moved from an inactive to active state.
        ///
        case didBecomeActive(NSExtensionContext)

        ///
        /// The extension host begins to run in the background.
        ///
        case didEnterBackground(NSExtensionContext)

        ///
        /// The extension host begins to run in the foreground.
        ///
        case willEnterForeground(NSExtensionContext)

        ///
        /// The extension host has moved from an active to inactive state.
        ///
        case willResignActive(NSExtensionContext)
    }

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
    ///   - extensionHost:    The host app to monitor.
    ///   - options:        The options that specify which events to monitor.
    ///                     By default, all events are monitored.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the host app sends a request
    ///                     to an app extension
    ///
    public init(extensionHost: NSExtensionContext,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.options = options
        self.extensionHost = extensionHost

        super.init(queue: queue)
    }

    ///
    /// The extension host is being monitored.
    ///
    public let extensionHost: NSExtensionContext

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeActive) {
            observe(.NSExtensionHostDidBecomeActive,
                    object: extensionHost) { [unowned self] in
                        if let extensionHost = $0.object as? NSExtensionContext {
                            self.handler(.didBecomeActive(extensionHost))
                        }
            }
        }

        if options.contains(.didEnterBackground) {
            observe(.NSExtensionHostDidEnterBackground,
                    object: extensionHost) { [unowned self] in
                        if let extensionHost = $0.object as? NSExtensionContext {
                            self.handler(.didEnterBackground(extensionHost))
                        }
            }
        }

        if options.contains(.willEnterForeground) {
            observe(.NSExtensionHostWillEnterForeground,
                    object: extensionHost) { [unowned self] in
                        if let extensionHost = $0.object as? NSExtensionContext {
                            self.handler(.willEnterForeground(extensionHost))
                        }
            }
        }

        if options.contains(.willResignActive) {
            observe(.NSExtensionHostWillResignActive,
                    object: extensionHost) { [unowned self] in
                        if let extensionHost = $0.object as? NSExtensionContext {
                            self.handler(.willResignActive(extensionHost))
                        }
            }
        }
    }
}
