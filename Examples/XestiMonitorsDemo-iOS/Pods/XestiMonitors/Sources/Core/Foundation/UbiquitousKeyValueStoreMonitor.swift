//
//  UbiquitousKeyValueStoreMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-03-12.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(macOS) || os(tvOS)

import Foundation

///
/// A `UbiquitousKeyValueStoreMonitor` instance monitors the iCloud
/// (“ubiquitous”) key-value store for changes due to incoming data pushed
/// from iCloud.
///
public class UbiquitousKeyValueStoreMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the iCloud key-value store.
    ///
    public enum Event {
        ///
        /// The user has changed the primary iCloud account. The keys and
        /// values in the local key-value store have been replaced with
        /// those from the new account, regardless of the relative
        /// timestamps.
        ///
        case accountChange([String])

        ///
        /// Your attempt to write to key-value storage was discarded
        /// because an initial download from iCloud has not yet happened.
        ///
        case initialSyncChange([String])

        ///
        /// Your app’s key-value store has exceeded its space quota on the
        /// iCloud server.
        ///
        case quotaViolationChange([String])

        ///
        /// One or more values changed in iCloud. The associated value is
        /// an array of key names that changed in the key-value store.
        ///
        case serverChange([String])
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `accountChange` events.
        ///
        public static let accountChange = Options(rawValue: 1 << 0)

        ///
        /// Monitor `initialSyncChange` events.
        ///
        public static let initialSyncChange = Options(rawValue: 1 << 1)

        ///
        /// Monitor `quotaViolationChange` events.
        ///
        public static let quotaViolationChange = Options(rawValue: 1 << 2)

        ///
        /// Monitor `serverChange` events.
        ///
        public static let serverChange = Options(rawValue: 1 << 3)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.accountChange,
                                          .initialSyncChange,
                                          .quotaViolationChange,
                                          .serverChange]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `UbiquitousKeyValueStoreMonitor`.
    ///
    /// - Parameters:
    ///   - options:    The options that specify which events to monitor.
    ///                 By default, all events are monitored.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the iCloud key-value store
    ///                 changes.
    ///
    public init(options: Options = .all,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.keyValueStore = .`default`
        self.options = options

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void
    private let keyValueStore: NSUbiquitousKeyValueStore
    private let options: Options

    private func invokeHandler(_ notification: Notification) {
        let userInfo = notification.userInfo

        guard
            let changeReason = userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int
            else { return }

        let changedKeys = userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] ?? []

        switch changeReason {
        case NSUbiquitousKeyValueStoreAccountChange
            where options.contains(.accountChange):
            handler(.accountChange(changedKeys))

        case NSUbiquitousKeyValueStoreInitialSyncChange
            where options.contains(.initialSyncChange):
            handler(.initialSyncChange(changedKeys))

        case NSUbiquitousKeyValueStoreQuotaViolationChange
            where options.contains(.quotaViolationChange):
            handler(.quotaViolationChange(changedKeys))

        case NSUbiquitousKeyValueStoreServerChange
            where options.contains(.serverChange):
            handler(.serverChange(changedKeys))

        default:
            break
        }
    }

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: keyValueStore) { [unowned self] in
                    self.invokeHandler($0)
        }
    }
}

#endif
