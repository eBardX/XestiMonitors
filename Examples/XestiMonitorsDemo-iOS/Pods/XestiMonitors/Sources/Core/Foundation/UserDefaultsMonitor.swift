//
//  UserDefaultsMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-04-25.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `UserDefaultsMonitor` instance monitors a user defaults object for
/// changes to its data.
///
public class UserDefaultsMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the user defaults object.
    ///
    public enum Event {
        ///
        /// The user defaults object has been changed within the current
        /// process.
        ///
        case didChange(UserDefaults)

        #if os(iOS) || os(tvOS) || os(watchOS)
        ///
        /// More data has been stored in the user defaults object than is
        /// allowed.
        ///
        case sizeLimitExceeded(UserDefaults)
        #endif
    }

    #if os(iOS) || os(tvOS) || os(watchOS)
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
    #endif

    #if os(iOS) || os(tvOS) || os(watchOS)
    ///
    /// Initializes a new `UserDefaultsMonitor`.
    ///
    /// - Parameters:
    ///   - userDefaults:   The user defaults object to monitor.
    ///   - options:        The options that specify which events to monitor.
    ///                     By default, all events are monitored.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the user defaults object
    ///                     is changed within the current process or more data
    ///                     is stored in the object than is allowed.
    ///
    public init(userDefaults: UserDefaults,
                options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.options = options
        self.handler = handler
        self.userDefaults = userDefaults

        super.init(queue: queue)
    }
    #else
    ///
    /// Initializes a new `UserDefaultsMonitor`.
    ///
    /// - Parameters:
    ///   - userDefaults:   The user defaults object to monitor.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the user defaults object
    ///                     is changed within the current process.
    ///
    public init(userDefaults: UserDefaults,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.userDefaults = userDefaults

        super.init(queue: queue)
    }
    #endif

    ///
    /// The user defaults object being monitored.
    ///
    public let userDefaults: UserDefaults

    private let handler: (Event) -> Void
    #if os(iOS) || os(tvOS) || os(watchOS)
    private let options: Options
    #endif

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        #if os(iOS) || os(tvOS) || os(watchOS)
        if options.contains(.didChange) {
            observe(UserDefaults.didChangeNotification,
                    object: userDefaults) { [unowned self] in
                        if let userDefaults = $0.object as? UserDefaults {
                            self.handler(.didChange(userDefaults))
                        }
            }
        }

        if options.contains(.sizeLimitExceeded),
            #available(iOS 9.3, *) {
            observe(UserDefaults.sizeLimitExceededNotification,
                    object: userDefaults) { [unowned self] in
                        if let userDefaults = $0.object as? UserDefaults {
                            self.handler(.sizeLimitExceeded(userDefaults))
                        }
            }
        }
        #else
        observe(UserDefaults.didChangeNotification,
                object: userDefaults) { [unowned self] in
                    if let userDefaults = $0.object as? UserDefaults {
                        self.handler(.didChange(userDefaults))
                    }
        }
        #endif
    }
}
