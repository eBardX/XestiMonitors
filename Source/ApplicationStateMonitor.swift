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
        case didFinishLaunching([AnyHashable: Any]?)

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

    ///
    ///
    ///
    public struct Options: OptionSet {
        ///
        ///
        ///
        public static let didBecomeActive = Options(rawValue: 1 << 0)

        ///
        ///
        ///
        public static let didEnterBackground = Options(rawValue: 1 << 1)

        ///
        ///
        ///
        public static let didFinishLaunching = Options(rawValue: 1 << 2)

        ///
        ///
        ///
        public static let willEnterForeground = Options(rawValue: 1 << 3)

        ///
        ///
        ///
        public static let willResignActive = Options(rawValue: 1 << 4)

        ///
        ///
        ///
        public static let willTerminate = Options(rawValue: 1 << 5)

        ///
        ///
        ///
        public static let all: Options = [.didBecomeActive,
                                          .didEnterBackground,
                                          .didFinishLaunching,
                                          .willEnterForeground,
                                          .willResignActive,
                                          .willTerminate]

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        public let rawValue: UInt
    }

    ///
    /// Initializes a new `ApplicationStateMonitor`.
    ///
    /// - Parameters:
    ///   - notificationCenter:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - application:
    ///   - options:
    ///   - handler:    The handler to call when the app changes its runtime
    ///                 state or is about to change its runtime state.
    ///
    public init(notificationCenter: NotificationCenter = NSNotificationCenter.`default`,
                queue: OperationQueue = .main,
                application: Application = UIApplication.shared,
                options: Options = .all,
                handler: @escaping (Event) -> Void) {
        self.application = application
        self.handler = handler
        self.options = options

        super.init(notificationCenter: notificationCenter,
                   queue: queue)
    }

    ///
    /// The runtime state of the app.
    ///
    public var state: UIApplicationState {
        return application.applicationState
    }

    private let application: Application
    private let handler: (Event) -> Void
    private let options: Options

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        if options.contains(.didBecomeActive) {
            observe(.UIApplicationDidBecomeActive) { [unowned self] _ in
                self.handler(.didBecomeActive)
            }
        }

        if options.contains(.didEnterBackground) {
            observe(.UIApplicationDidEnterBackground) { [unowned self] _ in
                self.handler(.didEnterBackground)
            }
        }

        if options.contains(.didFinishLaunching) {
            observe(.UIApplicationDidFinishLaunching) { [unowned self] in
                self.handler(.didFinishLaunching($0.userInfo))
            }
        }

        if options.contains(.willEnterForeground) {
            observe(.UIApplicationWillEnterForeground) { [unowned self] _ in
                self.handler(.willEnterForeground)
            }
        }

        if options.contains(.willResignActive) {
            observe(.UIApplicationWillResignActive) { [unowned self] _ in
                self.handler(.willResignActive)
            }
        }

        if options.contains(.willTerminate) {
            observe(.UIApplicationWillTerminate) { [unowned self] _ in
                self.handler(.willTerminate)
            }
        }
    }
}
