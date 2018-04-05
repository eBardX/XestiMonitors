//
//  TimeMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2016-11-23.
//
//  © 2016 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS)

import Foundation
import UIKit

///
/// A `TimeMonitor` instance monitors the app for significant changes in
/// time.
///
public class TimeMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates significant changes in time.
    ///
    public enum Event {
        ///
        /// There has been a significant change in time.
        ///
        case significantChange
    }

    ///
    /// Initializes a new `TimeMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when there is a significant
    ///                 change in time.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.application = ApplicationInjector.inject()
        self.handler = handler

        super.init(queue: queue)
    }

    private let application: ApplicationProtocol
    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.UIApplicationSignificantTimeChange,
                object: application) { [unowned self] _ in
                    self.handler(.significantChange)
        }
    }
}

#endif
