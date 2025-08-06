// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// A `UserDefaultsMonitor` instance monitors a user defaults object for
/// changes to its data.
public final class UserDefaultsMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the user defaults object.
    public enum Event {
        /// The user defaults object has been changed within the current
        /// process.
        case didChange(UserDefaults)

#if os(iOS) || os(tvOS) || os(watchOS)
        /// More data has been stored in the user defaults object than is
        /// allowed.
        case sizeLimitExceeded(UserDefaults)
#endif
    }

    /// Initializes a new `UserDefaultsMonitor`.
    /// - Parameters:
    ///   - userDefaults:   The user defaults object to monitor.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the user defaults object
    ///                     is changed within the current process.
    public init(userDefaults: UserDefaults,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.userDefaults = userDefaults

        super.init(queue: queue)
    }

    /// The user defaults object being monitored.
    public let userDefaults: UserDefaults

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UserDefaults.didChangeNotification,
                object: userDefaults) { [unowned self] in
            if let userDefaults = $0.object as? UserDefaults {
                self.handler(.didChange(userDefaults))
            }
        }

#if os(iOS) || os(tvOS) || os(watchOS)
        observe(UserDefaults.sizeLimitExceededNotification,
                object: userDefaults) { [unowned self] in
            if let userDefaults = $0.object as? UserDefaults {
                self.handler(.sizeLimitExceeded(userDefaults))
            }
        }
#endif
    }
}
