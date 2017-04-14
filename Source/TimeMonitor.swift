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

    // Public Nested Types

    ///
    /// Encapsulates significant changes in time.
    ///
    public enum Event {
        ///
        /// There has been a significant change in time.
        ///
        case significantChange
    }

    // Public Initializers

    ///
    /// Initializes a new `TimeMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes. By
    ///                 default, the main operation queue is used.
    ///   - handler:    The handler to call when there is a significant change
    ///                 in time.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {

        self.handler = handler

        super.init(queue: queue)

    }

    // Private Instance Properties

    private let handler: (Event) -> Void

    // Overridden BaseNotificationMonitor Instance Methods

    public override func addNotificationObservers() -> Bool {

        guard super.addNotificationObservers()
            else { return false }

        observe(.UIApplicationSignificantTimeChange) { [unowned self] _ in
            self.handler(.significantChange)
        }

        return true

    }

}
