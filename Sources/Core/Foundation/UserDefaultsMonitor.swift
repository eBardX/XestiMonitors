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
        ///  Ubiquitous defaults have finished downloading data, either the
        ///  first time a device is connected to an iCloud account
        ///  or when a user switches their primary iCloud account.
        ///
        ///
        case completedInitialCloudSync

        ///
        /// The user has changed the primary iCloud account.
        ///
        case didChangeCloudAccounts

        ///
        /// User defaults are changed within the current process
        ///

        case didChange(UserDefaults)

        ///
        /// A cloud default is set, but no iCloud user is logged in..
        ///
        case noCloudAccount

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
        /// Monitor `completedInitialCloudSync` events.
        ///
        public static let completedInitialCloudSync = Options(rawValue: 1 << 0)

        ///
        /// Monitor `didChangeCloudAccounts` events.
        ///
        public static let didChangeCloudAccounts = Options(rawValue: 1 << 1)

        ///
        /// Monitor `didChange` events.
        ///
        public static let didChange = Options(rawValue: 1 << 2)

        ///
        /// Monitor `noCloudAccount` events.
        ///
        public static let noCloudAccount = Options(rawValue: 1 << 3)

        ///
        /// Monitor `sizeLimitExceeded` events.
        ///
        public static let sizeLimitExceeded = Options(rawValue: 1 << 4)

        ///
        /// Monitor `all` events.
        ///
        public static let all: Options = [.completedInitialCloudSync,
                                          .didChangeCloudAccounts,
                                          .didChange,
                                          .noCloudAccount,
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
    }
}
