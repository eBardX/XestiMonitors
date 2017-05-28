//
//  ApplicationStateMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// An `ApplicationStateMonitor` instance monitors the app for changes to its
/// runtime state.
///
public class ApplicationStateMonitor: BaseNotificationMonitor {

    // Public Nested Types

    ///
    /// Encapsulates changes to the runtime state of the app.
    ///
    public enum Event {

        ///
        /// The app has entered the active state.
        ///
        case didBecomeActive

        ///
        /// The app has entered the background state.
        ///
        case didEnterBackground

        ///
        /// The app has finished launching.
        ///
        case didFinishLaunching([AnyHashable : Any]?)

        ///
        /// The app is about to leave the background state.
        ///
        case willEnterForeground

        ///
        /// The app is about to leave the active state.
        ///
        case willResignActive

        ///
        /// The app is about to terminate.
        ///
        case willTerminate
    }

    // Public Initializers

    ///
    /// Initializes a new `ApplicationStateMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the app changes its runtime
    ///                 state or is about to change its runtime state.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.application = .shared
        self.handler = handler

        super.init(queue: queue)

    }

    // Public Instance Properties

    ///
    /// The runtime state of the app.
    ///
    public var state: UIApplicationState { return application.applicationState }

    // Private Instance Properties

    private let application: UIApplication
    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIApplicationDidBecomeActive) { [unowned self] _ in
            self.handler(.didBecomeActive)
        }

        observe(.UIApplicationDidEnterBackground) { [unowned self] _ in
            self.handler(.didEnterBackground)
        }

        observe(.UIApplicationDidFinishLaunching) { [unowned self] in
            self.handler(.didFinishLaunching($0.userInfo))
        }

        observe(.UIApplicationWillEnterForeground) { [unowned self] _ in
            self.handler(.willEnterForeground)
        }

        observe(.UIApplicationWillResignActive) { [unowned self] _ in
            self.handler(.willResignActive)
        }

        observe(.UIApplicationWillTerminate) { [unowned self] _ in
            self.handler(.willTerminate)
        }

        return true

    }

}
