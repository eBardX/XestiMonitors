//
//  TimeMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `TimeMonitor` object monitors the app for significant changes in time.
///
public class TimeMonitor: BaseNotificationMonitor {

    // Public Initializers

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

    // Private Instance Properties

    private let handler: () -> Void

    // Private Instance Methods

    @objc private func applicationSignificantTimeChange(_ notification: Notification) {

        handler()

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        guard super.addNotificationObservers(notificationCenter) else { return false }

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationSignificantTimeChange(_:)),
                                       name: .UIApplicationSignificantTimeChange,
                                       object: nil)

        return true

    }

}
