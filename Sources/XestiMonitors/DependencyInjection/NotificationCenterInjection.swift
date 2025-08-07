// © 2018–2025 John Gary Pusey (see LICENSE.md)

import Foundation

internal protocol NotificationCenterProtocol {
    func addObserver(forName name: NSNotification.Name?,
                     object obj: Any?,
                     queue: OperationQueue?,
                     using block: @escaping @Sendable (Notification) -> Void) -> any NSObjectProtocol

    func removeObserver(_ observer: Any)
}

// MARK: -

extension NotificationCenter: NotificationCenterProtocol {}

// MARK: -

internal enum NotificationCenterInjector {
    internal static var inject: () -> any NotificationCenterProtocol = { NotificationCenter.`default` }
}
