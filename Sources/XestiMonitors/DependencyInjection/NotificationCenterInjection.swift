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

extension Dependencies {
    internal static let notificationCenterInjected = {
        DependencyResolver.register(NotificationCenter.default as any NotificationCenterProtocol)
    }()
}
