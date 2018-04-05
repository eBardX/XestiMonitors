//
//  ProtectedDataMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `ProtectedDataMonitor` instance monitors the app for changes to the
/// accessibility of protected files.
///
public class ProtectedDataMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the accessibility of protected files.
    ///
    public enum Event {
        ///
        /// Protected files have become available for your code to access.
        ///
        case didBecomeAvailable

        ///
        /// Protected files are about to be locked down and become
        /// inaccessible.
        ///
        case willBecomeUnavailable
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didBecomeAvailable` events.
        ///
        public static let didBecomeAvailable = Options(rawValue: 1 << 0)

        ///
        /// Monitor `willBecomeUnavailable` events.
        ///
        public static let willBecomeUnavailable = Options(rawValue: 1 << 1)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didBecomeAvailable,
                                          .willBecomeUnavailable]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly
    ///                 before protected files are locked down and become
    ///                 inaccessible.
    ///
    public init(options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.application = ApplicationInjector.inject()
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

    ///
    /// A Boolean value indicating whether content is accessible for
    /// protected files.
    ///
    public var isContentAccessible: Bool {
        return application.isProtectedDataAvailable
    }

    private let application: ApplicationProtocol
    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeAvailable) {
            observe(.UIApplicationProtectedDataDidBecomeAvailable,
                    object: application) { [unowned self] _ in
                        self.handler(.didBecomeAvailable)
            }
        }

        if options.contains(.willBecomeUnavailable) {
            observe(.UIApplicationProtectedDataWillBecomeUnavailable,
                    object: application) { [unowned self] _ in
                        self.handler(.willBecomeUnavailable)
            }
        }
    }

    // MARK: Deprecated

    ///
    /// Initializes a new `ProtectedDataMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - handler:    The handler to call when protected files become
    ///                 available for your code to access, or shortly
    ///                 before protected files are locked down and become
    ///                 inaccessible.
    ///
    /// - Warning:  Deprecated. Use `init(options:queue:handler)` instead.
    ///
    @available(*, deprecated, message: "Use `init(options:queue:handler)` instead.")
    public init(queue: OperationQueue = .main,
                options: Options = .all,
                handler: @escaping (Event) -> Void) {
        self.application = ApplicationInjector.inject()
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }
}

#endif
