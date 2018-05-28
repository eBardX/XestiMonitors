//
//  HTTPCookiesStorageMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-15.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// An `HTTPCookiesStorageMonitor` instance monitors an HTTP cookie storage
/// object for changes to its acceptance policy or to its cookies.
///
public class HTTPCookiesStorageMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the cookie storage.
    ///
    public enum Event {
        ///
        /// The acceptance policy of the cookie storage has changed.
        ///
        case acceptPolicyChanged(HTTPCookieStorage)

        ///
        /// The cookies stored in the cookie storage have changed.
        ///
        case cookiesChanged(HTTPCookieStorage)
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `acceptPolicyChanged` events.
        ///
        public static let acceptPolicyChanged = Options(rawValue: 1 << 0)

        ///
        /// Monitor `cookiesChanged` events.
        ///
        public static let cookiesChanged = Options(rawValue: 1 << 1)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.acceptPolicyChanged,
                                          .cookiesChanged]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `HTTPCookiesStorageMonitor`.
    ///
    /// - Parameters:
    ///   - cookieStorage:  The cookie storage to monitor.
    ///   - options:        The options that specify which events to monitor.
    ///                     By default, all events are monitored.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the acceptance policy of
    ///                     the cookie storage or the cookies stored in the
    ///                     cookie storage have changed.
    ///
    public init(cookieStorage: HTTPCookieStorage,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.cookieStorage = cookieStorage
        self.handler = handler
        self.options = options

        super.init(queue: .main)
    }

    ///
    /// The cookie storage being monitored.
    ///
    public let cookieStorage: HTTPCookieStorage

    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.acceptPolicyChanged) {
            observe(.NSHTTPCookieManagerAcceptPolicyChanged,
                    object: cookieStorage) { [unowned self] in
                        if let cookieStorage = $0.object as? HTTPCookieStorage {
                            self.handler(.acceptPolicyChanged(cookieStorage))
                        }
            }
        }

        if options.contains(.cookiesChanged) {
            observe(.NSHTTPCookieManagerCookiesChanged,
                    object: cookieStorage) { [unowned self] in
                        if let cookieStorage = $0.object as? HTTPCookieStorage {
                            self.handler(.cookiesChanged(cookieStorage))
                        }
            }
        }
    }
}
