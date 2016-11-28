//
//  TimeMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

///
/// A `TimeMonitor` object monitors the app for significant changes in time.
///
public class TimeMonitor: BaseNotificationMonitor {

    // MARK: Public Initializers

    ///
    /// Initializes a new `TimeMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when there is a significant change
    ///                 in time.
    ///
    public init(handler: @escaping () -> Void) {

        self.handler = handler

    }

    // MARK: Private Instance Properties

    private let handler: () -> Void

    // MARK: Private Instance Methods

    @objc private func applicationSignificantTimeChange(_ notification: NSNotification) {

        handler()

    }

    // MARK: Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ center: NotificationCenter) -> Bool {

        center.addObserver(self,
                           selector: #selector(applicationSignificantTimeChange(_:)),
                           name: .UIApplicationSignificantTimeChange,
                           object: nil)

        return true

    }

}
