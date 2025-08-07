// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(macOS) || os(tvOS)

import Foundation

/// An `ICloudKeyValueStoreMonitor` instance monitors the iCloud
/// key-value store for changes due to incoming data pushed from iCloud.
public final class ICloudKeyValueStoreMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    /// Initializes a new `ICloudKeyValueStoreMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the iCloud key-value store
    ///                 changes.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.keyValueStore = .default

        super.init(queue: queue)
    }

    // MARK: Private Instance Properties

    private let handler: (Event) -> Void
    private let keyValueStore: NSUbiquitousKeyValueStore    // should be injected ???

    // MARK: Overridden Public Instance Methods

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: keyValueStore) { [unowned self] in
            self._invokeHandler($0)
        }
    }
}

// MARK: -

extension ICloudKeyValueStoreMonitor {

    // MARK: Public Nested Types

    /// Encapsulates changes to the iCloud key-value store.
    public enum Event {
        /// The user has changed the primary iCloud account. The keys and
        /// values in the local key-value store have been replaced with
        /// those from the new account, regardless of the relative
        /// timestamps.
        case accountChange([String])

        /// Your attempt to write to key-value storage was discarded
        /// because an initial download from iCloud has not yet happened.
        case initialSyncChange([String])

        /// Your app’s key-value store has exceeded its space quota on the
        /// iCloud server.
        case quotaViolationChange([String])

        /// One or more values changed in iCloud. The associated value is
        /// an array of key names that changed in the key-value store.
        case serverChange([String])
    }

    // MARK: Private Instance Methods

    private func _invokeHandler(_ notification: Notification) {
        let userInfo = notification.userInfo

        guard let changeReason = userInfo?[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int
        else { return }

        let changedKeys = userInfo?[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] ?? []

        switch changeReason {
        case NSUbiquitousKeyValueStoreAccountChange:
            handler(.accountChange(changedKeys))

        case NSUbiquitousKeyValueStoreInitialSyncChange:
            handler(.initialSyncChange(changedKeys))

        case NSUbiquitousKeyValueStoreQuotaViolationChange:
            handler(.quotaViolationChange(changedKeys))

        case NSUbiquitousKeyValueStoreServerChange:
            handler(.serverChange(changedKeys))

        default:
            break
        }
    }
}

#endif
