//
//  SystemClockMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-06-04.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `SystemClockMonitor` instance monitors the system for changes to the
/// clock.
///
public class SystemClockMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the system clock.
    ///
    public enum Event {
        ///
        /// The system clock has changed.
        ///
        case didChange
    }

    ///
    /// Initializes a new `SystemClockMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the system clock changes.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    public override func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSSystemClockDidChange) { [unowned self] _ in
            self.handler(.didChange)
        }
    }
}
