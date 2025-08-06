// © 2018–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import UIKit

/// A `FocusMonitor` instance monitors the app for changes to the current focus
/// in the view hierarchy.
public final class FocusMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the focus in the app’s view hierarchy.
    public enum Event {
        /// The focus has been updated to a new view.
        case didUpdate(Info)

        /// The focus could not be moved in the selected direction.
        case movementDidFail(Info)
    }

    /// Encapsulates information associated with a focus monitor event.
    public struct Info {
        /// Metadata describing the focus-related update or failed movement.
        public let context: UIFocusUpdateContext

        /// The coordinator of focus-related animations to use during a focus
        /// update.
        /// This property is `nil` for `movementDidFail` events.
        public let coordinator: UIFocusAnimationCoordinator?

        fileprivate init?(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let context = userInfo[UIFocusSystem.focusUpdateContextUserInfoKey] as? UIFocusUpdateContext
            else { return nil }

            self.context = context
            self.coordinator = userInfo[UIFocusSystem.animationCoordinatorUserInfoKey] as? UIFocusAnimationCoordinator
        }
    }

    /// Initializes a new `FocusMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the current focus is updated
    ///                 or cannot be moved in the selected direction.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIFocusSystem.didUpdateNotification) { [unowned self] in
            if let info = Info($0) {
                self.handler(.didUpdate(info))
            }
        }

        observe(UIFocusSystem.movementDidFailNotification) { [unowned self] in
            if let info = Info($0) {
                self.handler(.movementDidFail(info))
            }
        }
    }
}

#endif
