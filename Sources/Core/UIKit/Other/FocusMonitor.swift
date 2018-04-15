//
//  FocusMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-04-09.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import UIKit

///
/// A `FocusMonitor` instance monitors the app for changes to the current focus
/// in the view hierarchy.
///
@available(iOS 11.0, tvOS 11.0, *)
public class FocusMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the focus in the app’s view hierarchy.
    ///
    public enum Event {
        ///
        /// The focus has been updated to a new view.
        ///
        case didUpdate(Info)

        ///
        /// The focus could not be moved in the selected direction.
        ///
        case movementDidFail(Info)
    }

    ///
    /// Encapsulates information associated with a focus monitor event.
    ///
    public struct Info {
        ///
        /// Metadata describing the focus-related update or failed movement.
        ///
        public let context: UIFocusUpdateContext

        ///
        /// The coordinator of focus-related animations to use during a focus
        /// update.
        ///
        /// This property is `nil` for `movementDidFail` events.
        ///
        public let coordinator: UIFocusAnimationCoordinator?

        fileprivate init?(_ notification: Notification) {
            guard
                let userInfo = notification.userInfo,
                let context = userInfo[UIFocusUpdateContextKey] as? UIFocusUpdateContext
                else { return nil }

            self.context = context
            self.coordinator = userInfo[UIFocusUpdateAnimationCoordinatorKey] as? UIFocusAnimationCoordinator
        }
    }

    ///
    /// Specifies which events to monitor.
    ///
    public struct Options: OptionSet {
        ///
        /// Monitor `didUpdate` events.
        ///
        public static let didUpdate = Options(rawValue: 1 << 0)

        ///
        /// Monitor `movementDidFail` events.
        ///
        public static let movementDidFail = Options(rawValue: 1 << 1)

        ///
        /// Monitor all events.
        ///
        public static let all: Options = [.didUpdate,
                                          .movementDidFail]

        /// :nodoc:
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// :nodoc:
        public let rawValue: UInt
    }

    ///
    /// Initializes a new `FocusMonitor`.
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
        self.handler = handler
        self.options = options

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void
    private let options: Options

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didUpdate) {
            observe(.UIFocusDidUpdate) { [unowned self] in
                if let info = Info($0) {
                    self.handler(.didUpdate(info))
                }
            }
        }

        if options.contains(.movementDidFail) {
            observe(.UIFocusMovementDidFail) { [unowned self] in
                if let info = Info($0) {
                    self.handler(.movementDidFail(info))
                }
            }
        }
    }
}

#endif
