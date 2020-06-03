//
//  BundleResourceRequestMonitor.swift
//  XestiMonitors
//
//  Created by J. G. Pusey on 2018-05-20.
//
//  © 2018 J. G. Pusey (see LICENSE.md)
//

#if os(iOS) || os(tvOS) || os(watchOS)

import Foundation

///
/// A `BundleResourceRequestMonitor` instance monitors the system to detect if
/// the amount of available disk space for on-demand resources is getting low.
///
public class BundleResourceRequestMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates detection of low disk space availability.
    ///
    public enum Event {
        ///
        /// The amount of available disk space is getting low.
        ///
        case lowDiskSpace
    }

    ///
    /// Initializes a new `BundleResourceRequestMonitor`.
    ///
    /// - Parameters:
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when low disk space is detected.
    ///
    public init(queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler

        super.init(queue: queue)
    }

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSBundleResourceRequestLowDiskSpace) { [unowned self] _ in
            self.handler(.lowDiskSpace)
        }
    }
}

#endif
