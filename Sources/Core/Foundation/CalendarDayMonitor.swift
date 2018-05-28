//
//  CalendarDayMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-05-28.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `CalendarDayMonitor` instance monitors the system for changes to the
/// system calendar day.
///
public class CalendarDayMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the system calendar day.
    ///
    public enum Event {
        ///
        /// The system calendar day has changed
        ///
        case changed
    }

    ///
    /// Initializes a new `CalendarDayMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the system calendar day changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSCalendarDayChanged) { [unowned self] _ in
            self.handler(.changed)
        }
    }
}
