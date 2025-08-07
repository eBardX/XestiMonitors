// © 2016–2025 John Gary Pusey (see LICENSE.md)

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

/// An `AppStateMonitor` instance monitors the app for changes to
/// its runtime state.
public final class AppStateMonitor: BaseNotificationMonitor {
    /// Encapsulates changes to the runtime state of the app.
    public enum Event {
        /// The app has entered the active state.
        case didBecomeActive

        /// The app has entered the background state.
        case didEnterBackground

        /// The app has finished launching.
        case didFinishLaunching([AnyHashable: Any]?)

        /// The app is about to leave the background state.
        case willEnterForeground

        /// The app is about to leave the active state.
        case willResignActive

        /// The app is about to terminate.
        case willTerminate
    }

    /// Initializes a new `ApplicationStateMonitor`.
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the app changes its
    ///                 runtime state or is about to change its runtime
    ///                 state.
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.app = AppInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    /// The runtime state of the app.
    public var state: UIApplication.State {
        app.applicationState
    }

    private let app: any AppProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(UIApplication.didBecomeActiveNotification,
                object: app) { [unowned self] _ in
            self.handler(.didBecomeActive)
        }

        observe(UIApplication.didEnterBackgroundNotification,
                object: app) { [unowned self] _ in
            self.handler(.didEnterBackground)
        }

        observe(UIApplication.didFinishLaunchingNotification,
                object: app) { [unowned self] in
            self.handler(.didFinishLaunching($0.userInfo))
        }

        observe(UIApplication.willEnterForegroundNotification,
                object: app) { [unowned self] _ in
            self.handler(.willEnterForeground)
        }

        observe(UIApplication.willResignActiveNotification,
                object: app) { [unowned self] _ in
            self.handler(.willResignActive)
        }

        observe(UIApplication.willTerminateNotification,
                object: app) { [unowned self] _ in
            self.handler(.willTerminate)
        }
    }
}

#endif
