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
/// A `BundleResourceRequestMonitor` instance monitors ...
///
public class BundleResourceRequestMonitor: BaseNotificationMonitor {
    ///
    /// Encapsulates ...
    ///
    public enum Event {
        ///
        ///
        ///
        case lowDiskSpace(NSBundleResourceRequest)
    }

    ///
    /// Initializes a new `BundleResourceRequestMonitor`.
    ///
    /// - Parameters:
    ///   - request:    The bundle resource request to monitor.
    ///   - queue:      The operation queue on which the handler executes.
    ///                 By default, the main operation queue is used.
    ///   - handler:    The handler to call when ...
    ///
    public init(request: NSBundleResourceRequest,
                queue: OperationQueue = .main,
                handler: @escaping (Event) -> Void) {
        self.handler = handler
        self.request = request

        super.init(queue: queue)
    }

    ///
    /// The bundle resource request being monitored.
    ///
    public let request: NSBundleResourceRequest

    private let handler: (Event) -> Void

    override public func addNotificationObservers() {
        super.addNotificationObservers()

        observe(.NSBundleResourceRequestLowDiskSpace,
                object: request) { [unowned self] in
                    if let request = $0.object as? NSBundleResourceRequest {
                        self.handler(.lowDiskSpace(request))
                    }
        }
    }
}

#endif
