//
//  ApplicationStateMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// An `ApplicationStateMonitor` object monitors the app for changes to its runtime
/// state.
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

    // MARK: Public Initializers

    ///
    /// Initializes a new `ApplicationStateMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the app changes its runtime
    ///                 state or is about to change its runtime state.
    ///
    public init(handler: @escaping (Event) -> Void) {

        self.handler = handler

    }

    // MARK: Public Instance Properties

    ///
    /// The runtime state of the app.
    ///
    public var state: UIApplicationState { return UIApplication.shared.applicationState }

    // MARK: Private Instance Properties

    private let handler: (Event) -> Void

    // MARK: Private Instance Methods

    @objc private func applicationDidBecomeActive(_ notification: NSNotification) {

        handler(.didBecomeActive)

    }

    @objc private func applicationDidEnterBackground(_ notification: NSNotification) {

        handler(.didEnterBackground)

    }

    @objc private func applicationDidFinishLaunching(_ notification: NSNotification) {

        handler(.didFinishLaunching(notification.userInfo))

    }

    @objc private func applicationWillEnterForeground(_ notification: NSNotification) {

        handler(.willEnterForeground)

    }

    @objc private func applicationWillResignActive(_ notification: NSNotification) {

        handler(.willResignActive)

    }

    @objc private func applicationWillTerminate(_ notification: NSNotification) {

        handler(.willTerminate)

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                           selector: #selector(applicationDidBecomeActive(_:)),
                           name: .UIApplicationDidBecomeActive,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationDidEnterBackground(_:)),
                           name: .UIApplicationDidEnterBackground,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationDidFinishLaunching(_:)),
                           name: .UIApplicationDidFinishLaunching,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationWillEnterForeground(_:)),
                           name: .UIApplicationWillEnterForeground,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationWillResignActive(_:)),
                           name: .UIApplicationWillResignActive,
                           object: nil)

        center.addObserver(self,
                           selector: #selector(applicationWillTerminate(_:)),
                           name: .UIApplicationWillTerminate,
                           object: nil)

        return true

    }

}
