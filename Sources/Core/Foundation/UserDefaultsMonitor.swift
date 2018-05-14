//
//  UserDefaultsMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-25.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

public class UserDefaultsMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the data stored in User Defaults.
    ///
    public enum Event {
        ///
        /// User defaults are changed within the current process
        ///
        case didChange(UserDefaults)

        ///
        /// More data is stored in user defaults than is allowed.
        ///
        case sizeLimitExceeded
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didChange` events.
        ///
        public static let didChange = Options(rawValue: 1 << 0)

        ///
        /// Monitor `sizeLimitExceeded` events.
        ///
        public static let sizeLimitExceeded = Options(rawValue: 1 << 1)

        ///
        /// Monitor `all` events.
        ///
        public static let all: Options = [.didChange,
                                          .sizeLimitExceeded]
        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `UserDefaultsMonitor`.
    ///
    /// - Parameters:
    ///   - options:    The options that specify which events to monitor. By
    ///                 default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the current focus is updated
    ///                 or cannot be moved in the selected direction.
    ///
    public init(options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.options = options
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didChange) {
            observe(UserDefaults.didChangeNotification) { [unowned self] in
                if let userDefaults = $0.object as? UserDefaults {
                    self.handler(.didChange(userDefaults))
                }
            }
        }
        #if os(tvOS)
        if options.contains(.sizeLimitExceeded) {
            if #available(tvOS 9.0, *) {
                observe(UserDefaults.sizeLimitExceededNotification) { [unowned self] _ in
                    self.handler(.sizeLimitExceeded)
                }
            }
        }
        #endif
    }
}
