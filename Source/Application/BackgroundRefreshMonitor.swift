//
//  BackgroundRefreshMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A `BackgroundRefreshMonitor` object monitors the app for changes to its
/// status for downloading content in the background.
///
public class BackgroundRefreshMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    ///
    /// Initializes a new `BackgroundRefreshMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the app’s status for
    ///                 downloading content in the background changes.
    ///
    public init(handler: @escaping (UIBackgroundRefreshStatus) -> Void) {

        self.application = UIApplication.shared
        self.handler = handler

    }

    // MARK: Public Instance Properties

    ///
    /// Whether the app can be launched into the background to handle
    /// background behaviors.
    ///
    public var status: UIBackgroundRefreshStatus { return application.backgroundRefreshStatus }

    // MARK: Private Instance Properties

    private let application: UIApplication
    private let handler: (UIBackgroundRefreshStatus) -> Void

    // MARK: Private Instance Methods

    @objc private func applicationBackgroundRefreshStatusDidChange(_ notification: NSNotification) {

        handler(status)

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                           selector: #selector(applicationBackgroundRefreshStatusDidChange(_:)),
                           name: .UIApplicationBackgroundRefreshStatusDidChange,
                           object: nil)

        return true

    }

}
