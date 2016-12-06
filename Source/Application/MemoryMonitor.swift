//
//  MemoryMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

import Foundation
import UIKit

///
/// A `MemoryMonitor` object monitors the app for memory warnings from the
/// operating system.
///
public class MemoryMonitor: BaseNotificationMonitor {

    // Public Initializers

    ///
    /// Initializes a new `MemoryMonitor`.
    ///
    /// - Parameters:
    ///   - handler:    The handler to call when the app receives a warning
    ///                 from the operating system about low memory availability.
    ///
    public init(handler: @escaping () -> Void) {

        self.handler = handler

    }

    // Private Instance Properties

    private let handler: () -> Void

    // Private Instance Methods

    @objc private func applicationDidReceiveMemoryWarning(_ notification: NSNotification) {

        handler()

    }

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers(_ notificationCenter: NotificationCenter) -> Bool {

        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidReceiveMemoryWarning(_:)),
                                       name: .UIApplicationDidReceiveMemoryWarning,
                                       object: nil)

        return true
    }

}
