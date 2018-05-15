//
//  SystemTimeZoneMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-13.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `SystemTimeZoneMonitor` instance monitors the app for changes
/// to the time zone used by the system
///
public class SystemTimeZoneMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the time zone used by the system.
    ///
    public enum Event {
        ///
        /// The time zone has changed
        ///
        case didChange
    }

    ///
    /// Initializes a new `SystemTimeZoneMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the system time zone
    ///                 changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSSystemTimeZoneDidChange) { [unowned self] _ in
            self.handler(.didChange)
        }
    }
}
