// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

/// An `HTTPCookiesStorageMonitor` instance monitors an HTTP cookie storage
/// object for changes to its acceptance policy or to its cookies.
public final class HTTPCookiesStorageMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the cookie storage.
    public enum Event {
        /// The acceptance policy of the cookie storage has changed.
        case acceptPolicyChanged(HTTPCookieStorage)

        /// The cookies stored in the cookie storage have changed.
        case cookiesChanged(HTTPCookieStorage)
    }

    /// Initializes a new `HTTPCookiesStorageMonitor`.
    /// - Parameters:
    ///   - cookieStorage:  The cookie storage to monitor.
    ///   - queue:          The operation queue on which the handler executes.
    ///                     By default, the main operation queue is used.
    ///   - handler:        The handler to call when the acceptance policy of
    ///                     the cookie storage or the cookies stored in the
    ///                     cookie storage have changed.
    public init(cookieStorage: HTTPCookieStorage,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.cookieStorage = cookieStorage
        self.handler = handler

        super.init(queue: queue)
    }

    /// The cookie storage being monitored.
    public let cookieStorage: HTTPCookieStorage

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSHTTPCookieManagerAcceptPolicyChanged,
                object: cookieStorage) { [unowned self] in
            if let cookieStorage = $0.object as? HTTPCookieStorage {
                self.handler(.acceptPolicyChanged(cookieStorage))
            }
        }

        observe(.NSHTTPCookieManagerCookiesChanged,
                object: cookieStorage) { [unowned self] in
            if let cookieStorage = $0.object as? HTTPCookieStorage {
                self.handler(.cookiesChanged(cookieStorage))
            }
        }
    }
}
