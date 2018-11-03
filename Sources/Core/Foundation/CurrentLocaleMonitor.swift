//
//  CurrentLocaleMonitor.swift
//  XestiMonitors
//
//  Created by Paul Nyondo on 2018-06-06.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

import Foundation

///
/// A `CurrentLocaleMonitor` instance monitors the system for changes to the
/// user’s locale.
///
public class CurrentLocaleMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates changes to the user’s locale.
    ///
    public enum Event {
        ///
        /// The user’s locale has changed.
        ///
        case didChange
    }

    ///
    /// Initializes a new `CurrentLocaleMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when the user’s locale changes.
    ///
    public init(queue: OperationQueue,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(NSLocale.currentLocaleDidChangeNotification) { [unowned self] _ in
            self.handler(.didChange)
        }
    }
}
