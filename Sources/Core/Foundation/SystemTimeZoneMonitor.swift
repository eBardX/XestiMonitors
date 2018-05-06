//
//  SystemTimeZoneMonitor.swift
//  XestiMonitors
//
//  Created by Angie Mugo on 2018-05-10
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `SystemTimeZoneMonitor` instance monitors the app for
/// changes in the time zone
///
public class SystemTimeZoneMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the time zone of the location of the
    /// app
    ///
    public enum Event {
        ///
        /// The time zone of the app location has changed.
        ///
        case didChange
    }

    ///
    /// Initializes a new `SystemTimeZoneMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when the time zone chnages.
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
